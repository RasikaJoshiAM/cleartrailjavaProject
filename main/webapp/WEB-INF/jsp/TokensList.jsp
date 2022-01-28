<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Tokens List</title>
<jsp:include page='/MasterPageTopSectionNew' />
<script src="/js/TokensList.js"></script>
</head>
<body>
	<div class="row">
		<div class="col">
			<h1>Tokens list</h1>
		</div>
	</div>
	<div class="row">
		<span>&nbsp;</span>
	</div>
	<div ng-app="tokensListApp" ng-controller="tokensListCtrl">
		<div class="container">
			<div class="row">
				<div class="col-sm-2">
					<h2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Search</h2>
				</div>
				<div class="col-sm-3">
					<input type="text" class="form-control" ng-model="search"
						placeholder="Enter some text to search" />
				</div>
				<div class="dropdown col-sm-1">
				<button type="button" class="btn btn-secondary dropdown-toggle"
					data-toggle="dropdown">Sort By</button>
				<div class=" dropdown-menu">
					<a class="dropdown-item" ng-click="filterTokens(1)">Token Name</a> <a
						class="dropdown-item" ng-click="filterTokens(2)">Token Frequency</a> <a
						class="dropdown-item" ng-click="filterTokens(3)">Token Frequency Percentage</a> 
				</div>
			</div>
			<div class="col-sm-1">
			<img src="/loader1.gif" id="loadingImage" name="loadingImage"></img>
			</div>
			<div class="col-sm-1">
			<span id="loadingSpan" style="color:green;">loading....</span>
			</div>
			</div>
			<div class="col-sm-11 border" style="overflow-y: auto; height: 350px;">
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
						<td>{{$index+1}}</td>
							<td>{{tokenStatistics.tokenName}}</td>
							<td>{{tokenStatistics.frequencyCount}}</td>
							<td>{{tokenStatistics.frequencyPercentage}}</td>
						</tr>
					</tbody>
				</table>
			</div>
					 <div id="notFoundDiv" ng-show="(tokensList | filter:token).length==0" style="color: red; font-weight: bold">No Records Found</div>
		</div>  

	</div>
	<div class="row"><span>&nbsp;</span></div>
	<div class="row"><span>&nbsp;</span></div>
	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>