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
    NSLog(@"detail record id %@", [record recordId]);
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
									  initWithTitle:@"Edit"                                            
									  style:UIBarButtonItemStyleBordered 
									  target:self 
									  action:@selector(editAction)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    self.title = @"Information";
	details = [[NSMutableArray alloc]init];
    //coordinates = record.coordinate;
    
    NSString *coords = [NSString stringWithFormat:@"%@,%@",record.latitude,record.longitude];
    coordinates = coords;
    
    [details addObject:record.name];
    [details addObject:record.address1];
    [details addObject:record.category];
    //[details addObject:record.coordinate];
    [details addObject:record.latitude];
    [details addObject:record.longitude];
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
- (void) editAction {
    NSLog(@"edit");
    NewRecordViewController *aController = [[NewRecordViewController alloc]initWithRecord:record];
    [self.navigationController pushViewController:aController animated:YES];
}
- (void) routeMethod: (id) button {
	NSLog(@"%@,%@",record.latitude,record.longitude);
    
    //RouteViewController *aController = [[RouteViewController alloc] initWithCoordinates:coordinates];
    NSString *coords = [NSString stringWithFormat:@"%@,%@",record.latitude,record.longitude];
	RouteViewController *aController = [[RouteViewController alloc] initWithCoordinates:coords];
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
    
}

@end
