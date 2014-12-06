'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  controller('MyCtrl1', ['$scope', function($scope) {
	$scope.formInfo = {};
	
	$scope.saveData = function(){
		$scope.fnameRequired = '';
		$scope.lnameRequired = '';
		$scope.sexRequired = '';
		$scope.birthRequired = '';
		$scope.cityRequired = '';
		$scope.countryRequired = '';
		$scope.tZoneRequired = '';
		$scope.emailRequired = '';
		$scope.passwordRequired = '';
		$scope.languagesRequired = '';
		$scope.userRequired = '';
		$scope.pLanguagesRequired = '';

		if(!$scope.formInfo.fName){
			$scope.fnameRequired = 'First Name Required';
		}
		else if(!$scope.formInfo.lName){
			$scope.lnameRequired = 'Last Name Required';
		}
		else if(!$scope.formInfo.Sex){
			$scope.sexRequired = 'Sex Required';
		}
		else if(!$scope.formInfo.Birth){
			$scope.birthRequired = 'Date of Birth Required';
		}
		else if(!$scope.formInfo.City){
			$scope.cityRequired = 'City Required';
		}
		else if(!$scope.formInfo.Country){
			$scope.countryRequired = 'Country Required';
		}
		else if(!$scope.formInfo.tZone){
			$scope.tZoneRequired = 'Time Zone Required';
		}
		else if(!$scope.formInfo.Email){
			$scope.emailRequired = 'Email Required';
		}
		else if(!$scope.formInfo.Password){
			$scope.passwordRequired = 'Password Required';
		}
		else if(!$scope.formInfo.Languages){
			$scope.languagesRequired = 'At least, English Required';
		}
		else if(!$scope.formInfo.User){
			$scope.userRequired = 'User Required';
		}
		else if($scope.formInfo.User == "developer"){
			$scope.pLanguagesRequired = 'Programming Languages Required';
		}
		else{
			alert("entramos");
			var timestamp = new Date($scope.formInfo.Birth)
			var postData = {
					firstname: $scope.formInfo.fName, 
	            	lastname: $scope.formInfo.lName,
	            	sex: $scope.formInfo.Sex,
	            	dateOfBirth: timestamp.getTime(),
	            	city: $scope.formInfo.City,
	            	country: $scope.formInfo.Country,
	            	timezone: $scope.formInfo.tZone,
	            	email: $scope.formInfo.Email,
	            	password: $scope.formInfo.Password,
	            	languages: $scope.formInfo.Languages,
	            	type: $scope.formInfo.User,
	            	programmingLanguages: $scope.formInfo.pLanguages == null ? 0: $scope.formInfo.pLanguages
	        };
            $http.post('/account/register', postData).success(function(data) {
            	alert(data.status);
                if (data.status = "ok"){
                	window.location="../../DOSE-Registration/WebContent/index.html"
                }else if (data.status="error"){
                	if(data.code="1"){
                		alert("email already exists");
                	}else if(data.code="2"){
                		alert(data.field+" has problems because:"+data.reason);
                	}
                }
            }).error(function(error){
            	alert(error);
            });
            alert("fuera del post");
		}
	};
  }])