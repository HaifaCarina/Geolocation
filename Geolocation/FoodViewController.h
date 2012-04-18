//
//  FoodViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalData.h"
#import "Records.h"
#import "DetailViewController.h"
#import "NewRecordViewController.h"
#import "FilterDistanceViewController.h"
@interface FoodViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UINavigationControllerDelegate>{
    UITableView *mainTableView;
    NSMutableArray *records;
}

@end
