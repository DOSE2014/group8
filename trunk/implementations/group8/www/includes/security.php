<?php
	
	$_SESSION['user_id'] = 1;
	
	if(isset($_SESSION['user_id']) && $_SESSION['user_id'] != "" && $_SESSION['user_id'] != null){
		echo "<script>var global_usr_id = ".$_SESSION['user_id']."</script>";
	}else{
		header("Location: login.php");
	}

?>