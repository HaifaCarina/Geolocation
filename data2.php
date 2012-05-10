<?php
include_once("includes/database2.php");

//$origin = '14.562570,121.013460';
//$destination = '14.553013,121.02201';

$sortByDistance = $_GET['sortByDistance'];
$origin = $_GET['origin'];
#####################

//$query = "SELECT * from juno ORDER BY star_rating DESC "; //LIMIT 10
$query = "Select 
wp_posts.ID id,
wp_posts.post_author user_id,
wp_posts.post_title name, 
wp_posts.post_content remarks,
wp_terms.name category, 
address.meta_value address_1,
latitude.meta_value latitude,
longitude.meta_value longitude,
custom_geolocation.address_2,
custom_geolocation.city,
custom_geolocation.state,
custom_geolocation.zip,
custom_geolocation.star_rating
from wp_posts, wp_term_relationships, wp_term_taxonomy, wp_terms, 
wp_postmeta address,
wp_postmeta longitude,
wp_postmeta latitude,
custom_geolocation
WHERE wp_posts.ID = wp_term_relationships.object_id
AND wp_term_relationships.term_taxonomy_id = wp_term_taxonomy.term_taxonomy_id
AND wp_term_taxonomy.term_id = wp_terms.term_id
AND address.post_id = wp_posts.ID
AND longitude.post_id = wp_posts.ID
AND latitude.post_id = wp_posts.ID
AND address.meta_key = 'map_address'
AND longitude.meta_key = 'map_longtitude'
AND latitude.meta_key = 'map_latitude'
AND custom_geolocation.id = wp_posts.ID";
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