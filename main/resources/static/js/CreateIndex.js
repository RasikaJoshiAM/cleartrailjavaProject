	var interval;
var progressingValue=0;
var isIndexingDone;
interval=setInterval(getProgress,2000);
var indexFilePathIndex;
var checkedMap=new Map();
var sendIndexRequest;
var foldersList=[];
var indexFoldersList=[];
var foldersToBeIndexList=[];
var interval;
var isStopWordsFile=false;
var filesListScope;
var tokensListScope;
var myApp = angular.module('myApp', []);
myApp.controller('customersCtrl', function($scope,$http) {
	createIndexScope=$scope;
	$http.get("/getListOfFoldersToBeIndex").then(function(response){
		checkedMap=new Map();
		$scope.names=response.data;
		foldersList=response.data;
		$scope.uncheckFoldersToBeIndex();
		$scope.uncheckFoldersWhereIndexCreated();
	},
function(error)
{
	//$.notify("Error At Server side","error");
});
$http.get("/getListOfFoldersIndexPath").then(function(response){
	$scope.foldersToBeIndex=response.data;
	foldersToBeIndexList=response.data;
	$scope.uncheckFoldersToBeIndex();
	$scope.uncheckFoldersWhereIndexCreated();
},
function(error)
{
	//$.notify("Error At Server side","error");
	});
$scope.getListOfFoldersToBeIndex=function()
{
	$http.get("/getListOfFoldersToBeIndex").then(function(response){
		$scope.names=response.data;
		foldersList=response.data;
		$scope.uncheckFoldersToBeIndex();
		$scope.uncheckFoldersWhereIndexCreated();
		checkedMap.clear();
},
function(error){
	//$.notify("Error At Server side","error");
});
}
	$scope.getListOfFoldersIndexPath=function()
	{
		$http.get("/getListOfFoldersIndexPath").then(function(response){
			$scope.foldersToBeIndex=response.data;
			foldersToBeIndexList=response.data;
			$scope.uncheckFoldersToBeIndex();
			$scope.uncheckFoldersWhereIndexCreated();
			checkedMap.clear();
		},
		function(error){
			//$.notify("Error At Server side","error");
		});		
	}
sendIndexRequest=$http;
$scope.uncheckFoldersToBeIndex=function()
{

	for(i=0;i<foldersList.length;i++)
	{
		$("#foldersToBeIndexCheckbox"+i).prop("checked",false);
	}
}
$scope.uncheckFoldersWhereIndexCreated=function()
{
	for(i=0;i<foldersToBeIndexList.length;i++)
	{
	$("#folderWhereIndexCreated"+i).prop("checked",false);
	}
}
$scope.submitIndexFolders=function()
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
		$("#stopWordsSpan").html("Please select stop words option");
		return;				
		}
		if(stopWordsFile!=undefined)
		{
fileUploaded=true;
			uploadFile();
		}
		checkedMap.clear();
$('#submitButton').prop('disabled',true);
		$http({
		 method: 'POST',
		 url: '/setFileIndexData',
		 contentType: "application/json",
		 data: {
			 indexFilePath:indexFilePath,
				 indexFoldersList:data,
				 fileUploaded:fileUploaded
		 }
		}).then(function(response)
				{
$("#dynamic").css("width", 100 + "%").attr("aria-valuenow", 100).text(100 + "% Complete");
closeProgressingInterval();
$scope.uncheckFoldersToBeIndex();
$scope.uncheckFoldersWhereIndexCreated();
$scope.name=response.data.result;
foldersList=response.data.result;
$('#indexFilePathSpan').text("");
$('#foldersToBeIndexSpan').text("");
$('#stopWordsSpan').text("");
$("#dynamic").css("width", 0 + "%").attr("aria-valuenow", 0).text(0 + "% Complete");
$('#createIndexDiv').hide();
$('#imageDiv').show();
$.notify('Indexing Completed Successfully',"success");
$('#submitButton').prop('disabled',false);
},
		function(error){
					//$.notify("Error At Server side","error");
		});
	interval=setInterval(getProgress,2000);
	}
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
console.log("File uploaded :"+JSON.stringify(response));
	},	
function(error){
		//$.notify("Error At Server side in uploading file","error");
});
}
 function closeProgressingInterval()
 {
	clearInterval(interval); 
 }
function getProgress()
{
if(sendIndexRequest!=undefined)
	{
	sendIndexRequest({
		 method: 'GET',
		 url: '/getProgressing',
		}).then(function(response)
				{
if(response.data>0 && response.data<100)
	{
	$('#submitButton').prop('disabled',true);
	}
			if(response.data<=100)
				{
 $("#dynamic").css("width", response.data + "%").attr("aria-valuenow", response.data).text(response.data + "% Complete");
		      progressingValue=response.data;
				}
			if(response.data==100)
				{
				$('#submitButton').prop('disabled',false);
				$("#dynamic").css("width", 0 + "%").attr("aria-valuenow", 0).text(0 + "% Complete");
				clearInterval(interval);
				}
				},
		function(error){
					//$.notify("Error At Server side","error");
				});
	}
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
function disableSubmitButton()
{
	alert('disable function called');
	document.getElementById("submitButton").disabled = true;	
}