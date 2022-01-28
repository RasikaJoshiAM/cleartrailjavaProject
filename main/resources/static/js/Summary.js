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
