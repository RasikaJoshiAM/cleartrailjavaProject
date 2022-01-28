	var searchText = null;
	var filterCategoriesTokensList = [ "name", "frequencyCount", "frequencyPercentage" ];
function fixFrequency(tokensList)
{
for(i=0;i<tokensList.length;i++)
	{
	tokenStatistics=tokensList[i];
	tokenStatistics.frequencyPercentage=tokenStatistics.frequencyPercentage.toFixed(2);
	}
return tokensList;
}
	myApp.controller('tokensListCtrl', function($scope, $http) {
		localScopeTokensList = $scope;
		$http.get("/getTokensList").then(function(response) {
		$scope.tokensList=response.data.result;
		$("#loadingImageTokensList").hide();
		$("#loadingSpanTokensList").text("");
	},function(error){
		//$.notify("Error At Server side","error");
	});	
		$scope.setList = function() {
			$http.get("/getTokensList").then(function(response) {
				$scope.tokensList=response.data.result;
				$("#loadingImageTokensList").hide();
				$("#loadingSpanTokensList").text("");
				},function(error){
					//$.notify("Error At Server side","error");
				});
		}
		$scope.filterTokens = function(filterIndex) {
			$("#loadingImageTokensList").show();
			$("#loadingSpanTokensList").text("loading....");
			$http.post("/getFilterTokens",filterCategoriesTokensList[filterIndex - 1]).then(function(response) {
				$scope.tokensList=response.data.result;
				$("#loadingImageTokensList").hide();
				$("#loadingSpanTokensList").text("");
			},function(error){
				//$.notify("Error At Server side","error");
			});
		}
		$scope.getTokensList=function()
		{
			$("#loadingImageTokensList").show();
			$("#loadingSpanTokensList").html("Loading Please wait....");
		$http.get("/getTokensList").then(function(response) {
				$scope.tokensList=response.data.result;				
				$("#loadingImageTokensList").hide();
				$("#loadingSpanTokensList").text("");
			},function(error){
				//$.notify("Error At Server side","error");
			});	
		}
		$scope.setConnected=function(connected) {
			console.log('Set connected called');
		}

		$scope.connect=function() {
			var socket = new SockJS('/gs-guide-websocket');
			stompClient = Stomp.over(socket);
			stompClient.connect({},$scope.onConnected, $scope.onError);
		}
	$scope.onConnected=function()
	{
		$scope.setConnected(true);
		$scope.sendName();
		stompClient.subscribe('/topic/greetings', function(greeting) {
			localScopeTokensList.setList();
		});
	}
		$scope.onError=function()
		{
		alert("Could not connect to server,Please refresh the page.");	
		}
		$scope.disconnect=function() {
			if (stompClient !== null) {
				stompClient.disconnect();
			}
			setConnected(false);
			console.log("Disconnected");
		}

		$scope.sendName=function() {
			stompClient.send("/app/hello", {});
		}

		$scope.showGreeting=function(message) {
			alert('Show greetings function called');
		}
		$scope.connect();
	});
