<?php
include_once("includes/database.php");

$query = "UPDATE juno set name='".$_GET['name'].
"',category= '".$_GET['category'].
"',star_rating= '".$_GET['star_rating'].
"',remarks= '".$_GET['remarks'].
"',address_1= '".$_GET['address_1'].
"',address_2= '".$_GET['address_2'].
"',city= '".$_GET['city'].
"',state= '".$_GET['state'].
"',zip= '".$_GET['zip'].
"',latitude= '".$_GET['latitude'].
"',longitude= '".$_GET['longitude'].
//"',coordinates= '".$_GET['coordinates'].
"' where id='".$_GET['id']."'";
//echo $query;

if ( mysql_query($query) ) {
	echo 'success';
}else { echo 'dead'; }

?>