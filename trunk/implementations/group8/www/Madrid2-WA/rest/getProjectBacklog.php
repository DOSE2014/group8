<?php

$response = array(
	description => "Project description",
	pbis => array(
		array(
			id => "1",
			name => "PBI 1",
			description => "Descripcion PBI 1",
			backlog => "1",
			type => "X",
			priority => "1",
			creationDate => ""
		),
		array(
				id => "2",
				name => "PBI 2",
				description => "Descripcion PBI 2",
				backlog => "1",
				type => "X",
				priority => "2",
				creationDate => ""
		),
		array(
				id => "3",
				name => "PBI 3",
				description => "Descripcion PBI 3",
				backlog => "1",
				type => "X",
				priority => "4",
				creationDate => ""
		),
		array(
				id => "4",
				name => "PBI 4",
				description => "Descripcion PBI 4",
				backlog => "1",
				type => "X",
				priority => "3",
				creationDate => ""
		),
		array(
				id => "5",
				name => "PBI 5",
				description => "Descripcion PBI 5",
				backlog => "1",
				type => "X",
				priority => "5",
				creationDate => ""
		)
	)	
);

echo json_encode($response);

