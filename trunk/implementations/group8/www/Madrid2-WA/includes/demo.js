/**
 * 
 */

var myDemo = angular.module('demo', []);



myDemo.controller('myDemo', ['$scope', function($scope){
	$scope.numberTasks = 5;
	
	$scope.range = function() {
		//alert($scope.numberTasks);
		
        return new Array(parseInt($scope.numberTasks));
    };
}]);