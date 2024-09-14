<?php

	include '../include/connection.php';
	
	$data = file_get_contents('php://input');
	$dataDecode = json_decode($data, true);

	$name = $dataDecode['email'];
	$password = $dataDecode['password'];

	$query = "SELECT * FROM tbl_user WHERE email_user = '$name' AND password = '$password'";
	$check = mysqli_fetch_array(mysqli_query($conn, $query));
	$getData = mysqli_fetch_assoc(mysqli_query($conn, $query));

	if (isset($check)) {

		$scs = 'Successfully login';  //0
		$array = [$getData['id_user'], //1
				$getData['name_user'], //2
				$getData['email_user'], //3
				$getData['photo_user'],  //4
				$scs];
		echo json_encode($array);
	}else{
		$invalidSuccess = 'Name or password incorrect or Account not exist';
		$failedMsg = json_encode($invalidSuccess);
		echo $failedMsg;
	}
	mysqli_close($conn);
?>