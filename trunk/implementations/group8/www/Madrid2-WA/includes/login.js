//global variables to the REST services
var url_login = "rest/login.php";

//global var
var url_dashboard = "dashboard.php";

//Initializes the dashboard with AngularJS
var login = angular.module('login', []);



//Controller of the angularJS module
login.controller('loginController', ['$scope', '$http', function($scope, $http){
	$scope.username = "";
	$scope.password = "";
	
	$scope.login = function() {
		// Authentication against the server
		$scope.usernameRequired = '';
		$scope.passwordRequired = '';
		
		if (!$scope.username) {
			$scope.usernameRequired = 'Username is required, use your email account';
		}
		if (!$scope.password) {
			$scope.passwordRequired = 'Password is required';
		}
		$scope.dataLoading = true;
		
		var data_post = $.param({
        	email : $scope.username,
			password : $scope.password
            
        });
		
		$http({
			url : url_login,
			method : "POST",
			headers: {'Content-Type': 'application/x-www-form-urlencoded'},
			data : data_post
		}).success(function(data) {
			
			if (data.status == "ok") {
				window.location = url_dashboard
			} else if (data.status == "error") {
				alert("Login failed")
				$scope.dataLoading = false;
				
			}
		}).error(function(data) { // optional
			$scope.dataLoading = false;
		});
	};
	
}]);
