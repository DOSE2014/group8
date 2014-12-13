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
var url_remPBI = "/projects/{0}/pbis/{1}/delete";
var url_addPBI = "/projects/{0}/pbis/create";
var url_addBacklog = "/projects/{0}/createbacklog";
var url_editTask = "/projects/{0}/tasks/{1}/edit";
var url_getChat = "/chat/{0}/getchat";
var url_createSprint = "projects/{0}/sprintlogs/create";
var url_addPBISpl = "/projects/{0}/sprintlogs/{1}/addpbi";
var url_remPBISpl = "/projects/{0}/sprintlogs/{1}/removepbi";
var url_deleteSpl = "/projects/{0}/sprintlogs/{1}/delete";
var url_createTask = "/projects/{0}/pbis/{1}/createtask";
var url_delTask = "/projects/{0}/tasks/{1}/delete";

//
var url_login = "login.html";

//global usr id
var global_usr_id = null;

//Initializes the dashboard with AngularJS
var dashboard = angular.module('dashboard', []).filter('timeToDate', function() {
	return function(input) {
		//var dat = new Date(input*100);
		return "WW"+input;
	};
});

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
				'password' : $scope.profNPwd
			};
			
			$http.post(url_editAccount, JSON.stringify(postData)).success(function(data) {
				if (data.status == "ok") {
					alert("Password changed");
					$('#modal_profile').modal('hide');
					
				} else if (data.status == "error") {
					alert(data.reason);
					
				}
			}).error(function(error) {
				alert(error);
				
			});
			
		}
	}
	
	
}]);

dashboard.controller('Chat', ['$scope', '$http', function($scope, $http){
	$scope.newMessage = false;
	$scope.showWindow = false;
	
	$scope.messages = function(){
		if($scope.project.id != undefined){
			$http.get(url_getChat.format($scope.project.id)).success(function(data) {
		
				console.log(data);
			}).error(function(error) {
				alert(error);
				
			});
		}
	}
	
	$scope.openChatWindow = function(){
		toggleVisible('chatWindow');
		if($scope.showWindow == false){
			$scope.showWindow = true;
			
			$scope.messages();
		}else{
			$scope.showWindow = false;
		}
	}
	
}]);

dashboard.controller('Project', ['$scope', '$http', function($scope, $http){
	//Opens the modal pop up to create a new project. STAKEHOLDER only
	$scope.openNewProject = function(){		
		$('#modal_newProject').modal('toggle');
	}
	
	$scope.getSrvDevelopers = function(){
		if($scope.srvDevelopers.length <=0 && $scope.devFetch == false){
			$scope.devFetch = true;
			$http.get(url_getDevelopers).success(function(response) {
				$scope.srvDevelopers = response.developers;
				return $scope.srvDevelopers;
			});
		}else{
			return $scope.srvDevelopers;
		}
		
	}

	//Opens the modal pop up to manage the developers in a project. Manager Only
	$scope.openDevManager = function(){
		$('#modal_manager').modal('toggle');
	}
	
	//Remove a developer from a project
	$scope.removeDev = function(devId){
		if(confirm("Are you sure you want to remove the developer? All his info in the project will be lost.")){
			$http.post(url_remDevProject.format($scope.project.id), JSON.stringify({ 'iddev' : devId })).success(function(data) {
				if (data.status == "ok") {
					$scope.setProject($scope.project.id);
					$('#modal_manager').modal('hide');
					alert("Developer removed from project");
					
				} else {
					alert(data.status);
				}
			});
		}
	}
	
	//Adds a developer to a project
	$scope.addDev = function(){
		$http.post(url_addDevProject.format($scope.project.id), JSON.stringify({ 'iddev' : $scope.addDeveloperId.id })).success(function(data) {
			if (data.status == "ok") {
				
				$('#modal_manager').modal('hide');
				alert("Developer added to the project");
				$scope.setProject($scope.project.id);c
			} else {
				alert(data.status);
			}
		}).error(function(error){
			alert(error);
		});
		
	}
	
	//Remove a PBI from a project
	$scope.removeBacklog = function(bklId){
		if(confirm("Are you sure you want to remove the PBI?")){
			$http.post(url_remPBI.format($scope.project.id, bklId)).success(function(data) {
				if (data.status == "ok") {
					$scope.setProject($scope.project.id);
					alert("PBI removed from project");
					$('#modal_backlog').modal('hide');
				} else {
					alert(data.status);
				}
			});
		}
	}
	
	$scope.addPBI = function(data){
		$http.post(url_addPBI.format($scope.project.id), JSON.stringify(data)).success(function(data) {
			if (data.status == "ok") {
				$scope.setProject($scope.project.id);
				alert("PBI created");
				$('#modal_backlog').modal('hide');
			} else if (data.status == "error") {
				alert(data.reason);
				
			}
		}).error(function(error) {
			alert(error);
		});
	}
	
	//Adds a PBI to a project. And a backlog if it doesn't exist
	$scope.addBacklog = function() {
		$scope.bklNameRequired = '';
		$scope.bklDescriptionRequired = '';
		$scope.bklPriorityRequired = '';
		$scope.bklTypeRequired = '';

		if (!$scope.bklName) {
			$scope.bklNameRequired = 'Required';
		} else if (!$scope.bklDescription) {
			$scope.bklDescriptionRequired = 'Required';
		}else if (!$scope.bklPriority) {
			$scope.bklPriorityRequired = 'Required';
		}else if (!$scope.bklType) {
			$scope.bklTypeRequired = 'Required';
		} else {
			
			var postData = {
				'name' : $scope.bklName,
				'description': $scope.bklDescription,
				'type' : $scope.bklType,
				'priority': $scope.bklPriority,
				'dueDate': Math.floor(((new Date()).getTime())/1000)
			};
			if(Object.size($scope.backlog) <= 0){
				$http.post(url_addBacklog.format($scope.project.id), JSON.stringify({'description':'backlog'})).success(function(data) {
					if (data.status == "ok") {
						
						var postData = {
								'name' : $scope.bklName,
								'description': $scope.bklDescription,
								'type' : $scope.bklType,
								'priority': $scope.bklPriority,
								'dueDate': Math.floor(((new Date()).getTime())/1000)
							};
						
						$scope.addPBI(postData);
					} else if (data.status == "error") {
						alert(data.reason);
						$('#modal_backlog').modal('hide');
					}
				}).error(function(error) {
					alert(error);
					$('#modal_backlog').modal('hide');
				});
			}else{
				$scope.addPBI(postData);
			}
		}
	}
	
	//Saves a new project. STAKEHOLDER only
	$scope.saveProject = function() {
		$scope.nameRequired = '';
		$scope.descriptionRequired = '';
		$scope.managerRequired = '';

		if (!$scope.prjName) {
			$scope.nameRequired = 'Required';
		} else if (!$scope.prjDescription) {
			$scope.descriptionRequired = 'Required';
		}else if (!$scope.prjManager) {
			$scope.managerRequired = 'Required';
		} else {
			var postData = {
				'name' : $scope.prjName,
				'description': $scope.prjDescription,
				'manager': $scope.prjManager.id
			};
			
			$http.post(url_createProjects, JSON.stringify(postData)).success(function(data) {
				if (data.status == "created") {
					$scope.getUserProjects();
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
	$scope.projects = [];
	$scope.project = {};
	$scope.projectManager = {};
	$scope.developers = [];
	$scope.backlog = {};
	$scope.sprints = [];
	$scope.currentSprint = {};
	$scope.tasks = [];
	$scope.completion = [];
	$scope.srvDevelopers = [];
	$scope.devFetch = false;
	
	$('#nSplEnd').datepicker({
		dateFormat: "dd/mm/yy"
	});
	$('#nSplStart').datepicker({
		dateFormat: "dd/mm/yy"
	});
	
	//gets the info of the active user of the system
	restUsers.getCurrentUser(function(response){
		if(response.status == "error"){
			window.location.replace(url_login);
		}else{
			$scope.user = response; 
			global_usr_id = response.id;
		}
    });
	
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
	$scope.getUserProjects = function(){
		$http.get(url_getProjects).success(function(data){
	
	        $scope.projects = data.projects;
	        if($scope.projects.length > 0){
	        	$scope.setProject($scope.projects[0].id);
	        }else{
	        	$scope.setProject(null);
	        }
		});
	}
	
	if($scope.projects.length <=0){
		$scope.getUserProjects();
	}
	
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
		setChart('','','','');
		$http.get(url_getSprintlog.format(''+projectId)).success(function(data){
	        $scope.sprints = data.sprintlogs;
	        if(data.sprintlogs.length > 0){
		        //orders by the start date, starting with the most recent one 
		        $scope.sprints.sort(function(a,b) { 
		        	return parseFloat(b.startDate) - parseFloat(a.startDate) 
		        });
		        
		        $scope.setCurrentSprint(0);
	        }
		});
	};
	
	
	//Sets the current working project to display on the dashboard
	$scope.setProject = function(idProject){
		$scope.resetVariables();
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
	
	//Opens the PBI manager pop up. MANAGER only
	$scope.openPbiManager = function(){
		$('#txt_bklName').val('');
		$('#txt_bklDescription').val('');
		$('#modal_backlog').modal('show');
	}
	
	//Opens the Task manager pop up
	$scope.openTaskManager = function(){
		$('#modal_taskManager').modal('show');
	}
	
	//Opens the Sprintlog manager pop up. MANAGER only
	$scope.openSplManager = function(){
		
		$('#modal_splManager').modal('show');
		
	}
	
	//if the user has no projects sets the variable to blank
	$scope.resetVariables = function(){
		$scope.project = {};
		$scope.projectManager = {};
		$scope.developers = [];
		$scope.backlog = {};
		$scope.sprints = [];
		$scope.currentSprint = {};
		$scope.tasks = [];
		$scope.completion = [];
	}
	
	//gets a formated date from a UNIX timestamp
	$scope.getDate = function(time_date){
		var res = new Date(time_date*1000);
		res = res.getDate()+"/"+(res.getMonth()+1)+"/"+res.getFullYear();
		return res;
	}
	
	//get a range of numbers to the maximum value with a step value
	$scope.getRange = function(maxVal, step){
		var res = [];
		for(var i=step; i<=maxVal; i=i+step){
	        res.push(i);
	    }
		return res;
	}
	
}]);

//Controller of the angularJS module
dashboard.controller('Tasks', ['$scope', '$http', function($scope, $http){
	
	$scope.splPbis = [];
	$scope.nSpl = {};
	$scope.pbiFetchState = "Loading PBIs...";
	$scope.taskFetchState = "Loading Tasks...";
	
	$scope.loadSplPbis = function(splInd, splId){
		$scope.pbiFetchState = "Loading PBIs...";
		$http.get(url_getPBIs.format($scope.project.id, splId)).success((function(splInd){
			return function(data){
				var ret = data.pbis;
				var res = [];
				
				
				
				for(var i=0; i<ret.length; i++){
					for(var y=0; y<$scope.backlog.length; y++){
						if($scope.backlog[y].id == ret[i]){
							res.push($scope.backlog[y]);
							break;
						}
					}
				}
				if(res.length <= 0){
					$scope.pbiFetchState = "No items are set";
				}
				$scope.splPbis[splInd] = res;
			}
			
		})(splInd));
	}
	
	$scope.deleteSprintlog = function(splId){
		if(confirm("Are you sure that you want to delete the sprintlog?. All the information of it will be lost. The backlog items will be preserved in the backlog")){
			var postData = {};
			$http.post(url_deleteSpl.format($scope.project.id, splId), JSON.stringify(postData)).success(function(data) {
				if (data.status == "ok") {
					$scope.setProject($scope.project.id);
					alert('Sprintlog deleted correctly');
				} else if (data.status == "error") {
					alert(data.reason);
				}
			}).error(function(error) {
				alert(error);
				
			});
		}
	}
	
	$scope.deleteTask = function(taskId){
		if(confirm("Are you sure that you want to delete the task?")){
			var postData = {};
			$http.post(url_delTask.format($scope.project.id, taskId), JSON.stringify(postData)).success(function(data) {
				if (data.status == "ok") {
					$scope.setProject($scope.project.id);
					alert('Task deleted correctly');
				} else if (data.status == "error") {
					alert(data.reason);
				}
			}).error(function(error) {
				alert(error);
				
			});
		}
		
	}
	
	$scope.removePbiFromSpl = function(splId, pbiId){
		if(confirm("Are you sure that you want to remove the PBI from the sprintlog?.")){
			var postData = {
				'id': pbiId
			};
			
			$http.post(url_remPBISpl.format($scope.project.id, splId), JSON.stringify(postData)).success(function(data) {
				if (data.status == "ok") {
					$scope.setProject($scope.project.id);
					alert('PBI was removed from sprintlog');
				} else if (data.status == "error") {
					alert(data.reason);
				}
			}).error(function(error) {
				alert(error);
				
			});
		}
	}
	
	$scope.openAddPbi = function(splId){
		$('#modal_splId').val(splId);
		
		$("#modal_addPBI").modal('show');
	}
	
	$scope.openAddTaskToPbi = function(pbiId){
		$('#modal_pbiId').val(pbiId);
		
		$("#modal_addTask").modal('show');
	}
	
	$scope.addTaskToPbi = function(){
		var pbiId = $('#modal_pbiId').val();
		
		if(pbiId != null){
			$scope.pbiTaskNameRequired = '';
			$scope.pbiTaskDescriptionRequired = '';

			if (!$scope.pbiTaskDescription) {
				$scope.fnameRequired = 'Required';
			} else if (!$scope.pbiTaskName) {
				$scope.lnameRequired = 'Required';
			} else {
				var postData = {
					'name':$scope.pbiTaskName,
					'description':$scope.pbiTaskDescription,
					'points' : 0,
					'developer' : $scope.project.manager,
					'state' : 'awaiting',
					'completionDate':0
				}
				$http.post(url_createTask.format($scope.project.id, pbiId), 
							JSON.stringify(postData)).success(function(data) {
					if (data.status == "ok") {
						alert("Task created successfuly");
					} else if (data.status == "error") {
						alert(data.reason);
						
					}
				}).error(function(error) {
					alert(error);
					
				});
			}
		}
	}
	
	$scope.addPbiToSpl = function(){
		var splId = $('#modal_splId').val();
		
		if(splId != null){
			var toAdd = [];
			var extraInfo = [];
			$('#list_pbiToSpl').children('li').each(function(){
				if($(this).children('input:checked').first().attr('id') != undefined){
					toAdd.push($(this).children('input:checked').first().attr('id'));
					var extra = {
						'id':$(this).children('input:checked').first().attr('id'),
						'name':$(this).children('input:checked').first().data('name'),
						'description':$(this).children('input:checked').first().data('description')
					}
					extraInfo.push(extra);
				}
			});
			if(toAdd.length > 0){
				for(var i=0; i< toAdd.length; i++){
					var postData = {
						'id' : parseInt(toAdd[i])
					};
					var extra = extraInfo[i];
					
					$http.post(url_addPBISpl.format($scope.project.id, splId), 
							JSON.stringify(postData)).success((function(extra) {
						return function(data){
							if (data.status == "ok") {
								var postData = {
									'name':extra.name,
									'description':extra.description,
									'points' : 0,
									'developer' : $scope.project.manager,
									'state' : 'awaiting',
									'completionDate': 0
								}
								$http.post(url_createTask.format($scope.project.id, extra.id), 
											JSON.stringify(postData)).success(function(data) {
									if (data.status == "ok") {
										
									} else if (data.status == "error") {
										alert(data.reason);
										
									}
								}).error(function(error) {
									alert(error);
									
								});
							} else if (data.status == "error") {
								alert(data.reason);
								
							}
						}
					})(extra)).error(function(error) {
						alert(error);
						
					});
				}
				$scope.setProject($scope.project.id);
				alert('Items added to the sprintlog');
				$("#modal_addPBI").modal('hide');
			}else{
				alert("you haven't added any items");
			}
		}
	}
	
	$scope.loadSplPbisTasks = function(parentIndex, curIndex, pbiId){
		var indexes = [parentIndex, curIndex];
		$scope.taskFetchState = "Loading Tasks...";
		$http.get(url_getTasks.format($scope.project.id, pbiId)).success((function(indexes){
			return function(data){
				
				var res = data.tasks;
				
				if(res.length <= 0){
					$scope.taskFetchState = "No tasks are set";
				}
				
				$scope.splPbis[indexes[0]][indexes[1]].tasks = res;
			}
			
		})(indexes));
	}
	
	$scope.saveNewSprintlog = function(){
		var timeEnd = null;
		var timeStart = null;
		if($scope.nSpl.name && $scope.nSpl.description && $scope.nSpl.startDate && $scope.nSpl.endDate){
			
			timeEnd = $.datepicker.formatDate('@',$.datepicker.parseDate( "d/m/yy", $scope.nSpl.endDate));
			timeStart = $.datepicker.formatDate('@',$.datepicker.parseDate( "d/m/yy", $scope.nSpl.startDate));
			var nowDate = new Date().getTime();
			
			if(timeEnd <= timeStart){
				alert("End time cannot be before start time");
				return;
			}
			
			if(timeStart < nowDate){
				alert("You can't create a sprintlog for a date that has already passed");
				return;
			}
			
		}else{
			alert("All fields are required");
			return;
		}
		
		var postData = {
			'name' 			: $scope.nSpl.name,
			'description' 	: $scope.nSpl.description,
			'startDate'		: Math.round(timeStart/1000),	
			'endDate'		: Math.round(timeEnd/1000),
			'idpbis'		: []
		};
		
		$http.post(url_createSprint.format($scope.project.id), JSON.stringify(postData)).success(function(data) {
			if (data.status == "ok") {
				$scope.setProject($scope.project.id);
				alert("Sprint log created");
			} else if (data.status == "error") {
				alert(data.reason);
				
			}
		}).error(function(error) {
			alert(error);
		});
	}
	
	$scope.updateTask = function(idTask, tkName, tkDesc, tkPoints, tkDev, tkState){
		var postData = {
			'name' 			: tkName,
			'description' 	: tkDesc,
			'points'		: tkPoints,	
			'developer'		: tkDev,
			'state'		: tkState
		};
		if(tkState == 'completed'){
			postData.completionDate = Math.floor(((new Date()).getTime())/1000);
		}else{
			postData.completionDate = 0;
		}
		$http.post(url_editTask.format($scope.project.id, idTask), JSON.stringify(postData)).success(function(data) {
			if (data.status == "ok") {
				$scope.setProject($scope.project.id);
				alert("Saved");
			} else if (data.status == "error") {
				alert(data.reason);
				
			}
		}).error(function(error) {
			alert(error);
			
		});
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
	
	//gets the points of a developer in a project
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
	
	if(startDate == ''){
		$('#panel_burndown').hide();
	}else{
		$('#panel_burndown').show();
	}
	
	var data = [];
	var totalTask = chTasks.length;
	
	var diff = Math.ceil((endDate - startDate) / 86400);
	
	for(var i=0; i<=diff; i++){
		var dayDate = (startDate+(i*86400));
		var totTask = totalTask;
		
		for(var y=0; y<chTasks.length; y++){
			if(chTasks[y].state == 'completed' && chTasks[y].completionDate <= dayDate && chTasks[y].completionDate != 0){
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