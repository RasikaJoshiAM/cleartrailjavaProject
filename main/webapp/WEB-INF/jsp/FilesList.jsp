<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0/jquery.min.js"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.3.0/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src=/js/FilesList.js></script>
<jsp:include page='/MasterPageTopSectionNew' />
</head>
<body>
<body ng-app="filesListApp" ng-controller="filesListCtrl">
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
					<a class="dropdown-item" ng-click="filterFiles(1)">File Path</a> <a
						class="dropdown-item" ng-click="filterFiles(2)">File Name</a> <a
						class="dropdown-item" ng-click="filterFiles(3)">Size</a> <a
						class="dropdown-item" ng-click="filterFiles(4)">Last Modified</a>
						<a class="dropdown-item" ng-click="filterFiles(5)">All Files</a>
				</div>
			</div>
			<div class="col-sm-1">
			<h5> Token :</h5>
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
				<input type="text" id="fromSize" name="fromSize" style="width: 100px"
					placeholder="From size">
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
				<input type="date" id="fromDate" name="fromDate" style="width: 150px"
					placeholder="From Date">
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
<div class="container">
		<div class="row">
			<div class="col-sm-11 border" style="overflow-y: auto; height: 400px;">
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
							<iframe id="fileFrame" name="fileFrame" width="450" height="200"
								seamless></iframe>
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
	<div class="row">
		<span>&nbsp;</span>
	</div>
	<div class="row">
		<span>&nbsp;</span>
	</div>
	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>