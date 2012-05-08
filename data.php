<?php
include_once("includes/database.php");

//$origin = '14.562570,121.013460';
//$destination = '14.553013,121.02201';

$sortByDistance = $_GET['sortByDistance'];
$origin = $_GET['origin'];
#####################

$query = "SELECT * from juno ORDER BY star_rating DESC "; //LIMIT 10

$result = mysql_query($query);

while($row = mysql_fetch_array($result))
  {
  	//$destination = $row['coordinates'];
  	$destination = $row['latitude'].",".$row['longitude'];
  	
  	$json_url = 'https://maps.googleapis.com/maps/api/directions/json?units=imperial&origin='.$origin.'&destination='.$destination.'&sensor=true';
	
	// jSON String for request
	$json_string = '[your json string here]';
	// Initializing curl
	$ch = curl_init( $json_url );
	// Configuring curl options
	$options = array(
	CURLOPT_RETURNTRANSFER => true,
	CURLOPT_HTTPHEADER => array('Content-type: application/json') ,
	CURLOPT_POSTFIELDS => $json_string
	);
	// Setting curl options
	curl_setopt_array( $ch, $options );
	// Getting results
	$r =  curl_exec($ch); 
	
	$decoded_json = json_decode($r, true);
	$distance = $decoded_json['routes'][0]['legs'][0]['distance']['text'];

	$row['distance'] = $distance;
  	$row_set[] = $row;

  	$distanceArray[] = $row['distance'];
  	
  }
  if($sortByDistance) {
  	array_multisort($distanceArray, SORT_ASC, $row_set);
  }
$data =  json_encode($row_set);
$data = str_replace('\\','',$data);

//mysql_close($con);
/*
echo "<pre>";
print_r($row_set);
echo "</pre>";

*/
//header('Content-Type: application/x-json');

echo '{"files":'.$data.'}';

?>