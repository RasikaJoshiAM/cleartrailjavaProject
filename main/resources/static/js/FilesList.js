var scope;
	var localScope;
	var stompClientFilesList = null;
	var filterCategories = [ "path", "name", "size", "lastModified","All Files" ];
	var fromSize=1;
	var toSize=1;
	var filesList=[];
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
							$("#loadingImage").hide();
							$("#loadingSpan").text("");
		},function(error){
			//$.notify("Error At Server side","error");
		});
		$scope.getFilesList=function()
		{
			$("#loadingImage").show();
			$("#loadingSpan").text("Loading .....");
			$http.get("/getFilesList").then(function(response) {
				filesList = response.data.result;
				var size;
				filesList = calculateSize(filesList);
				$scope.filesList = filesList;
				$("#loadingImage").hide();
				$("#loadingSpan").text("");
			},function(error){
				//$.notify("Error At Server side","error");
			});
	}
						localScope = $scope;
						$scope.getFile = function(filePath, fileName) {
							document.getElementById("myImg").style.visibility = "visible";
							 document.getElementById('modalHeaderSpan').innerHTML="Loading.....";							
							 document.getElementById('contentPre').innerHTML="";							
							 filePath = filePath + "\\" + fileName;
							var content;
							$http.post('/getFileByPath',filePath).then(function(response) {
								content=response.data.result;
								document.getElementById("myImg").style.visibility = "hidden";
								document.getElementById('modalHeaderSpan').innerHTML="";							
 document.getElementById('contentPre').innerHTML=content;
 
$("#loadingImage").hide();
 								},
								function(error) {
									//$.notify("Error At Server side","error");
								});
						}
						$scope.setList = function() {
							$http.get("/getFilesList").then(function(response) {
								$scope.filesList = response.data.result;
							},function(error){
								//$.notify("Error At Server side","error");
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
						$scope.setConnected=function(connected) {
							//alert('Set connected called');
						}

						$scope.connect=function() {
							var socket = new SockJS('/gs-guide-websocket');
							stompClientFilesList = Stomp.over(socket);
							stompClientFilesList.connect({},$scope.onConnected, $scope.onError);
						}
						$scope.onConnected=function() {
							$scope.setConnected(true);
							$scope.sendName();
							stompClientFilesList.subscribe('/topic/greetings', function(greeting) {
								localScope.setList();
							});
						}
						$scope.disconnect=function() {
							if (stompClientFilesList !== null) {
								stompClientFilesList.disconnect();
							}
							$scope.setConnected(false);
							$.notify("Disconnected","error");
						}

						$scope.sendName=function() {
							stompClientFilesList.send("/app/hello", {});
						}

						$scope.showGreeting=function(message) {
							alert('Show greetings function called');
						}
						
						$scope.search=function()
						{
							$("#loadingImage").show();
							$("#loadingSpan").text("Loading ....");
							var token=$('#token').val();
							var fromSizeValue=$('#fromSize').val();
							var toSizeValue=$('#toSize').val();
							var fromSizeUnit;
							var toSizeUnit=toSize;	
							if(fromSizeValue<0 || toSizeValue<0)
								{
								$("#loadingSpan").text("Please add a positive value in size.");		
								$("#loadingImage").hide();								
								return;
								}
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
									$("#loadingImage").hide();
									$("#loadingSpan").text("No files exists");		
									}
								else
									{
								$scope.filesList = response.data.result;
								$scope.filesList=calculateSize($scope.filesList);
								$("#loadingImage").hide();
								$("#loadingSpan").text("");		
									}
									});
						}
						$scope.filterFiles = function(filterIndex) {
							$("#loadingImage").show();
							$("#loadingSpan").text("Loading ....");
							$http.post("/getFilterFiles",filterCategories[filterIndex - 1]).then(function(response) {
												filesList = calculateSize(response.data.result);
												$scope.filesList = filesList;
												$("#loadingImage").hide();
												$("#loadingSpan").text("");
											},function(error){
												//$.notify("Error At Server side","error");
											});
						}
						$scope.connect();
					});
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
