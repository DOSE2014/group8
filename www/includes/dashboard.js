

var dashboard = angular.module('dashboard', []);

dashboard.config(function(){
	if(global_usr_id == undefined || global_usr_id == ""){
		window.location.replace("login.php");
	}
	
	setChart();
});



dashboard.service('restUsers', function($http) {
	// accept a function as an argument
	this.getUser = function(userId, callback) {
		// Get the logge din users info
		$http.get("rest/getUserInfo.php?id=" + userId).success(
			function(response) {
				callback(response);
			})
	}

});

dashboard.controller('Users', ['$scope', '$http', 'restUsers', function($scope, $http, restUsers){
	var url_getUser = "rest/getUserInfo.php?id="+global_usr_id;
	var url_getProjects = "rest/getUserProjects.php?id="+global_usr_id;
	
	$scope.user = {};
	$scope.projects = {};
	$scope.project = {};
	$scope.projectManager = {};
	
	
	
	$http.get(url_getUser).success(function(data){
        $scope.user = data;
    });
	
	
	$scope.setProjectManager = function(userId){
			//alert(userId);
			restUsers.getUser(userId, function(response){
		        $scope.projectManager = response;
		        console.log('$scope.projectManager = '+$scope.projectManager);        
		    });
	}
	
	$scope.getUserProjects = $http.get(url_getProjects).success(function(data){
        $scope.projects = data.projects;
        if($scope.projects.length > 0){
        	$scope.setProject($scope.projects[0].id);
        }else{
        	$scope.setProject(null);
        }
        
    });
	
	$scope.setProject = function(idProject){
		if(idProject > 0 && idProject != null){
			for(var i=0; i<$scope.projects.length; i++){
				if($scope.projects[i].id == idProject){
					$scope.project = $scope.projects[i];
					$scope.setProjectManager($scope.project.manager);
					break;
				}
			}
		}else{
			$scope.project = {};
			$scope.projectManager = {};
		}
	};
	
	
}]);








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