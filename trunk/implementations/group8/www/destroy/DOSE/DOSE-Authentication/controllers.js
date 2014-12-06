'use strict';

/*Index.html controllers*/

angular.module('myApp.controllers',[])

	.controller('LoginController',['$scope',function ($scope){

        $scope.login = function () {
        	//Authentication against the server
    		$scope.usernameRequired = '';
    		$scope.passwordRequired = '';
    		
    		if(!$scope.username){
    			$scope.usernameRequired = 'Username is required, use your email account';
    		}
    		if(!$scope.password){
    			$scope.passwordRequired = 'Password is required';
    		}
            $scope.dataLoading = true;//Loading .gif visible
          alert("toy en login");
            $http.post('/account/login', { email: username, password: password }).success(function(data) { 
            	if (data.status = "ok"){
                	window.location="home.html"
                }else if (data.status == "error"){
                	if(data.code="1"){
                		alert("login failed")
                		$scope.dataLoading = false;
                	}
                }
            	
            }).error(function(data){
            	alert(error)
            	$scope.dataLoading = false;
            });
        };
    }]);