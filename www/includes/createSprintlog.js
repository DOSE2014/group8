//global variables to the REST services
var url_getCurrentUser = "/account/userinfo";
var url_getUser = "/account/userinfo?id={0}";
var url_getBacklog = "/projects/{0}/getbacklog";
var url_logout = "account/logout";
var url_getSprintlog = "/projects/{0}/sprintlogs/list";
var url_getPBIs = "/projects/{0}/sprintlogs/{1}/listpbis";
var url_getTasks = "/projects/{0}/pbis/{1}/listtasks";
var url_login = "login.html";

var global_usr_id = null;

var createSprintlog = angular.module('createSprintlog', []);

createSprintlog.controller('Sprintlogcontroller', ['$scope','$http', function($scope,$http){
	
	$scope.pbis = null;
	$scope.name = null;
	$scope.date = null;
	$scope.manager = null;
	$http.get("http://www.w3schools.com/website/Customers_JSON.php")
	//http.get("/projects/{idproj}/getbacklog")
	
	//Change address to the correct one
    .success(function(response) {$scope.pbis = response;});
	//should only get the Backlog Items that are not allready in a list
	
	$scope.setdate = function(){
			$scope.manager = null;
		$scope.date = 1;	
	}
	$scope.goBack = function(){
		$scope.date = null;	
	}
	$scope.sprintLog = function(){
	alert("Sprintlog Created");
	}
	$scope.setManager = function(){
	$scope.manager = 1;
	}
	$scope.setDeveloper = function(){
	$scope.manager = null;
	alert("You have  to be a manger to creat a sprintlog");
	}
	$scope.sprintlogName = '';
	$scope.sprintlogPriority = '';
	$scope.sprintlogDescription = '';
	$scope.addToSprintlog = [];
	$scope.setAddsprintlog = function(name,country,city){
	$scope.sprintlogName = name;
	$scope.sprintlogPriority = country;
	$scope.sprintlogDescription = city;
	$scope.addToSprintlog.push({ name : $scope.sprintlogName, priority: $scope.sprintlogPriority, description : $scope.sprintlogDescription});
	}
	
}]);







