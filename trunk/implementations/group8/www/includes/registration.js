//global variables to the REST services
var url_login = "account/login";

//global var
var url_dashboard = "dashboard.php";

//Initializes the dashboard with AngularJS
var reg = angular.module('registration', []);


//Controller of the angularJS module
reg.controller('regController', ['$scope', '$http', function($scope, $http){
	$("#birthdate").datepicker();

	$scope.timezones = ["-12","-11","-10","-9","-8","-7","-6","-5","-4","-3","-2","-1","0","+1","+2","+3","+4","+5","+6","+7","+8","+9","+10","+11","+12"];
	
	$scope.formInfo = {};
	
	$scope.goTo = function(url){
		window.location=url;
	}

	$scope.saveData = function() {
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

		if (!$scope.formInfo.fName) {
			$scope.fnameRequired = 'First Name Required';
		} else if (!$scope.formInfo.lName) {
			$scope.lnameRequired = 'Last Name Required';
		} else if (!$scope.formInfo.Sex) {
			$scope.sexRequired = 'Sex Required';
		} else if (!$scope.formInfo.Birth) {
			$scope.birthRequired = 'Date of Birth Required';
		} else if (!$scope.formInfo.City) {
			$scope.cityRequired = 'City Required';
		} else if (!$scope.formInfo.Country) {
			$scope.countryRequired = 'Country Required';
		} else if (!$scope.formInfo.tZone) {
			$scope.tZoneRequired = 'Time Zone Required';
		} else if (!$scope.formInfo.Email) {
			$scope.emailRequired = 'Email Required';
		} else if (!$scope.formInfo.Password) {
			$scope.passwordRequired = 'Password Required';
		} else if (!$scope.formInfo.Languages) {
			$scope.languagesRequired = 'At least, English Required';
		} else if (!$scope.formInfo.User) {
			$scope.userRequired = 'User Required';
		} else if ($scope.formInfo.User == "developer"
				&& !$scope.formInfo.pLanguages) {
			$scope.pLanguagesRequired = 'Programming Languages Required';
		} else {
			
			var timestamp = $.datepicker.formatDate('@',$.datepicker.parseDate( "d/m/yy", $scope.formInfo.Birth));
			
			var postData = {
				'firstname' : $scope.formInfo.fName,
				'lastname': $scope.formInfo.lName,
				'sex' : $scope.formInfo.Sex,
				'dateOfBirth': timestamp/1000,
				'city' : $scope.formInfo.City,
				'country' : $scope.formInfo.Country,
				'timezone' : $scope.formInfo.tZone,
				'email' : $scope.formInfo.Email,
				'password' : $scope.formInfo.Password,
				'languages' : $scope.formInfo.Languages,
				'type' : $scope.formInfo.User,
				'programmingLanguages' : $scope.formInfo.pLanguages == null ? 0
						: $scope.formInfo.pLanguages
			};
			$http.post('/account/register', JSON.stringify(postData)).success(function(data) {
				console.log(data);
				if (data.status == "ok") {
					alert("Account created")
					window.location = "login.html"
				} else if (data.status == "error") {
					if (data.code = "1") {
						alert("Email already exists");
					} else if (data.code == "2") {
						alert(data.field
								+ " has problems because:"
								+ data.reason);
					}
				}
			}).error(function(error) {
				alert(error);
			});
			
		}
	};
}]);
