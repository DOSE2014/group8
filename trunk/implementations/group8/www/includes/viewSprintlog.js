var viewSprintlog = angular.module('viewSprintlog', []);

viewSprintlog.controller('Sprintlogcontroller', ['$scope','$http', function($scope,$http){
	
	$scope.pbis = null;
	$http.get("http://www.w3schools.com/website/Customers_JSON.php")
	//Change address to the correct one
    .success(function(response) {$scope.pbis = response;});
	//should only get the Backlog Items that are not allready in a list
    $scope.CurrentName = null;
	
	$scope.setCurrentName = function(name){
		$scope.CurrentName = name;	
	}
		$scope.count = 0;
		
	$scope.setcount = function(){
		//if ($scope.pbis.id!=null){
		if($scope.CurrentName!=null){
		$scope.count = $scope.count +1;	
		alert(count);
		}
		else {
		alert("you need to choose a task first");	
		}
		//}
	}
	$scope.getcount = function (){
			  return new Array($scope.count);	
	}

}]);







