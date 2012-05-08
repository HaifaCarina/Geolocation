<?php
include_once("includes/database.php");



$query = "INSERT INTO juno 
(name,category,star_rating,remarks, address_1,address_2,city,state,zip,coordinates,user_id)
VALUES ('".
$_GET['name']."','".
$_GET['category']."','".
$_GET['star_rating']."','".
$_GET['remarks']."','".
$_GET['address_1']."','".
$_GET['address_2']."','".
$_GET['city']."','".
$_GET['state']."', '".
$_GET['zip']."','".
$_GET['coordinates']."','".
$_GET['user_id']."')";

//echo $query;

if ( mysql_query($query) ) {
	echo 'success';
}else { echo 'dead'; }

?>