//
//  NewCoordinateViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/18/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "NVPolylineAnnotationView.h"
#import "JSON.h"
#import "GlobalData.h"

@interface NewCoordinateViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    MKMapView *mapView;
	BOOL calledOnce;
	CLLocationManager *locationManager;
	int count;
	NSMutableString *currentCoordinatesString;
}

@property (nonatomic, retain) MKMapView *mapView;

@end
