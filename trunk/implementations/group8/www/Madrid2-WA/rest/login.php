<?php
if($_POST['email'] == "dev" && $_POST['password'] == "123"){
	$response = array(
		status => "ok"
	);
}else{
	$response = array(
		status => "error"
	);
}
echo json_encode($response);
