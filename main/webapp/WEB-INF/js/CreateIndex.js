var interval;
var progressingValue=0;
if(progressingValue<100) interval=setInterval(getProgress,2000);
var indexFilePathIndex;
var checkedMap=new Map();
var sendIndexRequest;
var foldersList=[];
var indexFoldersList=[];
var foldersToBeIndexList=[];
var interval;
var isStopWordsFile=false;
var app = angular.module('myApp', []);
 app.controller('customersCtrl', function($scope,$http) {
$http.get("/getListOfFoldersToBeIndex").then(function(response){
		$scope.names=response.data;
		foldersList=response.data;
});
$http.get("/getListOfFoldersIndexPath").then(function(response){
	$scope.foldersToBeIndex=response.data;
	foldersToBeIndexList=response.data;
});
sendIndexRequest=$http;
 $scope.check=function(index)
 {
	if(checkedMap.has(index))
		{
		checkedMap.delete(index);
		}
	else
		{
checkedMap.set(index,index);
		}
 }
 $scope.checkIndexFilePath=function(index)
 {
	 indexFilePathIndex=index;
 }
 });
function uploadFile()
{
    var data = new FormData();
    var stopWordsFile=document.getElementById('stopWordsFile').files[0];
data.append("stopWordsFile",stopWordsFile);
    sendIndexRequest({
		 method: 'POST',
		 url: '/setStopWordsFile',
		 transformRequest: angular.identity,
		 headers: {
             'Content-Type': undefined
         },
		 data: data,
    }).then(function(response)
	{
    	alert('File uploaded');
	},	
function(error){
					alert('Error '+error);
});
}
 function submitIndexFolders()
{
	var data=[];
	var i=0;
	for (var [key, value] of checkedMap) {
		data[i]=foldersList[key];
		i++;
		}
	var indexFilePath=foldersToBeIndexList[indexFilePathIndex];
	var stopWordsFile=document.getElementById('stopWordsFile').files[0];
	var fileUploaded=false;
	if(data.length==0) 
	{
$("#foldersToBeIndexSpan").html("Please select folder(s) to be Index");
return;
	}
	if(indexFilePath==undefined)
{
		$("#indexFilePathSpan").html("Please select folder Where index will be created");
		return;		
		}
	if(isStopWordsFile==false && stopWordsFile==undefined)
		{
		$("#stopWordsSpan").html("Please select stop words options");
		return;				
		}
		if(stopWordsFile!=undefined)
		{
fileUploaded=true;
			uploadFile();
		}
	alert("isStopWordsFile :"+isStopWordsFile);
	sendIndexRequest({
		 method: 'POST',
		 url: 'setFileIndexData',
		 contentType: "application/json",
		 data: {
			 indexFilePath:indexFilePath,
				 indexFoldersList:data,
				 fileUploaded:fileUploaded
		 }
		}).then(function(response)
				{
			window.location.href="/index";
				},
		function(error){
					alert('Error '+error);
				});
	interval=setInterval(getProgress,2000);
}
function getProgress()
{
	sendIndexRequest({
		 method: 'GET',
		 url: '/getProgressing',
		}).then(function(response)
				{
			if(response.data<=100)
				{
		      $("#dynamic").css("width", response.data + "%").attr("aria-valuenow", response.data).text(response.data + "% Complete");
		      progressingValue=response.data;
				}
		      if(response.data>=100)
	{
	 clearInterval(interval);
	}
				},
		function(error){
					alert('Error '+error);
				});
	}
$(document).ready(function(){
    $('input[type="checkbox"]').click(function(){
        if($(this).prop("checked") == true){
isStopWordsFile=true;
}
        else if($(this).prop("checked") == false){
isStopWordsFile=false;
}
    });
});
