//global variables to the REST services
var url_getCurrentUser = "/account/userinfo";
var url_getUser = "/account/userinfo?id={0}";
var url_getProjects = "/projects/list";
var url_getBacklog = "/projects/{0}/getbacklog";
var url_logout = "account/logout";
var url_getSprintlog = "/projects/{0}/sprintlogs/list";
var url_getPBIs = "/projects/{0}/sprintlogs/{1}/listpbis";
var url_getTasks = "/projects/{0}/pbis/{1}/listtasks";//FIXME

//
var url_login = "login.html";

//global usr id
var global_usr_id = null;

//Initializes the dashboard with AngularJS
var dashboard = angular.module('dashboard', []);

dashboard.config(function(){
	
});


//Controller of the angularJS module
dashboard.controller('Users', ['$scope', '$http', 'restUsers', function($scope, $http, restUsers){
	
	$scope.user = {};
	$scope.projects = {};
	$scope.project = {};
	$scope.projectManager = {};
	$scope.developers = [];
	$scope.backlog = {};
	$scope.sprints = [];
	$scope.currentSprint = {};
	$scope.tasks = [];
	
	
	//gets the info of the active user of the system
	restUsers.getCurrentUser(function(response){
		if(response.status == "error"){
			window.location.replace(url_login);
		}else{
			$scope.user = response; 
			global_usr_id = response.id;
		}
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
	        	window.location.href = url_login;
	        }
		});
	}
	
	//gets the info from the rest service to set the projects where the user is currently on
	$scope.getUserProjects = $http.get(url_getProjects).success(function(data){
        $scope.projects = data.projects;
        if($scope.projects.length > 0){
        	$scope.setProject($scope.projects[0].id);
        }else{
        	$scope.setProject(null);
        }
        
    });
	
	//gets the backlog of the project from the REST service
	$scope.getProjectBacklog = function(projectId){
		$http.get(url_getBacklog.format(''+projectId)).success(function(data){
	        $scope.backlog = data.pbis;
		});
	};
	
	//gets the date formated for the user to visualize
	$scope.getProjectFormatedDate = function(){
		if($scope.project.creationDate != undefined){
			var prjDate = $scope.project.creationDate;
			prjDate = new Date(prjDate*1000);
			prjDate = prjDate.getDate()+"/"+(prjDate.getMonth()+1)+"/"+prjDate.getFullYear();
			return prjDate;
		}
	}
	
	//sets the current sprintlog
	$scope.setCurrentSprint = function(sprintId){
	
		$scope.currentSprint = $scope.sprints[sprintId];
		
		setChart($scope.currentSprint.name, $scope.currentSprint.startDate, $scope.currentSprint.endDate);
        
        restUsers.getTasks($scope.project.id, $scope.currentSprint.id, function(response){
        	$scope.tasks = response;
        	console.log($scope.tasks);
        });
	}
	
	//gets the sprintlog of the project from the REST service
	$scope.getProjectSprintlog = function(projectId){
		$http.get(url_getSprintlog.format(''+projectId)).success(function(data){
	        $scope.sprints = data.sprintlogs;

	        //orders by the start date, starting with the most recent one 
	        $scope.sprints.sort(function(a,b) { 
	        	return parseFloat(b.startDate) - parseFloat(a.startDate) 
	        });
	        
	        $scope.setCurrentSprint(0);
	        
	     

	        //console.log($scope.sprints);
		});
	};
	
	//gets the points of an user
	$scope.getUserPoints = function(userId){
		
	}
	
	
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
					
					//gets the project sprintlogs
					$scope.getProjectSprintlog($scope.project.id);
					
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
	
	//gets the user from the rest service
	this.getUser = function(userId, callback) {
		// Get the logged in users info
		//alert(url_getUser.format(''+userId));
		$http.get(url_getUser.format(''+userId)).success(
			function(response) {
				callback(response);
			})
	};
	
	//gets the current user from the rest service
	this.getCurrentUser = function(callback) {
		// Get the logged in users info
		$http.get(url_getCurrentUser).success(
			function(response) {
				callback(response);
			}).
			error(function() {
				window.location.href= url_login;  
			});
	};
	
	//gets the tasks from the rest service
	this.getTasks = function(projectId, sprintLogId, callback){
		// Get the logged in users info
		$http.get(url_getPBIs.format(''+projectId,''+sprintLogId)).success(
			
			function(response) {
				var tasks = [];
				var pbi = response.pbis;
				
				for(var i=0; i<pbi.length; i++){
					//console.log(url_getTasks.format(""+pbi[i]+""));
					$http.get(url_getTasks.format(''+projectId, ""+pbi[i]+"")).success(
						function(response) {
							for(var y=0; y<response.tasks.length; y++){
								tasks.push(response.tasks[y]);
							}
							//console.log(tasks);
						}
					);
				}
				
				callback(tasks);
			}
		);
	};
	
	

});

function toggleVisible(elemId){
	$('#'+elemId).toggleClass("hidden");
}


function setChart(name, startDate, endDate){
	startDate = new Date(startDate*1000);
	startDate = startDate.getDate()+"/"+(startDate.getMonth()+1)+"/"+startDate.getFullYear();
	
	endDate = new Date(endDate*1000);
	endDate = endDate.getDate()+"/"+(endDate.getMonth()+1)+"/"+endDate.getFullYear();
	
	//startDate = startDate.toLocaleString();
	//endDate = endDate.toLocaleString();
	
	var chart = new CanvasJS.Chart("div_chart", {

		title : {
			text : name+" ("+startDate+" - "+endDate+")",
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

//This is the function.
/*String.prototype.format = function (args) {
	var str = this;
	return str.replace(String.prototype.format.regex, function(item) {
		var intVal = parseInt(item.substring(1, item.length - 1));
		var replace;
		if (intVal >= 0) {
			replace = args[intVal];
		} else if (intVal === -1) {
			replace = "{";
		} else if (intVal === -2) {
			replace = "}";
		} else {
			replace = "";
		}
		return replace;
	});
};
String.prototype.format.regex = new RegExp("{-?[0-9]+}", "g");*/

String.prototype.format = function() {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{'+i+'\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};



//$(setChart());