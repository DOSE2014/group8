var url_getBacklogpbi = "/projects/{0}/getbacklog";

var projectId = 1;
var backlId = 1;
var splId = 1;

var viewSprintlog = angular.module('viewSprintlog', []);

viewSprintlog.controller('Sprintlogcontroller', ['$scope','$http', function($scope,$http){
	
	var global_usr_id = null;
	$scope.backlId = backlId;
	$scope.splId = splId;
	$scope.pbis = null;
	$http.get(url_getBacklogpbi.format(backlId)).success(function(response) {
		$scope.pbis = response.pbis;
	});
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







