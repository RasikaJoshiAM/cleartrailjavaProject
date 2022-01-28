<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<jsp:include page='/MasterPageTopSectionNew' />
</head>
<script>
	function getSummary() {
		$.ajax({
			type : 'GET',
			url : '/getSummary',
			success : function(response) {
				content = response.result;
				$("#totalFoldersLabel").text(content.numberOfFolders);
				$("#totalFilesLabel").text(content.numberOfFiles);
				$("#totalTokensLabel").text(content.numberOfTokens);
				$("#totalEnglishLabel").text(content.numberOfEnglishTokens);
				$("#totalHindiLabel").text(content.numberOfHindiTokens);
				$("#totalArabicLabel").text(content.numberOfArabicTokens);
				$("#maxFrequencyTokenLabel").text(content.tokenWithMaxFrequency);
				$("#minFrequencyTokenLabel").text(content.tokenWithMinFrequency);
			},
			error : function(error) {
				alert('It is an error');
			}
		});
	}
</script>
<body>
	<br></br>
	<ul>
		<div class="row">
			<li><a href="/createIndex" class="btn btn-outline-primary">Create
					Index</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		<div class="row">
			<li><a href="/tokensList" class="btn btn-outline-primary">Tokens
					List</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		<div class="row">
			<li><a href="/filesList" class="btn btn-outline-primary">Files
					List</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		<div class="row">
			<li><a href="/searchFileFromToken"
				class="btn btn-outline-primary">Search File</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		<div class="row">
			<li><a href="/wordCloudTest" class="btn btn-outline-primary">Word
					Cloud</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		<div class="row">
			<li><a href="/chartExample" class="btn btn-outline-primary">Different
					Charts</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
		</div>
		<div class="row">
			<li><a href="#summaryModal" data-toggle="modal"
				data-target="#summaryModal" onclick="getSummary()"
				class="btn btn-outline-primary">Summary</a></li>
		</div>
		<div class="row">
			<span>&nbsp;</span>
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
	</ul>
	<jsp:include page='/MasterPageBottomSection' />
</body>
</html>