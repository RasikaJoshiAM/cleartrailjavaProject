<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="icon" href="/Icon.jpg">
<title>Indexing Application</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
<script src="//code.jquery.com/jquery-1.12.4.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="/canvasjs.min.js"></script>
<script
	src="https://cdn.anychart.com/releases/v8/js/anychart-base.min.js"></script>
<script
	src="https://cdn.anychart.com/releases/v8/js/anychart-tag-cloud.min.js"></script>
<jsp:include page='/MasterPageTopSectionNew' />
<script src="/notify.js"></script>
<script src="/js/CreateIndex.js"></script>
<script src="/js/FilesList.js"></script>
<script src="/js/TokensList.js"></script>
<script src="/js/SearchFileFromToken.js"></script>
<script src="/js/WordCloud.js"></script>
<script src="/js/Charts.js"></script>
<script src="/js/Summary.js"></script>
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
		$("#tokensListDiv").hide();
		$("#searchFileFromTokensDiv").hide();
		$("#wordCloudDiv").hide();		
		$("#chartsDiv").hide();
		$("#createIndexDiv").hide();
$('imageDiv').show();
$('#myImgIndexedFolders').hide();
	}
var indexedFoldersScope;
var indexedFoldersMap=new Map();
var indexedFoldersList=[];
	myApp.controller('indexedFoldersCtrl', function($scope, $http) {
$scope.getIndexedFoldersList=function()	
{
	$('#modalHeaderSpanIndexedFolders').text('');
indexedFoldersMap=new Map();
	$http.get("/getIndexedFoldersList",).then(function(response) {	
		$scope.foldersList=response.data.result;
indexedFoldersList=response.data.result;
	},function(error){
		//$.notify("Error At Server side","error");
	});
}
$scope.check=function(index)
{
	if(indexedFoldersMap.has(index))
	{
		indexedFoldersMap.delete(index);
	}
else
	{
	indexedFoldersMap.set(index,index);
	}
}
$scope.submit=function()
{
	$('#myImgIndexedFolders').show();
	$('#modalHeaderSpanIndexedFolders').text('Please wait...');
	var i=0;
	for (var [key, value] of indexedFoldersMap) {
		data[i]=indexedFoldersList[key];
		i++;
		}
	var data1={
			isSuccessful:true,
			result:data
	}
	indexedFoldersMap.clear();
	 $.ajax({
			type : 'POST',
			url : '/deleteIndexedFolders',
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify(data1),
			success : function(response) {
				$('#myImgIndexedFolders').hide();
				$('#modalHeaderSpanIndexedFolders').text('Folder(s) Deleted');
				$scope.getIndexedFoldersList();
				$.notify("Indexed Folder(s) deleted.","success");
			},
			error:function(error)
			{
				//$.notify("Error At Server side","error");
			}
			});	
}

indexedFoldersScope=$scope;
	});
	var data=[];
	function showIndexedFolders()
	{
		indexedFoldersScope.getIndexedFoldersList();
		}
	function showPage(page) {
		if (page == 1) {
			$("#createIndexDiv").show();
			$("#filesListDiv").hide();
			$("#tokensListDiv").hide();
$("#searchFileFromTokensDiv").hide();
$("#wordCloudDiv").hide();
$("#chartsDiv").hide();
$('#imageDiv').hide();
createIndexScope.getListOfFoldersToBeIndex();
createIndexScope.getListOfFoldersIndexPath();
$("#defaultStopWords").prop("checked", false);
		}
		if (page == 3) {
			$("#createIndexDiv").attr("disabled", "disabled");
			$("#createIndexDiv").hide();
			$("#filesListDiv").show();
			$("#tokensListDiv").hide();
			$("#searchFileFromTokensDiv").hide();
			$("#wordCloudDiv").hide();
			$("#chartsDiv").hide();
			$('#imageDiv').hide();
			localScope.getFilesList();
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
			$('#imageDiv').hide();
			localScopeTokensList.getTokensList();
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
		$('#imageDiv').hide();
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
		$('#imageDiv').hide();
showWordChart();
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
		$('#imageDiv').hide();
showCharts();
		closeProgressingInterval();
		}
	if(page==7)
		{
showIndexedFolders();
		}
	}
	function showAlert()
	{
		$('#myAlert').css("display","block");		
	}
	function closeNotification()
	{
		$.notify("Hello World","success");
	}
	</script>
<body ng-app="myApp">
	<div class="row" style="height: 100%">
		<div class="col-sm-2" style="width: 200px">
			<div class="sidenav" style="height: 800px; width: 200px">
				<a href="javascript:showPage(1)" onclick="showAlert()">Create
					Index </a> <a href="javascript:showPage(2)">Tokens List</a> <a
					href="javascript:showPage(3)">Files List</a> <a
					href="javascript:showPage(4)">Search File</a> <a
					href="javascript:showPage(5)">Word Cloud</a> <a
					href="javascript:showPage(6)">Show Charts</a> <a
					href="#summaryModal" data-toggle="modal"
					data-target="#summaryModal" onclick="getSummary()">Summary</a> <a
					href="#indexedFoldersModal" data-toggle="modal"
					data-target="#indexedFoldersModal" onclick="showIndexedFolders()">Indexed
					Folders </a>
			</div>
		</div>
		<div id="imageDiv" class="col-sm-20">
			<div>
				<img src="/mainImage.jpg" style="width: 145%; height: 800px;" />
			</div>
		</div>
		<div class="modal fade" id="indexedFoldersModal"
			ng-controller="indexedFoldersCtrl">
			<div
				class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
				<div class="modal-content">

					<!-- Modal Header -->
					<div class="modal-header">
						<h4 class="modal-title">Delete Indexed Folders</h4>
						<span>&nbsp;</span> <img id="myImgIndexedFolders"
							src="./loader1.gif" style="width: 40px; height: 40px;"> <span
							id="modalHeaderSpanIndexedFolders" style="color: green;"></span>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>

					<!-- Modal body -->
					<div class="modal-body">
						<div class="row">
							<div class="col-sm-11 border"
								style="overflow-y: auto; height: 400px;">
								<table border='1' class="table table-striped">
									<thead>
										<tr>
											<th>Seq.</th>
											<th>Folders</th>
											<th>Select</th>
										</tr>
									</thead>
									<tbody>
										<tr ng-repeat="folder in foldersList">
											<td>{{$index+1}}</td>
											<td>{{folder}}</td>
											<td class="col-xs-6"><input type="checkbox"
												id="checkbox" +{{$index}} ng-click="check($index)"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

					</div>
					<div class="modal-footer">
						<h6>Check and delete any folder(s).</h6>
						<button type="button" class="btn btn-secondary"
							ng-click="submit()">Delete</button>
					</div>

				</div>
			</div>
		</div>
		<div class="modal fade" id="summaryModal">
			<div
				class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
				<div class="modal-content">

					<!-- Modal Header -->
					<div class="modal-header">
						<h4 class="modal-title">Summary</h4>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>

					<!-- Modal body -->
					<div class="modal-body">
						<div class="row">
							<div class="col-sm-6">
								<h5>Total Folders :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="totalFoldersLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Total Files :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="totalFilesLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Total Tokens :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="totalTokensLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Total English Tokens :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="totalEnglishLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Total Hindi Tokens :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="totalHindiLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Total Arabic Tokens :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="totalArabicLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Maximum Frequency Token :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="maxFrequencyTokenLabel"></h6>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<h5>Minimum Frequency Token :</h5>
							</div>
							<div class="col-sm-2">
								<h6 id="minFrequencyTokenLabel"></h6>
							</div>
						</div>
					</div>

					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">Close</button>
					</div>

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
								<th>Select</th>
							</thead>
							<tbody>
								<tr ng-repeat="entity in names">
									<td class="col-xs-3">{{$index+1}}</td>
									<td class="col-xs-3">{{entity}}</td>
									<td class="col-xs-6"><input type="checkbox"
										id="folderToBeIndexCheckbox{{$index}}"
										ng-click="check($index)" required></td>
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
						<table border="1" id="myTable" class="table table-striped">
							<thead>
								<th>Seq.</th>
								<th>Folder Path</th>
								<th>Select</th>
							</thead>
							<tbody>
								<tr ng-repeat="entity in foldersToBeIndex">
									<td>{{$index+1}}</td>
									<td>{{entity}}</td>
									<td><input type="radio" name="optradio" id="folderWhereIndexCreated{{$index}}"
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
							<button type="button" ng-click="submitIndexFolders()"
								class="btn btn-primary" id="submitButton" name="submitButton">Submit</button>
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
		<div id="filesListDiv" ng-controller="filesListCtrl">
			<div class="col-sm-20">
				<h1>Files list</h1>
				<div>
					<span>&nbsp;</span>
				</div>
				<div class="row">
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
					<div class="col-sm-2">
						<input type="number" id="fromSize" name="fromSize"
							style="width: 150px" placeholder="From size" min="0">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary dropdown-toggle"
							data-toggle="dropdown">Size</button>
						<div class="dropdown-menu">
							<a class="dropdown-item" ng-click="fromSize(1)">Bytes</a> <a
								class="dropdown-item" ng-click="fromSize(2)">KB</a> <a
								class="dropdown-item" ng-click="fromSize(3)">MB</a> <a
								class="dropdown-item" ng-click="fromSize(4)">GB</a>
						</div>
					</div>
					<div class="col-sm-1">
						<h5>To Size:</h5>
					</div>
					<div class="col-sm-2">
						<input type="number" id="toSize" name="toSize"
							style="width: 150px" placeholder="To size" min="0">
					</div>
					<div class="col-sm-1">
						<button type="button" class="btn btn-primary dropdown-toggle"
							data-toggle="dropdown">Size</button>
						<div class="dropdown-menu">
							<a class="dropdown-item" ng-click="toSize(1)">Bytes</a> <a
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
						<button type="button" class="btn btn-primary" ng-click="search()">Search</button>
					</div>
					<div class="col-sm-1">
						<img src="/loader1.gif" id="loadingImage" name="loadingImage"></img>
					</div>
					<div class="col-sm-2">
						<span id="loadingSpan" style="color: green;">loading....</span>
					</div>

				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="container">
					<div class="row">
						<div class="col-sm-20 border"
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
										<td style="width: 200px;">{{$index+1}}</td>
										<td style="width: 200px;">{{fileStatistics.filePath}}</td>
										<td style="width: 200px;">{{fileStatistics.size}}</td>
										<td style="width: 200px;">{{fileStatistics.date}}</td>
										<td style="width: 200px;"><a href="#myModal"
											ng-click="getFile(fileStatistics.filePath,fileStatistics.fileName)"
											data-toggle="modal" data-target="#myModal">{{fileStatistics.fileName}}</a></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div id="notFoundDiv" ng-show="(filesList).length==0"
							style="color: red; font-weight: bold">No Records Found</div>
					</div>
				</div>
				<div class="modal fade" id="myModal" ng-cloak>
					<div
						class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
						<div class="modal-content">

							<div class="modal-header">
								<h4 class="modal-title">File Content</h4>
								<span>&nbsp;</span> <img id="myImg" src="./loader1.gif"
									style="width: 40px; height: 40px;"> <span
									id="modalHeaderSpan" style="color: green;"></span>
								<button type="button" class="close" data-dismiss="modal">&times;</button>
							</div>

							<div class="modal-body">
								<pre id="contentPre"
									style="overflow: auto; white-space: pre-line;"></pre>
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
		</div>
		<div id="tokensListDiv" ng-controller="tokensListCtrl">
			<div class="col-sm-16">
				<div class="row">
					<div class="col">
						<h1>Tokens list</h1>
					</div>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div>
					<div class="row">
						<div class="col-sm-1">
							<h2>Search</h2>
						</div>
						<div class="col-sm-3">
							<input type="text" class="form-control" ng-model="search"
								placeholder="Enter some text to search" style="width: 250px;" />
						</div>
						<div class="dropdown col-sm-1">
							<button type="button" class="btn btn-secondary dropdown-toggle"
								data-toggle="dropdown">Sort By</button>
							<div class=" dropdown-menu">
								<a class="dropdown-item" ng-click="filterTokens(1)">Token
									Name</a> <a class="dropdown-item" ng-click="filterTokens(2)">Token
									Frequency</a> <a class="dropdown-item" ng-click="filterTokens(3)">Token
									Frequency Percentage</a>
							</div>
						</div>
						<div class="col-sm-1">
							<img src="/loader1.gif" id="loadingImageTokensList"
								name="loadingImage"></img>
						</div>
						<div class="col-sm-2">
							<span id="loadingSpanTokensList" style="color: green;">Loading
								Please wait....</span>
						</div>
					</div>
					<div class="col-sm-20 border"
						style="overflow-y: auto; height: 500px; width: 1200px;">
						<table border="1" class="table table-striped">
							<thead>
								<tr>
									<th>Seq.</th>
									<th>Token Name</th>
									<th>Frequency Count</th>
									<th>Frequency Percentage</th>
								</tr>
							</thead>
							<tbody>
								<tr ng-repeat="tokenStatistics in tokensList | filter : search">
									<td style="width: 200px;">{{$index+1}}</td>
									<td style="width: 200px;">{{tokenStatistics.tokenName}}</td>
									<td style="width: 200px;">{{tokenStatistics.frequencyCount}}</td>
									<td style="width: 200px;">{{tokenStatistics.frequencyPercentage}}%</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div id="notFoundDiv"
						ng-show="(tokensList | filter:token).length==0"
						style="color: red; font-weight: bold">No Records Found</div>

				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
			</div>
		</div>
		<div id="searchFileFromTokensDiv" ng-controller="searchFilesListCtrl">
			<div class="col-sm-15">
				<div class="row">
					<div class="col">
						<h1>Search File By Token</h1>
					</div>
				</div>
				<div class="row">
					<span>&nbsp;</span>
				</div>
				<div>
					<div class="container">
						<div class="row">
							<div class="col-sm-2">
								<h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Search</h3>
							</div>

							<div class="col-sm-3">
								<input type="text" ng-model="search"
									placeholder="Enter token to Search File" id="tokenInput"
									name="tokenInput" style="width: 200px" />
							</div>
							<div class="col-sm-1">
								<button type="button" ng-click="searchToken()"
									class="btn btn-primary">Search</button>
							</div>
							<div class="col-sm-4">
								<span id="errorSpan" name="errorSpan" style="color: red">&nbsp;</span>
							</div>

							<div class="col-sm-11 border border-dark"
								style="overflow-y: auto; height: 300px;">
								<table border='1' class="table table-striped">
									<thead>
										<tr>
											<th>File Path</th>
											<th>File Size</th>
											<th>File Date</th>
											<th>File Name</th>
										</tr>
									</thead>
									<tbody>
										<tr ng-repeat="fileStatistics in filesList">
											<td>{{fileStatistics.filePath}}</td>
											<td>{{fileStatistics.size}}</td>
											<td>{{fileStatistics.date}}</td>
											<td><a href="#myModalSearchFile"
												ng-click=getFile(fileStatistics.filePath,fileStatistics.fileName)
												data-toggle="modal" data-target="#myModalSearchFile">{{fileStatistics.fileName}}</a></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="modal fade" id="myModalSearchFile">
							<div
								class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
								<div class="modal-content">

									<div class="modal-header">
										<h4 class="modal-title">File Content</h4>
										<span>&nbsp;</span> <img id="myImgSearchFile"
											src="./loader1.gif" style="width: 40px; height: 40px;">
										<span id="modalHeaderSpanSearchFile" style="color: green;"></span>
										<button type="button" class="close" data-dismiss="modal">&times;</button>
									</div>

									<div class="modal-body">
										<pre id="contentPreSearchFile"
											style="overflow: auto; white-space: pre-line;"></pre>
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
		<div id="wordCloudDiv" style="width: 80%;">
			<div id="container" class="row"></div>
		</div>
		<div id="chartsDiv" style="width: 80%; height: 50%">
			<div class="row">
				<div class="col-sm-6">
					<div id="chartContainer"></div>
				</div>
				<div class="col-sm-6">
					<div id="chartContainer1"></div>
				</div>
			</div>

		</div>
	</div>

	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>
