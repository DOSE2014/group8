var createSprintlog = angular.module('createSprintlog', []);

createSprintlog.controller('Sprintlogcontroller', ['$scope','$http', function($scope,$http){
	
	$scope.pbis = null;
	$scope.name = null;
	$http.get("http://www.w3schools.com/website/Customers_JSON.php")
	//Change address to the correct one
    .success(function(response) {$scope.pbis = response;});
	//should only get the Backlog Items that are not allready in a list
	$scope.Date = null;
	$scope.setDate = function(){
		$scope.Date = 1;	
	}
	$scope.goBack = function(){
		$scope.Date = null;	
	}
	$scope.sprintLog = function(){
	alert("Sprintlog Created");
	}
	
}]);







