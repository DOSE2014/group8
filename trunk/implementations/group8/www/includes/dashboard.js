//global variables to the REST services
var url_getCurrentUser = "/account/userinfo";
var url_getUser = "/account/userinfo?id={0}";
var url_getProjects = "/projects/list";
var url_getBacklog = "/projects/{0}/getbacklog";
var url_logout = "account/logout";
var url_getSprintlog = "/projects/{0}/sprintlogs/list";
var url_getPBIs = "/projects/{0}/sprintlogs/{1}/listpbis";
var url_getTasks = "/projects/{0}/pbis/{1}/listtasks";
var url_getDevPoints = "/stats/projpoints?idproj={0}&iddev={1}";
var url_getProjectCompletion = "/projects/{0}/completion";
var url_getStakeholders = "/account/liststakeholders"; 
var url_getDevelopers = "/account/listdevelopers";
var url_createProjects = "/projects/create";
var url_remDevProject = "/projects/{0}/remdeveloper";
var url_addDevProject = "/projects/{0}/adddeveloper";
var url_editAccount = "/account/edit";

//
var url_login = "login.html";

//global usr id
var global_usr_id = null;

//Initializes the dashboard with AngularJS
var dashboard = angular.module('dashboard', []);

dashboard.config(function(){
	
});

dashboard.controller('Profile', ['$scope', '$http', function($scope, $http){
	$scope.viewProfile = function(){
		$('#modal_profile').modal('show');
	}
	
	$scope.changePassword = function() {
		$scope.profNPwdRequired = '';
		$scope.profRPwdRequired = '';

		if (!$scope.profNPwd) {
			$scope.profNPwdRequired = 'Required';
		} else if (!$scope.profRPwd) {
			$scope.profRPwdRequired = 'Required';
		}else if ($scope.profNPwd != $scope.profRPwd) {
			$scope.profNPwdRequired = "Password don't match";
		} else {
			var postData = {
				'password' : $scope.profNPwdRequired
			};
			
			$http.post(url_editAccount, JSON.stringify(postData)).success(function(data) {
				if (data.status == "ok") {
					alert("Password changed");
					$('#modal_profile').modal('hide');
					
				} else if (data.status == "error") {
					alert(data.reason);
					$('#modal_profile').modal('hide');
				}
			}).error(function(error) {
				alert(error);
				$('#modal_profile').modal('hide');
			});
			
		}
	}
	
	
}]);

dashboard.controller('Project', ['$scope', '$http', function($scope, $http){
	$scope.openNewProject = function(){
		$('#modal_newProject').modal('toggle');
	}
	
	$scope.openDevManager = function(){
		$('#modal_manager').modal('toggle');
	}
	
	$scope.srvStakeholders = [];
	$scope.srvDevelopers = [];
	

	$http.get(url_getStakeholders).success(function(response) {
		$scope.srvStakeholders = response.stakeholders;
	});
	
	$http.get(url_getDevelopers).success(function(response) {
		$scope.srvDevelopers = response.developers;
	});
	
	$scope.removeDev = function(devId){
		if(confirm("Are you sure you want to remove the developer? All his info in the project will be lost.")){
			$http.post(url_remDevProject.format($scope.project.id), JSON.stringify({ 'iddev' : devId })).success(function(data) {
				if (data.status == "ok") {
					$('#modal_manager').modal('hide');
					alert("Developer removed from project");
					
				} else {
					alert(data.status);
				}
			});
		}
	}
	
	$scope.addDev = function(){
		$http.post(url_addDevProject.format($scope.project.id), JSON.stringify({ 'iddev' : $scope.addDeveloperId })).success(function(data) {
			if (data.status == "ok") {
				$('#modal_manager').modal('hide');
				alert("Developer added to the project")
			} else {
				alert(data.status);
			}
		});
		
	}
	
	$scope.saveProject = function() {
		$scope.nameRequired = '';
		$scope.descriptionRequired = '';
		$scope.stakeRequired = '';
		$scope.managerRequired = '';

		if (!$scope.prjName) {
			$scope.nameRequired = 'Required';
		} else if (!$scope.prjDescription) {
			$scope.descriptionRequired = 'Required';
		}else if (!$scope.prjStakeholder) {
			$scope.stakeRequired = 'Required';
		}else if (!$scope.prjManager) {
			$scope.managerRequired = 'Required';
		} else {
			var postData = {
				'name' : $scope.prjName,
				'description': $scope.prjDescription,
				'manager': $scope.prjManager.id,
				'stakeholder': $scope.prjStakeholder.id
			};
			
			$http.post(url_createProjects, JSON.stringify(postData)).success(function(data) {
				if (data.status == "created") {
					alert("Project created");
					$('#modal_newProject').modal('hide');
					
				} else if (data.status == "error") {
					alert(data.reason);
					$('#modal_newProject').modal('hide');
				}
			}).error(function(error) {
				alert(error);
				$('#modal_newProject').modal('hide');
			});
			
		}
	}
	
	
}]);

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
	$scope.completion = [];
	
	//gets the current completion state of the project
	$scope.getProjectCompletion = function(){
		//"completedPBIS":2,"numberOfPBIs":33
		if($scope.completion.completedPBIS!=undefined){
			var compPer = ($scope.completion.completedPBIS*100)/$scope.completion.numberOfPBIs;
			return Math.round(compPer);
		}else{
			return 0;
		}
	};
	
	//sets the current completion state of the project from the rest
	$scope.setProjectCompletion = function(prjId){
		$http.get(url_getProjectCompletion.format(''+prjId)).success(function(data){
	        $scope.completion = data;
	        //console.log(data);
		});
	};
	
	
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
		        
		        $scope.setProjectDevelopersPoints(response.id);
		    });
		}
	}
	
	//gets the info from the rest service to set the project developers points
	$scope.setProjectDevelopersPoints = function(devId){
		//$scope.developers = [];
		
		restUsers.getPoints(devId, $scope.project.id, function(response){
			
			for(var i=0; i<$scope.developers.length; i++){
				if($scope.developers[i].id == devId){
					//console.log(i+''+response);
					$scope.developers[i].points = response.points;
				}
			}
	    });
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
	
        restUsers.getTasks($scope.project.id, $scope.currentSprint.id, function(response){
        	$scope.tasks = response;     
        	
        	setChart($scope.currentSprint.name, $scope.currentSprint.startDate, $scope.currentSprint.endDate, $scope.tasks);
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
					
					//gets the project sprintlogs
					$scope.getProjectSprintlog($scope.project.id);
					
					//sets the completion of the project
					$scope.setProjectCompletion($scope.project.id);
					
					break;
				}
			}
		}else{
			//if the user has no projects sets the variable to blank
			$scope.resetVariables();
		}
	};
	
	$scope.openPbiManager = function(){
		alert("AAA");
	}
	
	//if the user has no projects sets the variable to blank
	$scope.resetVariables = function(){
		$scope.projects = {};
		$scope.project = {};
		$scope.projectManager = {};
		$scope.developers = [];
		$scope.backlog = {};
		$scope.sprints = [];
		$scope.currentSprint = {};
		$scope.tasks = [];
		$scope.completion = [];
	}
	
	$scope.getDate = function(time_date){
		var res = new Date(time_date*1000);
		res = res.getDate()+"/"+(res.getMonth()+1)+"/"+res.getFullYear();
		return res;
	}
	
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
	
	this.getPoints = function (devId, projId, callback){
		$http.get(url_getDevPoints.format(''+projId, ''+devId)).success(
			function(response) {
				callback(response);
			})
	}
	
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
					$http.get(url_getTasks.format(''+projectId, ""+pbi[i]+"")).success(
						function(response) {
							for(var y=0; y<response.tasks.length; y++){
								tasks[tasks.length] = (response.tasks[y]);
								
							}
							callback(tasks);
						}
					);
				}
				
				
			}
		);
	};
	
	

	
	

});



function toggleVisible(elemId){
	$('#'+elemId).toggleClass("hidden");
}


function setChart(name, startDate, endDate, chTasks){
	
	var data = [];
	var totalTask = chTasks.length;
	
	var diff = Math.ceil((endDate - startDate) / 86400);
	
	for(var i=0; i<=diff; i++){
		var dayDate = (startDate+(i*86400));
		var totTask = totalTask;
		
		for(var y=0; y<chTasks.length; y++){
			if(chTasks[y].state == 'Completed' && chTasks[y].completionDate <= dayDate && chTasks[y].completionDate != 0){
				totTask--;
			}
		}
		
		data.push({ x:i, y:totTask });
	}
	
	startDate = new Date(startDate*1000);
	startDate = startDate.getDate()+"/"+(startDate.getMonth()+1)+"/"+startDate.getFullYear();
	
	endDate = new Date(endDate*1000);
	endDate = endDate.getDate()+"/"+(endDate.getMonth()+1)+"/"+endDate.getFullYear();
	
	var chart = new CanvasJS.Chart("div_chart", {

		title : {
			text : name+" ("+startDate+" - "+endDate+")",
			fontSize : "14"
		},
		 axisX : {
			title : "Days",
			titleFontSize : "12",
			minimum: -0.5,
			interval:1
		},

		axisY : {
			title : "Tasks",
			titleFontSize : "12",
			minimum: 0,
			interval:1
		},
		data : [//array of dataSeries              
		{ //dataSeries object

			/*** Change type "column" to "bar", "area", "line" or "pie"***/
			type : "column",
			toolTipContent: "Day # {x}, {y} tasks remaining",
			color: "rgba(255,12,32,.5)",
			scaleBeginAtZero : true,
			dataPoints : data
		} ]
	});
	chart.render();
	
	
}

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



//$(setChart());