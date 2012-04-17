//
//  DetailViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController
@synthesize record, details;

#pragma mark -
#pragma mark Life Cycle methods
- (id) initWithRecord:(id)inputRecord {
    if (self == [super init]) {
        record = inputRecord;
    }
    return(self);
}

- (void) loadView {
    [super loadView];
    
    self.title = @"Information";
	details = [[NSMutableArray alloc]init];
    coordinates = record.coordinate;
    
    [details addObject:record.name];
    [details addObject:record.location];
    [details addObject:record.category];
    [details addObject:record.coordinate];
    [details addObject:record.remark];
    
	int y = 10;
	for (NSString* detail in details) {
		
		UILabel *label = [[UILabel alloc]initWithFrame: CGRectMake(10, y, 320, 20)];
		label.text = [NSString stringWithFormat: @"%@", detail];
		label.backgroundColor = [UIColor clearColor];
		
		[self.view addSubview:label];
        [label release];
        
		y+=20;
	}
    
    UIButton *route = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[route addTarget:self 
              action:@selector(routeMethod:)
    forControlEvents:UIControlEventTouchDown];
	[route setTitle:@"Route" forState:UIControlStateNormal];
	route.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
	[self.view addSubview:route];
    
}

#pragma mark -
#pragma mark Custom methods
- (void) routeMethod: (id) button {
	
    RouteViewController *aController = [[RouteViewController alloc] initWithCoordinates:coordinates];
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
    
}
@end
