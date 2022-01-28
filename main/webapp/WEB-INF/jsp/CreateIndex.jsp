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
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="/js/CreateIndex.js"></script>
</head>
<body ng-app="myApp">
	<jsp:include page='/MasterPageTopSectionNew' />
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
					<div id="dynamic" class="progress-bar progress-bar-striped active"
						role="progressbar" aria-valuemin="0" aria-valuemax="100"
						style="width: 0%">
						<span id="current-progress"></span>
					</div>
				</div>
			</div>
			<div class="col-sm-2"><span id="foldersToBeIndexSpan" style="color:red">&nbsp;</span></div>
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
						<td class="col-xs-6">						
						 <input type="checkbox" id="checkbox"
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
		<div class="col-sm-3"><span id="indexFilePathSpan" style="color:red">&nbsp;</span></div>
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
						<td><input type="radio" name="optradio" ng-click="checkIndexFilePath($index)"></td>
						<!-- <input type="checkbox" id="checkbox"
							+{{$index}} ng-click="checkIndexFilePath($index)"> --> 
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
			<form method="POST" enctype="multipart/form-data" id="fileUploadForm">
				<input type="file" id="stopWordsFile" name="stopWordsFile"
					class="btn btn-secondary">
				</form>
							</div>
			<div class="col-sm-3">
				<h5>Or You Can Use default stop words</h5>
			</div>
			<div class="col-sm-2">
			<input type="checkbox" id="defaultStopWords" name="defaultStopWords"
				class="form-check-input">

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
					class="btn btn-primary" id="submitButton" name="submitButton">Submit</button>
			</div>
			<div class="col" id="stopWordsSpan" name="stopWordsSpan" style="color:red">&nbsp;</div>
		</div>
	</div>
	<div>
		<div id="progressbar" name="progressbar"></div>
		<span id="progressPercentage" name="progressPercentage">&nbsp;</span>
	</div>
	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>