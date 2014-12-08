//global variables to the REST services
var url_login = "account/login";
var url_getLang = "account/langs";

//global var
var url_dashboard = "dashboard.php";

//Initializes the dashboard with AngularJS
var reg = angular.module('registration', []);


//Controller of the angularJS module
reg.controller('regController', ['$scope', '$http', function($scope, $http){
	
	$scope.languages = {
		"languages" : [],
		"programmingLanguages" : []
	};
	
	$http.get(url_getLang).success(function(data){
        $scope.languages = data;
    });
	
	
	$("#birthdate").datepicker();

	$scope.timezones = [
'Pacific/Midway',
'Pacific/Samoa',
'Pacific/Honolulu',
'US/Alaska',
'America/Los_Angeles',
'America/Tijuana',
'US/Arizona',
'America/Chihuahua',
'America/Chihuahua',
'America/Mazatlan',
'US/Mountain',
'America/Managua',
'US/Central',
'America/Mexico_City',
'America/Mexico_City',
'America/Monterrey',
'Canada/Saskatchewan',
'America/Bogota',
'US/Eastern',
'US/East-Indiana',
'America/Lima',
'America/Bogota',
'Canada/Atlantic',
'America/Caracas',
'America/La_Paz',
'America/Santiago',
'Canada/Newfoundland',
'America/Sao_Paulo',
'America/Argentina/Buenos_Aires',
'America/Argentina/Buenos_Aires',
'America/Godthab',
'America/Noronha',
'Atlantic/Azores',
'Atlantic/Cape_Verde',
'Africa/Casablanca',
'Europe/London',
'Etc/Greenwich',
'Europe/Lisbon',
'Europe/London',
'Africa/Monrovia',
'UTC',
'Europe/Amsterdam',
'Europe/Belgrade',
'Europe/Berlin',
'Europe/Berlin',
'Europe/Bratislava',
'Europe/Brussels',
'Europe/Budapest',
'Europe/Copenhagen',
'Europe/Ljubljana',
'Europe/Madrid',
'Europe/Paris',
'Europe/Prague',
'Europe/Rome',
'Europe/Sarajevo',
'Europe/Skopje',
'Europe/Stockholm',
'Europe/Vienna',
'Europe/Warsaw',
'Africa/Lagos',
'Europe/Zagreb',
'Europe/Athens',
'Europe/Bucharest',
'Africa/Cairo',
'Africa/Harare',
'Europe/Helsinki',
'Europe/Istanbul',
'Asia/Jerusalem',
'Europe/Helsinki',
'Africa/Johannesburg',
'Europe/Riga',
'Europe/Sofia',
'Europe/Tallinn',
'Europe/Vilnius',
'Asia/Baghdad',
'Asia/Kuwait',
'Europe/Minsk',
'Africa/Nairobi',
'Asia/Riyadh',
'Europe/Volgograd',
'Asia/Tehran',
'Asia/Muscat',
'Asia/Baku',
'Europe/Moscow',
'Asia/Muscat',
'Europe/Moscow',
'Asia/Tbilisi',
'Asia/Yerevan',
'Asia/Kabul',
'Asia/Karachi',
'Asia/Karachi',
'Asia/Tashkent',
'Asia/Calcutta',
'Asia/Kolkata',
'Asia/Calcutta',
'Asia/Calcutta',
'Asia/Calcutta',
'Asia/Katmandu',
'Asia/Almaty',
'Asia/Dhaka',
'Asia/Dhaka',
'Asia/Yekaterinburg',
'Asia/Rangoon',
'Asia/Bangkok',
'Asia/Bangkok',
'Asia/Jakarta',
'Asia/Novosibirsk',
'Asia/Hong_Kong',
'Asia/Chongqing',
'Asia/Hong_Kong',
'Asia/Krasnoyarsk',
'Asia/Kuala_Lumpur',
'Australia/Perth',
'Asia/Singapore',
'Asia/Taipei',
'Asia/Ulan_Bator',
'Asia/Urumqi',
'Asia/Irkutsk',
'Asia/Tokyo',
'Asia/Tokyo',
'Asia/Seoul',
'Asia/Tokyo',
'Australia/Adelaide',
'Australia/Darwin',
'Australia/Brisbane',
'Australia/Canberra',
'Pacific/Guam',
'Australia/Hobart',
'Australia/Melbourne',
'Pacific/Port_Moresby',
'Australia/Sydney',
'Asia/Yakutsk',
'Asia/Vladivostok',
'Pacific/Auckland',
'Pacific/Fiji',
'Pacific/Kwajalein',
'Asia/Kamchatka',
'Asia/Magadan',
'Pacific/Fiji',
'Asia/Magadan',
'Asia/Magadan',
'Pacific/Auckland',
'Pacific/Tongatapu'
	                    
	                    ]	
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
		$scope.organizationRequired = '';
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
		} else if (!$scope.formInfo.Organization) {
			$scope.organizationRequired = 'Organization Required';
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
				'organization' : $scope.formInfo.Organization,
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
					
						alert(data.reason);
				}
			}).error(function(error) {
				alert(error);
			});
			
		}
	};
}]);
