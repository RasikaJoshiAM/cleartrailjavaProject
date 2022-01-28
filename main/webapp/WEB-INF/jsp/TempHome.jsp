<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
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
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="/canvasjs.min.js"></script>
<script
	src="https://cdn.anychart.com/releases/v8/js/anychart-base.min.js"></script>
<script
	src="https://cdn.anychart.com/releases/v8/js/anychart-tag-cloud.min.js"></script>
</head>
<style>
.sidenav {
	z-index: 1;
	top: 0;
	left: 0;
	background-color: #111;
	overflow-x: hidden;
	padding-top: 20px;
}

.sidenav a {
	padding: 6px 8px 6px 16px;
	text-decoration: none;
	font-size: 25px;
	color: #818181;
	display: block;
}

.sidenav a:hover {
	color: #f1f1f1;
}

.main {
	margin-left: 160px; /* Same as the width of the sidenav */
	font-size: 28px; /* Increased text to enable scrolling */
	padding: 0px 10px;
}

@media screen and (max-height: 450px) {
	.sidenav {
		padding-top: 15px;
	}
	.sidenav a {
		font-size: 18px;
	}
}

#container {
	width: 100%;
	height: 100%;
	margin: 0;
	padding: 0;
}
</style>
<script>
var createIndexScope;
var localScopeTokensList;
	window.onload = function() {
		$("#filesListDiv").hide();
		$("#createIndexDiv").hide();
	}
	
	//CreateIndex.js Code has been written
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
console.log("File uploaded :"+JSON.stringify(response));
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
 function closeProgressingInterval()
 {
	clearInterval(interval); 
 }
function getProgress()
{
	sendIndexRequest({
		 method: 'GET',
		 url: '/getProgressing',
		}).then(function(response)
				{
			if(response.data<100)
				{
 $("#dynamic").css("width", response.data + "%").attr("aria-valuenow", response.data).text(response.data + "% Complete");
		      progressingValue=response.data;
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
//FilesList.js code has been written
	var scope;
	var localScope;
	var stompClient = null;
	var filterCategories = [ "path", "name", "size", "lastModified","All Files" ];
	var fromSize=1;
	var toSize=1;
	var filesList=[];
	function setConnected(connected) {
		//alert('Set connected called');
	}

	function connect() {
		var socket = new SockJS('/gs-guide-websocket');
		stompClient = Stomp.over(socket);
		stompClient.connect({},onConnected, onError);
	}
	function onConnected() {
		setConnected(true);
		sendName();
		stompClient.subscribe('/topic/greetings', function(greeting) {
			localScope.setList();
		});
	}
	function disconnect() {
		if (stompClient !== null) {
			stompClient.disconnect();
		}
		setConnected(false);
		console.log("Disconnected");
	}

	function sendName() {
		stompClient.send("/app/hello", {});
	}

	function showGreeting(message) {
		alert('Show greetings function called');
	}
	function calculateSize(filesList) {
		for (i = 0; i < filesList.length; i++) {
			var fileStatistics = filesList[i];
			if (fileStatistics.size < 1024) {
				size = fileStatistics.size;
				fileStatistics.size = size + "B";
			} else {
				if (fileStatistics.size >= 1024 && fileStatistics.size < 1024 * 1024) {
					size = fileStatistics.size;
					size = (size / 1024);
					size = size.toFixed(2);
					fileStatistics.size = size + "KB";
				} else {
					if (fileStatistics.size >= 1024 * 1024 && fileStatistics.size < 1024 * 1024 * 1024) {
						size = fileStatistics.size;
						size = (size / (1024 * 1024));
						size = size.toFixed(2);
						fileStatistics.size = size + "MB";
					}
					else
						{
						if (fileStatistics.size >= 1024 * 1024*1024 && fileStatistics.size < 1024 * 1024 * 1024* 1024) {
							size = fileStatistics.size;
							size = (size / (1024 * 1024*1024));
							size = size.toFixed(2);
							fileStatistics.size = size + "GB";
						}
						
						}
				}
			}
		}
		return filesList;
	}
	myApp.controller('filesListCtrl',function($scope, $http) {
		$http.get("/getFilesList").then(function(response) {
							filesList = response.data.result;
							var size;
							filesList = calculateSize(filesList);
							$scope.filesList = filesList;
						});
						localScope = $scope;
						$scope.getFile = function(filePath, fileName) {
							filePath = filePath + "\\" + fileName;
							var content;
							$.ajax({
								type : 'POST',
								url : '/getFileByPath',
								data : filePath,
								success : function(response) {
									content = response.result;
									var $iframe = $('#fileFrame');
									$iframe.ready(function() {
										var iFrame = $iframe.contents().find("body");
										iFrame.html(content);
									});
								},
								error : function(error) {
									alert('It is an error');
								}
							});
						}
						$scope.setList = function() {
							$http.get("/getFilesList").then(function(response) {
								$scope.filesList = response.data.result;
							});
						}
						$scope.fromSize=function(fs)
						{
							fromSize=fs;
						}
						$scope.toSize=function(ts)
						{
							toSize=ts;
						}
						$scope.search=function()
						{
							var token=$('#token').val();
							var fromSizeValue=$('#fromSize').val();
							var toSizeValue=$('#toSize').val();
							var fromSizeUnit;
							var toSizeUnit=toSize;	
							alert("From size :"+fromSize);
if(fromSize==2) 
	{
	fromSizeValue=fromSizeValue*1024;
	}
if(fromSize==3) 
	{
	fromSizeValue=fromSizeValue*1024*1024;
	}
if(fromSize==4) 
	{
	fromSizeValue=fromSizeValue*1024*1024*1024;
	}
if(toSize==2) 
	{
	toSizeValue=toSizeValue*1024;
	}
if(toSize==3) 
	{
	toSizeValue=toSizeValue*1024*1024;
	}
if(toSize==4) 
	{
	toSizeValue=toSizeValue*1024*1024*1024;
	}
							var fromDate=$('#fromDate').val();
							fromDate=new Date(fromDate);
							var toDate=$('#toDate').val();
							toDate=new Date(toDate);
							console.log("Token :"+token+", From size value :"+fromSizeValue+", To size value :"+toSizeValue+", From Size Unit :"+fromSizeUnit+", To size unit :"+toSizeUnit+", From date :"+fromDate+", To date :"+toDate);
							let data={
							fromDate:fromDate,
							toDate:toDate,
							token:token,
							fromSize:fromSizeValue,
							toSize:toSizeValue,
							};
							$http.post("/setDate",data).then(function(response) {
								if(response.data.result.length==0)
									{
									$scope.filesList=[];
									}
								else
									{
								$scope.filesList = response.data.result;
								$scope.filesList=calculateSize($scope.filesList);
									}
									});

						}
						$scope.filterFiles = function(filterIndex) {
							$http.post("/getFilterFiles",filterCategories[filterIndex - 1]).then(function(response) {
												filesList = calculateSize(response.data.result);
												$scope.filesList = filesList;
											});

						}
						connect();
					});
	function filterFiles(filterIndex) {

	}
	function onError() {
		alert("Could not connect to server.Please refresh the server");
	}
	function fromSize(size)
	{
		fromSize=size;
	}
	function toSize(size)
	{
		toSize=size;
	}
	var searchText = null;
	var localScopeTokensList;
	var filterCategoriesTokensList = [ "name", "frequencyCount", "frequencyPercentage" ];
	function setConnected(connected) {
		console.log('Set connected called');
	}

	function connect() {
		var socket = new SockJS('/gs-guide-websocket');
		stompClient = Stomp.over(socket);
		stompClient.connect({},onConnected, onError);
	}
function onConnected()
{
	setConnected(true);
	sendName();
	stompClient.subscribe('/topic/greetings', function(greeting) {
		localScopeTokensList.setList();
	});
}
	
	function onError()
	{
	alert("Could not connect to server,Please refresh the page.");	
	}
	function disconnect() {
		if (stompClient !== null) {
			stompClient.disconnect();
		}
		setConnected(false);
		console.log("Disconnected");
	}

	function sendName() {
		stompClient.send("/app/hello", {});
	}

	function showGreeting(message) {
		alert('Show greetings function called');
	}
function fixFrequency(tokensList)
{
for(i=0;i<tokensList.length;i++)
	{
	tokenStatistics=tokensList[i];
	tokenStatistics.frequencyPercentage=tokenStatistics.frequencyPercentage.toFixed(2);
	}
return tokensList;
}
function filterTokens()
{
	
}
	myApp.controller('tokensListCtrl', function($scope, $http) {
	$http.get("/getTokensList").then(function(response) {
		$scope.tokensList=fixFrequency(response.data.result);
		alert("Data :"+JSON.stringify($scope.tokensList));
		$("#loadingImage").hide();
		$("#loadingSpan").text("");
	});	
		connect();
		localScopeTokensList = $scope;
		$scope.setList = function() {
			$http.get("/getTokensList").then(function(response) {
				$scope.tokensList=fixFrequency(response.data.result);
			});
		}
		$scope.filterTokens = function(filterIndex) {
			$("#loadingImage").show();
			$("#loadingSpan").text("loading....");
			$http.post("/getFilterTokens",filterCategoriesTokensList[filterIndex - 1]).then(function(response) {
				$scope.tokensList=fixFrequency(response.data.result);
				$("#loadingImage").hide();
				$("#loadingSpan").text("");
			});
		}
	});

	
	
	function showPage(page) {
		if (page == 1) {
			$("#createIndexDiv").show();
			$("#filesListDiv").hide();
			$("#tokensListDiv").hide();
$("#searchFileFromTokensDiv").hide();
$("#wordCloudDiv").hide();
$("#chartsDiv").hide();
		}
		if (page == 3) {
			$("#createIndexDiv").attr("disabled", "disabled");
			$("#createIndexDiv").hide();
			$("#filesListDiv").show();
			$("#tokensListDiv").hide();
			$("#searchFileFromTokensDiv").hide();
			$("#wordCloudDiv").hide();
			$("#chartsDiv").hide();
			closeProgressingInterval();
		}
		if(page==2)
			{
			$("#createIndexDiv").hide();
			$("#filesListDiv").hide();
			$("#tokensListDiv").show();
			$("#searchFileFromTokensDiv").hide();
			$("#wordCloudDiv").hide();
			$("#chartsDiv").hide();
			closeProgressingInterval();
			}
	if(page==4)
		{
		$("#searchFileFromTokensDiv").show();
		$("#createIndexDiv").hide();
		$("#filesListDiv").hide();
		$("#tokensListDiv").hide();
		$("#wordCloudDiv").hide();
		$("#chartsDiv").hide();
		closeProgressingInterval();
		}
	if(page==5)
		{
		$("#searchFileFromTokensDiv").hide();
		$("#createIndexDiv").hide();
		$("#filesListDiv").hide();
		$("#tokensListDiv").hide();
		$("#wordCloudDiv").show();
		$("#chartsDiv").hide();
		closeProgressingInterval();
		}
	if(page==6)
		{
		$("#searchFileFromTokensDiv").hide();
		$("#createIndexDiv").hide();
		$("#filesListDiv").hide();
		$("#tokensListDiv").hide();
		$("#wordCloudDiv").hide();
		$("#chartsDiv").show();
		closeProgressingInterval();
		}
	}
	
</script>
<body ng-app="myApp">
	<jsp:include page='/MasterPageTopSectionNew' />
	<div class="row">
		<div class="col-sm-2" style="height: 800px; width: 200px">
			<div class="sidenav" style="height: 800px; width: 200px">
				<a href="javascript:showPage(1)">Create Index </a> <a
					href="javascript:showPage(2)">Tokens List</a> <a
					href="javascript:showPage(3)">Files List</a> <a
					href="javascript:showPage(4)">Search File</a> <a
					href="javascript:showPage(5)">Word Cloud</a> <a
					href="javascript:showPage(6)">Different Charts</a>
			</div>
		</div>
		<div id="filesListDiv"	ng-controller="filesListCtrl"  class="col-sm-15">
			<div>
				<h1>Files list</h1>
				<div>
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<div class="col-sm-1">
						<span>&nbsp;</span>
					</div>
					<div class="dropdown col-sm-1">
						<button type="button" class="btn btn-secondary dropdown-toggle"
							data-toggle="dropdown">Sort By</button>
						<div class=" dropdown-menu">
							<a class="dropdown-item" ng-click="filterFiles(1)">File Path</a>
							<a class="dropdown-item" ng-click="filterFiles(2)">File Name</a>
							<a class="dropdown-item" ng-click="filterFiles(3)">Size</a> <a
								class="dropdown-item" ng-click="filterFiles(4)">Last
								Modified</a> <a class="dropdown-item" ng-click="filterFiles(5)">All
								Files</a>
						</div>
					</div>
					<div class="col-sm-1">
						<h5>Token :</h5>
					</div>
					<div class="col-sm-1">
						<input type="text" id="token" name="token" style="width: 100px"
							placeholder="Write Token">
					</div>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<div class="col-sm-1">
						<h5>From Size:</h5>
					</div>
					<div class="col-sm-1">
						<input type="text" id="fromSize" name="fromSize"
							style="width: 100px" placeholder="From size">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary dropdown-toggle"
							data-toggle="dropdown">Size</button>
						<div class="dropdown-menu">
							<a class="dropdown-item" ng-click="fromSize(1)">B</a> <a
								class="dropdown-item" ng-click="fromSize(2)">KB</a> <a
								class="dropdown-item" ng-click="fromSize(3)">MB</a> <a
								class="dropdown-item" ng-click="fromSize(4)">GB</a>
						</div>
					</div>
					<div class="col-sm-1">
						<h5>To Size:</h5>
					</div>
					<div class="col-sm-1">
						<input type="text" id="toSize" name="toSize" style="width: 100px"
							placeholder="To size">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary dropdown-toggle"
							data-toggle="dropdown">Size</button>
						<div class="dropdown-menu">
							<a class="dropdown-item" ng-click="toSize(1)">B</a> <a
								class="dropdown-item" ng-click="toSize(2)">KB</a> <a
								class="dropdown-item" ng-click="toSize(3)">MB</a> <a
								class="dropdown-item" ng-click="toSize(4)">GB</a>
						</div>
					</div>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<div class="col-sm-1">
						<span>&nbsp;</span>
					</div>
					<div class="col-sm-1">
						<span>&nbsp;</span>
					</div>
					<div class="col-sm-2">
						<h5>From Date:</h5>
					</div>
					<div class="col-sm-2">
						<input type="date" id="fromDate" name="fromDate"
							style="width: 150px" placeholder="From Date">
					</div>
					<div class="col-sm-1">
						<h5>To Date:</h5>
					</div>
					<div class="col-sm-2">
						<input type="date" id="toDate" name="toDate" style="width: 150px"
							placeholder="To Date">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary" ng-click="search()">Apply</button>
					</div>

				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<div class="col-sm-11 border"
						style="overflow-y: auto; height: 400px;">
						<table border='1' class="table table-striped">
							<thead>
								<tr>
									<th>Seq.</th>
									<th>File Path</th>
									<th>File size</th>
									<th>File Date</th>
									<th>File Name</th>
								</tr>
							</thead>
							<tbody>
								<tr ng-repeat="fileStatistics in filesList">
									<td>{{$index+1}}</td>
									<td>{{fileStatistics.filePath}}</td>
									<td>{{fileStatistics.size}}</td>
									<td>{{fileStatistics.date}}</td>
									<td><a href="#myModal"
										ng-click="getFile(fileStatistics.filePath,fileStatistics.fileName)"
										data-toggle="modal" data-target="#myModal">{{fileStatistics.fileName}}</a></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="modal fade" id="myModal">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">

								<!-- Modal Header -->
								<div class="modal-header">
									<h4 class="modal-title">File Content</h4>
									<button type="button" class="close" data-dismiss="modal">&times;</button>
								</div>

								<!-- Modal body -->
								<div class="modal-body">
									<iframe id="fileFrame" name="fileFrame" width="450"
										height="200" seamless></iframe>
								</div>

								<!-- Modal footer -->
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">Close</button>
								</div>

							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
			</div>
		</div>
		<div id="createIndexDiv" ng-controller="customersCtrl">
			<div class="col-sm-15">
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="container">
					<div class="row">
						<div class="col-sm-4">
							<h3>
								<b>Select Folders To Be index</b>
							</h3>
						</div>
						<div class="col-sm-4">
							<div class="progress">
								<div id="dynamic"
									class="progress-bar progress-bar-striped active"
									role="progressbar" aria-valuemin="0" aria-valuemax="100"
									style="width: 0%">
									<span id="current-progress"></span>
								</div>
							</div>
						</div>
						<div class="col-sm-2">
							<span id="foldersToBeIndexSpan" style="color: red">&nbsp;</span>
						</div>
					</div>
					<div style="overflow: auto; max-height: 200px;">
						<table border="1" id="myTable" ng-controller="customersCtrl"
							class="table table-striped">
							<thead>
								<th>Seq.</th>
								<th>Folder Path</th>
								<th>Status</th>
							</thead>
							<tbody>
								<tr ng-repeat="entity in names">
									<td class="col-xs-3">{{$index+1}}</td>
									<td class="col-xs-3">{{entity}}</td>
									<td class="col-xs-6"><input type="checkbox" id="checkbox"
										+{{$index}} ng-click="check($index)" required></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="row">
						<span>&nbsp;</span>
					</div>
					<div class="row">
						<span>&nbsp;</span>
						<div class="col-sm-8">
							<h3>
								<b>Select Folders Where Index Will Be Created</b>
							</h3>
						</div>
						<div class="col-sm-3">
							<span id="indexFilePathSpan" style="color: red">&nbsp;</span>
						</div>
					</div>
					<div style="overflow: auto; max-height: 200px;">
						<table border="1" id="myTable" ng-controller="customersCtrl"
							class="table table-striped">
							<thead>
								<th>Seq.</th>
								<th>Folder Path</th>
								<th>Status</th>
							</thead>
							<tbody>
								<tr ng-repeat="entity in foldersToBeIndex">
									<td>{{$index+1}}</td>
									<td>{{entity}}</td>
									<td><input type="radio" name="optradio"
										ng-click="checkIndexFilePath($index)"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="row">
						<span>&nbsp;</span>
					</div>
					<div class="row">

						<div class="col-sm-3">
							<h5>Upload a file of stop words with space seperated words</h5>
						</div>
						<div class="col-sm-4">
							<form method="POST" enctype="multipart/form-data"
								id="fileUploadForm">
								<input type="file" id="stopWordsFile" name="stopWordsFile"
									class="btn btn-secondary">
							</form>
						</div>
						<div class="col-sm-3">
							<h5>Or You Can Use default stop words</h5>
						</div>
						<div class="col-sm-2">
							<input type="checkbox" id="defaultStopWords"
								name="defaultStopWords" class="form-check-input">

						</div>
					</div>
					<div class="row">
						<span>&nbsp;</span>
					</div>
					<div class="row">
						<span>&nbsp;</span>
					</div>
					<div class="row">
						<div class="col-sm-2">&nbsp;</div>
						<div class="col-sm-2">&nbsp;</div>
						<div class="col-sm-2">&nbsp;</div>
						<div class="col">
							<button type="button" onclick="submitIndexFolders()"
								class="btn btn-primary">Submit</button>
						</div>
						<div class="col" id="stopWordsSpan" name="stopWordsSpan"
							style="color: red">&nbsp;</div>
					</div>
				</div>
				<div>
					<div id="progressbar" name="progressbar"></div>
					<span id="progressPercentage" name="progressPercentage">&nbsp;</span>
				</div>
			</div>
		</div>
			<div id="tokensListDiv"	ng-controller="filesListCtrl"  class="col-sm-15">
			<div>
				<h1>Tokens list</h1>
				<div>
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<div class="col-sm-1">
						<span>&nbsp;</span>
					</div>
					<div class="dropdown col-sm-1">
						<button type="button" class="btn btn-secondary dropdown-toggle"
							data-toggle="dropdown">Sort By</button>
						<div class=" dropdown-menu">
							<a class="dropdown-item" ng-click="filterFiles(1)">File Path</a>
							<a class="dropdown-item" ng-click="filterFiles(2)">File Name</a>
							<a class="dropdown-item" ng-click="filterFiles(3)">Size</a> <a
								class="dropdown-item" ng-click="filterFiles(4)">Last
								Modified</a> <a class="dropdown-item" ng-click="filterFiles(5)">All
								Files</a>
						</div>
					</div>
					<div class="col-sm-1">
						<h5>To Size:</h5>
					</div>
					<div class="col-sm-1">
						<input type="text" id="toSize" name="toSize" style="width: 100px"
							placeholder="To size">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary dropdown-toggle"
							data-toggle="dropdown">Size</button>
						<div class="dropdown-menu">
							<a class="dropdown-item" ng-click="toSize(1)">B</a> <a
								class="dropdown-item" ng-click="toSize(2)">KB</a> <a
								class="dropdown-item" ng-click="toSize(3)">MB</a> <a
								class="dropdown-item" ng-click="toSize(4)">GB</a>
						</div>
					</div>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<div class="col-sm-1">
						<span>&nbsp;</span>
					</div>
					<div class="col-sm-1">
						<span>&nbsp;</span>
					</div>
					<div class="col-sm-2">
						<h5>From Date:</h5>
					</div>
					<div class="col-sm-2">
						<input type="date" id="fromDate" name="fromDate"
							style="width: 150px" placeholder="From Date">
					</div>
					<div class="col-sm-1">
						<h5>To Date:</h5>
					</div>
					<div class="col-sm-2">
						<input type="date" id="toDate" name="toDate" style="width: 150px"
							placeholder="To Date">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary" ng-click="search()">Apply</button>
					</div>

				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<div class="col-sm-11 border"
						style="overflow-y: auto; height: 400px;">
						<table border='1' class="table table-striped">
							<thead>
								<tr>
									<th>Seq.</th>
									<th>File Path</th>
									<th>File size</th>
									<th>File Date</th>
									<th>File Name</th>
								</tr>
							</thead>
							<tbody>
								<tr ng-repeat="fileStatistics in filesList">
									<td>{{$index+1}}</td>
									<td>{{fileStatistics.filePath}}</td>
									<td>{{fileStatistics.size}}</td>
									<td>{{fileStatistics.date}}</td>
									<td><a href="#myModal"
										ng-click="getFile(fileStatistics.filePath,fileStatistics.fileName)"
										data-toggle="modal" data-target="#myModal">{{fileStatistics.fileName}}</a></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="modal fade" id="myModal">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">

								<!-- Modal Header -->
								<div class="modal-header">
									<h4 class="modal-title">File Content</h4>
									<button type="button" class="close" data-dismiss="modal">&times;</button>
								</div>

								<!-- Modal body -->
								<div class="modal-body">
									<iframe id="fileFrame" name="fileFrame" width="450"
										height="200" seamless></iframe>
								</div>

								<!-- Modal footer -->
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">Close</button>
								</div>

							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
			</div>
		</div>
		
</div>
		<jsp:include page='/MasterPageBottomSection' />
</body>
</html>
