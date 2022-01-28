<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Training Assignment</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.12.4.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
<script>
var interval;
var indexFilePathIndex;
var checkedMap=new Map();
var sendIndexRequest;
var foldersList=[];
var indexFoldersList=[];
var foldersToBeIndexList=[];
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
function submitIndexFolders()
{
	var data=[];
	var i=0;
	for (var [key, value] of checkedMap) {
		data[i]=foldersList[key];
		i++;
		}
	var indexFilePath=foldersToBeIndexList[indexFilePathIndex];
	var stopWordsFile=document.getElementById('stopWordsFile').value;
	var defaultStopWords=document.getElementById('defaultStopWords').value;
var isStopWordsFile=true;
	if(defaultStopWords=="on")
		{
		isStopWordsFile=false;
		}
	sendIndexRequest({
		 method: 'POST',
		 url: 'setFileIndexData',
		 contentType: "application/json",
		 data: {
			 indexFilePath:indexFilePath,
				 indexFoldersList:data,
				 stopWordsFile: stopWordsFile,
				 isStopWordsFile:isStopWordsFile
		 }
		}).then(function(response)
				{
			alert('Request send successfully :'+JSON.stringify(response));
				},
		function(error){
					alert('Error '+error);
				});
}
	function check(index)
	{
		alert('Check function callled :'+index);
	}
	var i=0;
	function progress()
	{
		$( "#progressbar" ).progressbar({
			  value: i,
			});
document.getElementById('progressPercentage').innerHTML=i;
		i+=10;
if(i>100) 
	{
	$( "#progressbar" ).progressbar("destroy");
	clearInterval(interval);
	document.getElementById('progressPercentage').innerHTML="";	
	}
	}
	function openModal()
	{
		$('#ex1').dialog('open');
	}
	function setWidthAndHeight()
	{
		$( "#progressbar" ).css("maxWidth","1%");		
	}
//interval=window.setInterval(progress, 1000);
//window.onLoad=setWidthAndHeight;
	</script>

</head>
<body ng-app="myApp">
    <jsp:include page='/MasterPageTopSection' />
	<div>
		<table>
			<tbody>
				<tr>
					<td>
						<h3>Select Folders To Be index</h3>
						<table border="1" id="myTable" ng-controller="customersCtrl">
							<thead>
								<tr>
									<th></th>
									<th>Folders to Be Index</th>
								</tr>
							</thead>
							<tbody ng-repeat="entity in names">
								<tr>
									<td>{{$index+1}}</td>
									<td>{{entity}}</td>
									<td><input type="checkbox" id="checkbox"
										+{{$index}} ng-click="check($index)"></td>
								</tr>
							</tbody>
						</table>
					</td>
					<td>
						<h3>Select Folders Where Index Will Be Created</h3>
						<table border="1" id="myTable" ng-controller="customersCtrl">
							<thead>
								<tr>
									<th></th>
									<th>Folders Where Index can be Created</th>
								</tr>
							</thead>
							<tbody ng-repeat="entity in foldersToBeIndex">
								<tr>
									<td>{{$index+1}}</td>
									<td>{{entity}}</td>
									<td><input type="checkbox" id="checkbox"
										+{{$index}} ng-click="checkIndexFilePath($index)"></td>
								</tr>
							</tbody>
						</table>
					</td>
					<td><span></span></td>
					<td><span></span></td>
					<td><label>Upload a file of stop words with space
							seperated words</label> <input type="file" id="stopWordsFile"
						name="stopWordsFile"> <br></br> <label>Use default
							stop words</label> <input type="checkbox" id="defaultStopWords"
						name="defaultStopWords"></td>
				</tr>
				<td><span>&nbsp;</span></td>
				<tr>
					<td><button type="button" onclick="submitIndexFolders()">Submit</button></td>
				</tr>
				<td><a href="/index">Home</a></td>
	
				

			</tbody>
		</table>
	</div>
	<div>	
	<div id="progressbar" name="progressbar"></div>
	<span id="progressPercentage" name="progressPercentage">&nbsp;</span>
	</div>
	    <jsp:include page='/MasterPageBottomSection' />
</body>
</html>