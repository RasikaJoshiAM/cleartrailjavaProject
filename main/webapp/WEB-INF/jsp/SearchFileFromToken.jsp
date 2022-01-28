<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<jsp:include page='/MasterPageTopSectionNew' />
<script src="/js/SearchFileFromToken.js"></script>
</head>
<body>
	<div class="row">
		<div class="col">
			<h1>Search File By Token</h1>
		</div>
	</div>
	<div class="row">
		<span>&nbsp;</span>
	</div>
	<div ng-app="filesListApp" ng-controller="filesListCtrl">
		<div class="container">
			<div class="row">
				<div class="col-sm-2">
					<h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Search</h3>
				</div>

				<div class="col-sm-3">
					<input type="text" ng-model="search"
						placeholder="Enter token to Search File" id="tokenInput"
						name="tokenInput" style="width:200px"/>
				</div>
				<div class="col-sm-1">
					<button type="button" ng-click="searchToken()"
						class="btn btn-primary">Search</button>
				</div>
				<div class="col-sm-4">
					<span id="errorSpan" name="errorSpan" style="color:red">&nbsp;</span>
				</div>
				
				<div class="col-sm-11 border border-dark"
					style="overflow-y: auto; height: 300px;">
					<table border='1' class="table table-striped">
						<thead>
						<tr>
							<th>File Path</th>
							<th>File Name</th>
						</tr>
						</thead>
						<tbody>
						<tr ng-repeat="fileStatistics in filesList">
							<td>{{fileStatistics.filePath}}</td>
							<td><a href="#myModal"
								ng-click=getFile(fileStatistics.filePath,fileStatistics.fileName)
								data-toggle="modal" data-target="#myModal">{{fileStatistics.fileName}}</a></td>
						</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="modal fade" id="myModal">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">File Content</h4>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<div class="modal-body">
						<iframe id="fileFrame" name="fileFrame" width="450" height="200"
							seamless></iframe>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">Close</button>
					</div>

				</div>
			</div>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		</div>
		<jsp:include page='/MasterPageBottomSection' />
</body>
</html>