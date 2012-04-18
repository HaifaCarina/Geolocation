//
//  DetailViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Records.h"
#import "RouteViewController.h"
#import "NewRecordViewController.h"
@interface DetailViewController : UIViewController {
    NSMutableArray *details;
	NSString *coordinates;
    Records *record;
    
}
@property (nonatomic, retain) Records *record;
@property (nonatomic, retain) NSMutableArray *details;

- (id) initWithRecord: (Records *) inputRecord;

@end
