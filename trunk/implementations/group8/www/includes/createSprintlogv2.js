//global variables to the REST services
var url_getCurrentUser = "/account/userinfo";
var url_getUser = "/account/userinfo?id={0}";
var url_listdevelopers = "/account/listdevelopers";
var url_getProjectlist = "/projects/list";
var url_getBacklog = "/projects/{0}/getbacklog";
var url_logout = "account/logout";
var url_getSprintlog = "/projects/{0}/sprintlogs/list";
var url_getPBIs = "/projects/{0}/sprintlogs/{1}/listpbis";
var url_getTasks = "/projects/{0}/pbis/{1}/listtasks";
var url_login = "login.html";
var url_creatSprintlog = "/projects/{0}/sprintlogs/create";
var url_creatTask = "/projects/{idproj}/pbis/{idpbis}/createtask";


var global_usr_id = null;
var projectmanagerId = 6;
var projectId = 1;
var backlId = 1;
var splId = 1;

var createSprintlog = angular.module('createSprintlog', []);

createSprintlog.controller('Sprintlogcontroller', ['$scope','$http', function($scope,$http){
	
	//$("#txt_startDate").datepicker();
	//$("#txt_endDate").datepicker();
	$scope.splId = splId;
	$scope.pbis = null;
	$scope.name = null;
	$scope.sprintlogId = null;
	$scope.sprintlogCreated = null;
	$scope.user = [];

//Check if the current user is the manager of the current project
$http.get(url_getCurrentUser).success(function(response){
		$scope.currentuser = response;
	});		
	
	
	$http.get(url_getBacklog.format(backlId)).success(function(response){
		$scope.pbis = response.pbis;
			
	});
	
	$http.get(url_listdevelopers).success(function(response){
	
	$scope.developer = response.developers;
	$scope.user.push({id : $scope.developer.id, name : $scope.developer.firstname}); 
	$http.get(url_getProjectlist).success(function(responses){
		
		$scope.project = responses;
		$scope.projectDeveloper = responses.develepors;
	
	/*	
		if ($scope.project.id == projectId && $scope.project.developers == $scope.developer.id){
		$scope.user.push({id : $scope.developer.id, firstname : $scope.developer.firstname, lastname : $scope.developer.lastname}); 	
		}
	
*/
		console.log($scope.projectdeveloper);
	});
	});

	$scope.sprintlogName = '';
	$scope.sprintlogDescription = '';
	$scope.sprintlogStartdate = '';
	$scope.sprintlogEnddate = '';
	$scope.creatSprintlog = [];

	$scope.sprintLog = function(){
			$scope.sprintlogCreated = 1;
		
		if($scope.sprintlogEnddate<$scope.sprintlogStartdate){
			alert("the end date have to be later then the start date");	
		}else{
			
		var startDate = $.datepicker.formatDate('@',$.datepicker.parseDate( "d/m/yy", $scope.sprintlogStartdate));
		var endDate = $.datepicker.formatDate('@',$.datepicker.parseDate( "d/m/yy", $scope.sprintlogEnddate));
			var creatSprintlog ={
				'name' : $scope.sprintlogName,
				'description' : $scope.sprintlogDescription,
				'backlog' : backlId,
				'startDate' : parseInt(startDate),
				'endDate' : parseInt(endDate),
				'idpbis' : []
			};
			
			console.log(JSON.stringify(creatSprintlog));
			
			/*$http.post(url_creatSprintlog.format(projectId), JSON.stringify(creatSprintlog)).success(function(data) {
				if (data.status == "created") {
					alert("Sprintlog created");	
				}else if (data.status == "error") {
					alert(data.reason);
				}
			});*/
			
		}
	}	
	
	
	$scope.pbiName = '';
	$scope.pbiDescription = '';
	$scope.pbiPoints = 0;
	$scope.pbiDeveloperId = '';
	$scope.pbiId = '';
	$scope.addToTasks = [];
	$scope.setAddsprintlog = function(name,description,points,developerId,pbiID){
	$scope.pbiName = name;
	$scope.pbiDescription = description;
	$scope.pbiPoints = points;
	$scope.pbiDeveloperId = developerId;
	$scope.pbiId = pbiID;
	if($scope.pbiPoints>0){
	$scope.addToTasks.push({ name : $scope.pbiName, description : $scope.pbiDescription, points : $scope.pbiPoints, developer : $scope.pbiDeveloperId, state : 2, pbi : $scope.pbiId});
	} else {
	alert("You need to chose points for task");	
	}
	console.log($scope.addToTaskInServer);
	}
	$scope.taskName = '';
	$scope.taskDescription = '';
	$scope.taskpoints = '';
	$scope.taskDeveloperId = '';
	$scope.taskpbiId = '';
	$scope.addToTaskInServer = function(name,description,points,developer,pbid){
	$scope.taskName = name;
	$scope.taskDescription = description;
	$scope.taskpoints = points;
	$scope.taskDeveloperId = developer;
	$scope.state = 2;
	$scope.taskpbiId = pbid;
	
	var creatSprintlog ={
		'name' : $scope.taskName,
		'description' : $scope.taskDescription, 
		'points' : $scope.taskpoints,
		'developer' : $scope.taskDeveloperId,
		'state' : $scope.state,
		'pbi' : $scope.taskpbiId
	};	
	console.log(JSON.stringify(creatSprintlog));
	/*
	$http.post("/projects/{projectId}/pbis/{$scope.taskpbiId}/createtask", JSON.stringify(creatSprintlog)).success(function(data) {
				if (data.status == "created") {
					alert("Project created");	
				}
				else if (data.status == "error") {
					alert(data.reason);
				}
	});
	*/
	
	}
}]);



String.prototype.format = function() {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{'+i+'\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};





