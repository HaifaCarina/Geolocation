//
//  AllViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GlobalData.h"
#import "Records.h"
#import "JSON.h"
#import "DetailViewController.h"
#import "FilterDistanceViewController.h"
#import "NewRecordViewController.h"
@interface AllViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate> {
    NSMutableString *jsonData;
    NSMutableArray *records;
	UITableView *mainTableView;
	CLLocationManager *locationManager;
    BOOL calledOnce;
	NSMutableString *currentCoordinatesString;
    NSMutableString *currentLocation;
	UIActivityIndicatorView *myIndicator;
    UIFont *cellFont;
}

@end
