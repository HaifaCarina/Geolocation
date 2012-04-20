//
//  EditCoordinateViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/20/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "EditCoordinateViewController.h"


@implementation EditCoordinateViewController
@synthesize mapView;

#pragma mark -
#pragma mark Life Cycle Methods
- (void) loadView {
	[super loadView];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Done"                                            
                                   style:UIBarButtonItemStyleDone
                                   target:self 
                                   action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
	
	count = 0;
	
    mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	[mapView setDelegate:self];
    [self.view addSubview:mapView];
    
    coordinatesArray = [[GlobalData sharedGlobalData].newCoordinates componentsSeparatedByString:@","];
    
    CLLocationCoordinate2D destCoordinate;
	destCoordinate.latitude = (CLLocationDegrees) [[coordinatesArray objectAtIndex:0] doubleValue];
    destCoordinate.longitude = (CLLocationDegrees) [[coordinatesArray objectAtIndex:1] doubleValue];
    
    DDAnnotation *destAnnotation = [[[DDAnnotation alloc] initWithCoordinate:destCoordinate addressDictionary:nil] autorelease];
	destAnnotation.title = @"Destination";
    
	destAnnotation.subtitle = [NSString	stringWithFormat:@"%f %f", destAnnotation.coordinate.latitude, destAnnotation.coordinate.longitude];
	[mapView addAnnotation:destAnnotation];
    
    // use some magic numbers to create a map region
    MKCoordinateRegion region;
    region.span.longitudeDelta = 0.008727;
    region.span.latitudeDelta = 0.008574;
    region.center.latitude = destAnnotation.coordinate.latitude; 
    region.center.longitude = destAnnotation.coordinate.longitude;
    [mapView setRegion:region];
	
}

#pragma mark -
#pragma mark Custom Methods
- (void) doneAction 
{
	[GlobalData sharedGlobalData].newCoordinates = currentCoordinatesString;
	
	[[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count]-2] viewWillAppear: YES];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification
// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
		
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}	
	return draggablePinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
	
	DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;//newState;
	annotation.subtitle = [NSString	stringWithFormat:@"%f, %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	if (count == 3) {
		count = 0;
		NSString *c = [NSString stringWithFormat:@"%f,%f",annotation.coordinate.latitude, annotation.coordinate.longitude];
		currentCoordinatesString = [(NSString*)c mutableCopy];
	}else {
		count ++;
	}
}
@end
