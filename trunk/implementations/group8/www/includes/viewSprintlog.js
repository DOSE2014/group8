var viewSprintlog = angular.module('viewSprintlog', []);

viewSprintlog.controller('Sprintlogcontroller', ['$scope','$http', function($scope,$http){
	
	$scope.pbis = null;
	$scope.manager = 1;
	$http.get("https://dose2014.googlecode.com/svn/trunk/implementations/group8/www/includes/Test_JSON.php")
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
		//}
	}
	$scope.savedId = [];
	$scope.currentId = null;
	$scope.setCurrentId = function(id){
		$scope.currentId = id;
	$scope.savedId.push({id:id});
	}
	$scope.manager = null;
	$scope.setManager = function(){
	$scope.manager = 1;
	$scope.notManager = null;
	}
	$scope.notManager = null;
	$scope.setOther = function(){
	$scope.notManager = 1;
	$scope.manager = null;
	}
	$scope.getcount = function (){
			  return new Array($scope.count);	
	}

}]);







