var viewSprintlog = angular.module('viewSprintlog', []);

viewSprintlog.controller("customerController", function($scope,$http) {
    $http.get("http://www.w3schools.com/website/Customers_JSON.php")
	//Change address to the correct one
    .success(function(response) {$scope.pbis = response;});
	//should only get the Backlog Items that are not allready in a list
});
viewSprintlog.controller('newTasks', ['$scope', function($scope){
    $scope.numberTasks = 1;
    
    $scope.range = function() {
        //alert($scope.numberTasks);
        
        return new Array(parseInt($scope.numberTasks));
    };
}]);





