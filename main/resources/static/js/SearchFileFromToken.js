	var searchText = null;
	var request;
	var filesList = [];
	myApp.controller('searchFilesListCtrl', function($scope, $http) {
		$scope.searchToken = function() {
			var token = document.getElementById('tokenInput').value;
			$http({
				method : 'POST',
				url : '/getFilesOfToken',
				contentType : "application/json",
				data : {
					isSuccessful : true,
					result : token
				}
			}).then(function(response) {
if(response.data.result.length==0)
	{
document.getElementById("errorSpan").innerHTML="No File with this token found";
$scope.filesList=[];
	return;
	}
				$scope.filesList = $scope.calculateSize(response.data.result);
			}, function(error) {
				//$.notify("Error At Server side","error");
			});
		}
		$scope.getFile = function(filePath, fileName) {
			var content;
			$http.post('/getFileByPath',filePath).then(function(response) {
				content = response.data.result;
				document.getElementById("myImgSearchFile").style.visibility = "hidden";
				 document.getElementById('modalHeaderSpanSearchFile').innerHTML="";							
				 document.getElementById('contentPreSearchFile').innerHTML=content;
			},
			function(error) {
				//$.notify("Error At Server side","error");
			});

			
			
		}
		$scope.calculateSize=function(filesList)
		{
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
	});
