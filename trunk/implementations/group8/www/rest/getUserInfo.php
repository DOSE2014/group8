<?php

$response = array(
	array(
		id =>"1",
		firstname => "Williams",
		lastname => "Aguilera",
		sex => "M", 
		dateOfBirth => "27/10/1989",
		country => "Venezuela",
		timezone => "+01:00", 
		email => "webnator@gmail.com",
		languages => array(
			"spanish",
			"english",
			"portuguese"
		),
		type => "developer" 
	),
	
	array(
			id =>"2",
			firstname => "Alejandro",
			lastname => "Correia",
			sex => "M",
			dateOfBirth => "12/12/1989",
			country => "Madrid",
			timezone => "+02:00",
			email => "waguilera@gmail.com",
			languages => array(
					"spanish",
					"english",
					"portuguese"
			),
			type => "developer"
	),
	
	array(
			id =>"3",
			firstname => "Maria",
			lastname => "Laurentin",
			sex => "F",
			dateOfBirth => "30/07/1990",
			country => "Venezuela",
			timezone => "+01:00",
			email => "mglt@gmail.com",
			languages => array(
					"spanish",
					"english",
					"portuguese",
					"french"
			),
			type => "stakeholder"
	)
);

$userId = $_GET['id'];

foreach($response as $user){
	//echo "-".;
	if($user["id"]==$userId){
		echo json_encode($user);
		break;
	}
}
