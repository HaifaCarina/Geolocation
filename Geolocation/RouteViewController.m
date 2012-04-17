//
//  RouteViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "RouteViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"

@implementation RouteViewController
@synthesize jsonData;

#pragma mark -
#pragma mark Life Cycle methods
- (id) initWithCoordinates:(NSString *)inputCoordinates {
    if (self == [super init]) {
        coordinatesString = inputCoordinates;
        coordinatesArray = [coordinatesString componentsSeparatedByString:@","];
    }
    return(self);
}

- (void) loadView {
	[super loadView];
    
    self.title = @"Route";
    count = 0;
    jsonData = [[NSMutableString alloc] initWithString:@""]; 
    currentCoordinatesString = [[NSMutableString alloc] initWithString:@""];
	
	toCompareCoordinates = [[NSMutableString alloc]initWithString:@""];
	
    calledOnce = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark Custom methods
- (void) startRoute 
{
    // NSString *nmg = @"14.562570,121.013460"; 
	NSString *urlString = [NSString stringWithFormat: 
						   @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true",
						   currentCoordinatesString,coordinatesString];
	
	
	//NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=14.564062,121.013932&destination=14.558808,121.022911&sensor=true"];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[request release]; 
	[connection release];
}

#pragma mark -
#pragma mark CLLocationManager methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!calledOnce) {
        NSString *s =[NSString stringWithFormat:@"%g,%g",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
        [currentCoordinatesString appendString: s];
        calledOnce = YES;
        [self startRoute];
    }
    
    [locationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
    NSString *partialData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];   
    [jsonData appendString:partialData];   
    [partialData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray *coordinates = [[NSMutableArray alloc]init];
	
    NSDictionary *filesJSON = [jsonData JSONValue];
	NSArray *steps = [[[[[filesJSON objectForKey:@"routes"] valueForKey:@"legs"] valueForKey:@"steps"]objectAtIndex: 0]objectAtIndex: 0];
    
	CLLocationDegrees start_lat = (CLLocationDegrees) [[[[steps objectAtIndex: 0] objectForKey:@"start_location"]objectForKey:@"lat"] doubleValue] ;
	CLLocationDegrees start_long = (CLLocationDegrees) [[[[steps objectAtIndex: 0] objectForKey:@"start_location"]objectForKey:@"lng"] doubleValue];
	[coordinates addObject:[[[CLLocation alloc] initWithLatitude: start_lat longitude: start_long]autorelease]];
	
    for (NSDictionary *location in steps ) {
		
		CLLocationDegrees lat = (CLLocationDegrees) [[[location objectForKey:@"end_location"]objectForKey:@"lat"]doubleValue];
		CLLocationDegrees lng = (CLLocationDegrees) [[[location objectForKey:@"end_location"]objectForKey:@"lng"]doubleValue];
		
		[coordinates addObject:[[[CLLocation alloc] initWithLatitude:lat longitude:lng]autorelease]];
	}
	
	_mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	[_mapView setDelegate:self];
	[self.view addSubview:_mapView];
	
	NVPolylineAnnotation *annotation = [[[NVPolylineAnnotation alloc] initWithPoints:coordinates mapView:_mapView] autorelease];
	[_mapView addAnnotation:annotation];
	
	CLLocation *centerLocation = [coordinates objectAtIndex:[coordinates count]/2];
	
	// use some magic numbers to create a map region
	MKCoordinateRegion region;
	region.span.longitudeDelta = 0.008727;
	region.span.latitudeDelta = 0.008574;
	region.center.latitude = centerLocation.coordinate.latitude; 
	region.center.longitude = centerLocation.coordinate.longitude;
	[_mapView setRegion:region];
    
    [coordinates release];
	
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = start_lat;
    theCoordinate.longitude = start_long;
	
	DDAnnotation *ddAnnotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
	ddAnnotation.title = @"Origin";
	ddAnnotation.subtitle = [NSString	stringWithFormat:@"%f %f", ddAnnotation.coordinate.latitude, ddAnnotation.coordinate.longitude];
	[_mapView addAnnotation:ddAnnotation];	
    
    coordinatesArray = [coordinatesString componentsSeparatedByString:@","];
    
    CLLocationCoordinate2D destCoordinate;
	destCoordinate.latitude = (CLLocationDegrees) [[coordinatesArray objectAtIndex:0] doubleValue];
    destCoordinate.longitude = (CLLocationDegrees) [[coordinatesArray objectAtIndex:1] doubleValue];
    
    DDAnnotation *destAnnotation = [[[DDAnnotation alloc] initWithCoordinate:destCoordinate addressDictionary:nil] autorelease];
	destAnnotation.title = @"Destination";
    
	destAnnotation.subtitle = [NSString	stringWithFormat:@"%f %f", ddAnnotation.coordinate.latitude, ddAnnotation.coordinate.longitude];
	[_mapView addAnnotation:destAnnotation];	
	
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification
// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification 
{
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}


#pragma mark -
#pragma mark MKMapViewDelegate methods
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
	
   	DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;//newState;
	annotation.subtitle = [NSString	stringWithFormat:@"%f, %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    
	
	if (count == 3) 
    {
        count = 0;
		if ([annotation.title isEqualToString:@"Origin"]) {
            
            NSString *c = [NSString stringWithFormat:@"%f,%f",annotation.coordinate.latitude, annotation.coordinate.longitude];
            currentCoordinatesString = [(NSString*)c mutableCopy];
        }else {
            NSString *c = [NSString stringWithFormat:@"%f,%f",annotation.coordinate.latitude, annotation.coordinate.longitude];
            coordinatesString = [(NSString*)c mutableCopy];
            
        }
		
        NSMutableArray *toRemove = [[NSMutableArray alloc]init];
		for (id annotation in _mapView.annotations)
			if (annotation != _mapView.userLocation)
				[toRemove addObject:annotation];
		[_mapView removeAnnotations:toRemove];
		[toRemove release];
        [jsonData release];
		jsonData = [[NSMutableString alloc] initWithString:@""]; 
		
		[self startRoute];
	} else {
		count ++;
	}
    
}

#pragma mark -
#pragma mark MKAnnotationView methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
	NSString *c = [NSString stringWithFormat:@"%f,%f",annotation.coordinate.latitude, annotation.coordinate.longitude];

	if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	
	if ([annotation isKindOfClass:[NVPolylineAnnotation class]]) {
		return [[[NVPolylineAnnotationView alloc] initWithAnnotation:annotation mapView:_mapView] autorelease];
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [_mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:_mapView];
        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}		
	
	return draggablePinView;
}

@end
