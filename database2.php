<?php
/**
 * Connect to the mysql database.
 */
//$conn = mysql_connect("localhost", "root", "") or die(mysql_error());
//mysql_select_db('geolocation', $conn) or die(mysql_error());
//live
$conn = mysql_connect("nmgdev.com", "nmgdev_mapping", "12#45") or die(mysql_error());
mysql_select_db('nmgdev_mapping', $conn) or die(mysql_error());
$api_key='AIzaSyAAjWzkKR8qxkjxkxQ-uUvK-1xicHvNhhY';
?>