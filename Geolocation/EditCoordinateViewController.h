//
//  EditCoordinateViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/20/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "NVPolylineAnnotationView.h"
#import "JSON.h"
#import "GlobalData.h"

@interface EditCoordinateViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    MKMapView *mapView;
	
	int count;
	NSMutableString *currentCoordinatesString;
    NSArray *coordinatesArray;
}

@property (nonatomic, retain) MKMapView *mapView;

@end
