//global variables to the REST services
var url_login = "account/login";
var url_recoverPwd = "/account/recoverpassword";

//global var
var url_dashboard = "dashboard.html";

//Initializes the dashboard with AngularJS
var login = angular.module('login', []);



//Controller of the angularJS module
login.controller('loginController', ['$scope', '$http', function($scope, $http){
	$scope.username = "";
	$scope.password = "";
	
	$("#birth").datepicker({
		dateFormat: "dd/mm/yy"
	});
	
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
		
		var data_post = {
        	'email' : $scope.username,
			'password' : $scope.password
            
        };
		
		$http.post(url_login, JSON.stringify(data_post)).success(function(data) {
			//console.log(data);
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
	
	
	
	$scope.recoverPassword = function() {
		
		$scope.emailRequired = '';
		$scope.birthRequired = '';
		
		if (!$scope.email) {
			$scope.emailRequired = 'Required';
		}else if (!$scope.birth) {
			$scope.birthRequired = 'Required';
		}else{
			var timestamp = Math.round($.datepicker.formatDate('@',$.datepicker.parseDate( "d/m/yy", $scope.birth))/1000);
			var data_post = {
	        	'email' : $scope.email,
				'dateOfBirth' : timestamp
	        };
			
			$http.post(url_recoverPwd, JSON.stringify(data_post)).success(function(data) {
				//console.log(data);
				if (data.status == "ok") {
					alert("Your new password has been sent to your email account. Check your spam folder");
					$('#modal_pwdRecovery').modal('hide');
				} else if (data.status == "error") {
					alert(data.reason)
				}
			}).error(function(data) { // optional
				alert(data.reason);
			});
		}
	};
	
}]);
