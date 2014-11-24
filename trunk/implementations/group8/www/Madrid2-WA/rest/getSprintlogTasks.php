<?php
$response = array(
	sprintlogs =>
	array(
		array(
			id => 1,
			name => "First Sprintlog",
			description => "First sprintlog of the project",
			startDate => "1414108800", //24/10/2014
			endDate => "1414627200" //30/10/2014
		),
		array(
			id => 2,
			name => "Third Sprintlog",
			description => "Third and last sprint log",
			startDate => "1419379200", //24/12/2014
			endDate => "1419897600" //30/12/2014
		),
		array(
			id => 3,
			name => "Second Sprint Log",
			description => "Second sprint log",
			startDate => "1416787200", //24/11/2014
			endDate => "1417305600" //30/11/2014
		),
	)
);

echo json_encode($response);
