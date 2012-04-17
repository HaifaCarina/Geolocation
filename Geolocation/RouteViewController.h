//
//  RouteViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NVPolylineAnnotationView.h"
#import "JSON.h"

@interface RouteViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *_mapView;
	NSString *coordinatesString;
	NSArray *coordinatesArray;
	NSMutableString *jsonData;
    NSMutableString *currentCoordinatesString;
    CLLocationManager *locationManager;
    BOOL calledOnce;
	NSMutableString *toCompareCoordinates;
	int count;
}

@property (nonatomic, retain) NSMutableString *jsonData;

- (id) initWithCoordinates: (NSString *) inputCoordinates;

@end
