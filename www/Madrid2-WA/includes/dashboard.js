//global variables to the REST services
var url_getUser = "rest/getUserInfo.php?id=";
var url_getProjects = "rest/getUserProjects.php?id="+global_usr_id;
var url_getBacklog = "rest/getProjectBacklog.php";
var url_logout = "rest/logout.php";

//Initializes the dashboard with AngularJS
var dashboard = angular.module('dashboard', []);

dashboard.config(function(){
	//if the global user variable is not defined goes to the login page
	if(global_usr_id == undefined || global_usr_id == ""){
		window.location.replace("login.php");
	}
	
	//FIXME sets a dummy chart
	setChart();
});


//Controller of the angularJS module
dashboard.controller('Users', ['$scope', '$http', 'restUsers', function($scope, $http, restUsers){
	
	$scope.user = {};
	$scope.projects = {};
	$scope.project = {};
	$scope.projectManager = {};
	$scope.developers = [];
	$scope.backlog = {};
	
	
	//gets the info of the active user of the system
	restUsers.getUser(global_usr_id, function(response){
        $scope.user = response; 
    });
	
	//gets the info from the rest service to set the project manager
	$scope.setProjectManager = function(userId){
		restUsers.getUser(userId, function(response){
	        $scope.projectManager = response;        
	    });
	}
	
	//gets the info from the rest service to set the project developers
	$scope.setProjectDevelopers = function(devIds){
		$scope.developers = [];
		for(var i=0; i<devIds.length; i++){
			restUsers.getUser(devIds[i], function(response){
		        $scope.developers.push(response);
		    });
		}
	}
	
	//logs out from the application
	$scope.logout = function(){
		$http.get(url_logout).success(function(data){
	        if(data.status == "ok"){
	        	window.location.replace("login.php");
	        }
		});
	}
	
	//gets the info from the rest service to set the projects where the user is currently on
	//FIXME Create the rest service that returns this info
	$scope.getUserProjects = $http.get(url_getProjects).success(function(data){
        $scope.projects = data.projects;
        if($scope.projects.length > 0){
        	$scope.setProject($scope.projects[0].id);
        }else{
        	$scope.setProject(null);
        }
        
    });
	
	$scope.getProjectBacklog = function(projectId){
		$http.get(url_getBacklog).success(function(data){
	        $scope.backlog = data.pbis;
		});
	};
	
	
	//Sets the current working project to display on the dashboard
	$scope.setProject = function(idProject){
		if(idProject > 0 && idProject != null){
			for(var i=0; i<$scope.projects.length; i++){
				if($scope.projects[i].id == idProject){
					
					//gets the actual info of the project for the global variable
					$scope.project = $scope.projects[i];
					
					//sets the project manager from the variable
					$scope.setProjectManager($scope.project.manager);
					
					//sets the developer chart for the project
					$scope.setProjectDevelopers($scope.project.developers);
					
					//gets the projectbacklog
					$scope.getProjectBacklog($scope.project.id);
					
					break;
				}
			}
		}else{
			//if the user has no projects sets the variable to blank
			$scope.project = {};
			$scope.projectManager = {};
		}
	};
	
	
}]);


//Service to communicate with REST
dashboard.service('restUsers', function($http) {
	// accept a function as an argument
	this.getUser = function(userId, callback) {
		// Get the logged in users info
		$http.get(url_getUser + userId).success(
			function(response) {
				callback(response);
			})
	};

});


function setChart(){
	
	var chart = new CanvasJS.Chart("div_chart", {

		title : {
			text : "Sprint Log #2 (10/10/2014 - 15/10/2014)",
			fontSize : "14"
		},
		 axisX : {
			title : "Days",
			titleFontSize : "12"
		},

		axisY : {
			title : "Tasks",
			titleFontSize : "12"
		},
		data : [//array of dataSeries              
		{ //dataSeries object

			/*** Change type "column" to "bar", "area", "line" or "pie"***/
			type : "column",
			toolTipContent: "Day # {x}, {y} tasks remaining",
			color: "rgba(255,12,32,.5)",
			dataPoints : [ {
				x : 0,
				y : 15
			}, {
				x : 1,
				y : 13
			}, {
				x : 2,
				y : 11
			}, {
				x : 3,
				y : 10
			}, {
				x : 4,
				y : 8
			}, {
				x : 5,
				y : 7
			}, {
				x : 6,
				y : 4
			}, {
				x : 7,
				y : 3
			}, {
				x : 8,
				y : 1
			}, {
				x : 9,
				y : 0
			} ]
		} ]
	});
	chart.render();
	
	
}

//$(setChart());