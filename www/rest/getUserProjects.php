<?php


$response = array(
	projects => 
		array(
			array(
				id => "1",
				name => "Software Management Project", 
				description => "SPM This is a dummy test project, with a name, description and some developers", 
				manager => "2", 
				stakeholder => "10", 
				developers => array(
					"1",
					"2",
					"3",
					"4",
				),
				creationDate => "17/11/2014"
			),
			array(
					id => "2",
					name => "Critical Software Project",
					description => "Critical Software This is a dummy test project, with a name, description and some developers",
					manager => "1",
					stakeholder => "10",
					developers => array(
							"1",
							"2",
							"3",
							"4",
					),
					creationDate => "19/11/2014"
			),
			array(
					id => "3",
					name => "Verification and Validation Project",
					description => "V&V This is a dummy test project, with a name, description and some developers",
					manager => "3",
					stakeholder => "10",
					developers => array(
							"1",
							"2",
							"3",
							"4",
					),
					creationDate => "22/09/2014"
			),
			array(
					id => "4",
					name => "WeObserve iPhone app",
					description => "WEObserve This is a dummy test project, with a name, description and some developers",
					manager => "1",
					stakeholder => "10",
					developers => array(
							"1",
							"2",
							"3",
							"4",
					),
					creationDate => "12/06/2014"
			),
			array(
					id => "5",
					name => "Insysoft, insysmovil android app",
					description => "Insysmovil, web app This is a dummy test project, with a name, description and some developers",
					manager => "2",
					stakeholder => "10",
					developers => array(
							"1",
							"2",
							"3",
							"4",
					),
					creationDate => "15/10/2014"
			),
			array(
					id => "6",
					name => "Data engineering something something project",
					description => "data engiener This is a dummy test project, with a name, description and some developers",
					manager => "2",
					stakeholder => "10",
					developers => array(
							"1",
							"2",
							"3",
							"4",
					),
					creationDate => "17/07/2014"
			),
			array(
					id => "8",
					name => "Nice final Project",
					description => "My beautiful nice project This is a dummy test project, with a name, description and some developers",
					manager => "2",
					stakeholder => "10",
					developers => array(
							"1",
							"2",
							"3",
							"4",
					),
					creationDate => "27/10/2014"
			)
		)
);
//$response = array(projects => array());
echo json_encode($response);