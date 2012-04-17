//
//  AllViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "AllViewController.h"


@implementation AllViewController

#pragma mark -
#pragma mark Life Cycle methods
- (void) loadView 
{
    [super loadView];
    
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] 
									  initWithTitle:@"Options"                                            
									  style:UIBarButtonItemStyleBordered 
									  target:self 
									  action:@selector(optionsAction)];
    
    self.navigationItem.leftBarButtonItem = optionsButton;
    [optionsButton release];
    
    // Add filter options tab
    NSArray *itemArray = [NSArray arrayWithObjects: @"Distance", @"Star Rating", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 00, 150, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
   
    
    jsonData = [[NSMutableString alloc] initWithString:@""]; 
    currentLocation = [[NSMutableString alloc] initWithString:@""];
	records = [[NSMutableArray alloc]init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    calledOnce = NO;
	currentCoordinatesString = [[NSMutableString alloc] initWithString:@""];
    cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
}
- (void) viewWillAppear:(BOOL)animated {
    
    if ([[GlobalData sharedGlobalData].distance compare: [NSNumber numberWithDouble:0.00]] == NSOrderedDescending) {
        [records setArray:[GlobalData sharedGlobalData].records];
        
        NSMutableArray *discardedObjects = [[NSMutableArray alloc]init];
        NSMutableArray *keepObjects = [[NSMutableArray alloc]init];
        
        for (id i in records) {
            NSString *distanceString = [[i getDistance]stringByReplacingOccurrencesOfString:@" mi" withString:@""];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setRoundingIncrement:[NSNumber numberWithDouble:0.00000]];
            NSNumber * d1 = [f numberFromString:distanceString];
            [f release];
            if ([d1 compare:[GlobalData sharedGlobalData].distance] == NSOrderedDescending) { //d1  > d2
                [discardedObjects addObject:i];
            } else {
                [keepObjects addObject:i];
            }
        }
        
        [records setArray:keepObjects];
        [keepObjects release];
        [discardedObjects release];
        
    }
	[mainTableView reloadData];
}

#pragma mark -
#pragma mark Custom methods
- (void) optionsAction 
{
    NSLog(@"options");
    UIActionSheet *optionsAlert = [[UIActionSheet alloc] initWithTitle:@"Select option:"
                                                              delegate:self cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:	@"Filter Distance",
                                   @"Create New Entry",
                                   nil,
                                   nil];
    optionsAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
	[optionsAlert showInView:self.parentViewController.tabBarController.view];
    [optionsAlert release];
}

- (void) segmentedControlAction: (UISegmentedControl *)segmentedControl {
    
    NSArray *sortedArray;
    
    if ([segmentedControl selectedSegmentIndex] == 0) 
    {
        NSLog(@"customSwitch is DIST");
		
        sortedArray = [records sortedArrayUsingComparator:^(id a, id b) 
        {
            NSString *first = [(Records*)a distance];
            NSString *second = [(Records*)b distance];
            return [first compare:second];
        }];
        
        records = [(NSArray*)sortedArray mutableCopy];
        [mainTableView reloadData];        
	} else 
    {
		NSLog(@"customSwitch is STAR");
		
        sortedArray = [records sortedArrayUsingComparator:^(id a, id b) 
        {
            NSString *first = [(Records*)a starRating];
            NSString *second = [(Records*)b starRating];
            return [second compare:first];
        }];
        
        records = [(NSArray*)sortedArray mutableCopy];
        [mainTableView reloadData];
	}
}
- (void) startConnection 
{
	// Display loading icon
	myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	myIndicator.frame = CGRectMake(0,0, 40.0, 40.0);
	myIndicator.center = CGPointMake(160, 190);
	[self.view addSubview:myIndicator];
	[myIndicator startAnimating];
	
	[jsonData release];
	jsonData = [[NSMutableString alloc] initWithString:@""]; 
	
	[records release];
	records = [[NSMutableArray alloc]init];
	
    // Star querying records
	NSString *urlString = [NSString stringWithFormat: @"http://mobile.nmgdev.com/juno/data.php?sortByDistance=true&origin=%@",currentCoordinatesString];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[request release]; 
	[connection release];
}

#pragma mark -
#pragma mark CLLocationManager methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // These actions must be run ONCE
    if (!calledOnce) 
    {
        NSString *s =[NSString stringWithFormat:@"%g,%g",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
        [currentCoordinatesString appendString: s];
        NSLog(@"%@", s);
        NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=14.558808,121.022911&sensor=true", currentCoordinatesString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSDictionary *contentJSON = [content JSONValue];
        
        NSArray *steps = [[[contentJSON objectForKey:@"routes"] valueForKey:@"legs"] valueForKey:@"start_address"];
        [currentLocation appendString:[[steps objectAtIndex:0]objectAtIndex:0]];
        
        [GlobalData sharedGlobalData].currentLocation = (NSString *)currentLocation;
        [self startConnection];
        
        calledOnce = YES;
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
	[myIndicator stopAnimating]; 
    
    NSDictionary *filesJSON = [jsonData JSONValue];
	NSArray *files = [filesJSON objectForKey:@"files"];
    
	for (NSDictionary *file in files)
	{       
		NSString *name = [file objectForKey:@"name"];
		NSString *location = [file objectForKey:@"address_1"];
		NSString *coordinate = [file objectForKey:@"coordinates"];
		NSString *category = [file objectForKey:@"category"];
		NSString *content = [file objectForKey:@"content"];
		NSString *remark = [file objectForKey:@"remarks"];
		NSString *source = [file objectForKey:@"source"];
		NSString *starRating = [file objectForKey:@"star_rating"];
        NSString *distance = [file objectForKey:@"distance"];
        
         
        // Display non-null distance values
        if (![distance isKindOfClass:[NSNull class]]) {
            Records *record = [[Records alloc]init];
            record.name = name;
            record.location = location;
            record.coordinate = coordinate;
            record.category = category;
            record.content = content;
            record.remark = remark;
            record.source = source;
            record.starRating = starRating;
            record.distance = distance;
            
            [records addObject: record];
            [record release];
        }
		
		
		
	}
	
    [[GlobalData sharedGlobalData].records setArray:records];
    
	mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),375) style:UITableViewStyleGrouped];
	[mainTableView setDataSource:self];
	[mainTableView setDelegate:self];
	[self.view addSubview:mainTableView];
	
}
#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Change the navigation bar style, also make the status bar match with it
	switch (buttonIndex)
	{
		case 0:
		{
			FilterDistanceViewController *aController = [[FilterDistanceViewController alloc]init];
            [self.navigationController pushViewController:aController animated:YES];
            [aController release];
			break;
		}
		case 1:
		{
			/*NewRecordViewController *aController = [[NewRecordViewController alloc] init];
            [self.navigationController pushViewController:aController animated:YES];
            [aController release];
            */
            
            break;
		}
            
	}
}
#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if (section == 0) {
		return 1;
	} else if (section == 1) {
		return [records count];
	}
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: 
        {
            return 50;
			break;
        }	
		case 1: 
        {
            NSString *cellText = [[records	objectAtIndex:indexPath.row] getName] ;
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            return labelSize.height + 80;
            break;
        }
            
	}
    return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //static NSString *CellIdentifier = @"Cell"; 
    
    static NSString *CellIdentifier;
	
	switch (indexPath.section) {
        case 0: 
			CellIdentifier = @"Location"; 
			break;
		case 1:
			CellIdentifier = @"Records"; 
			break;
	}
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = cellFont;
        cell.detailTextLabel.numberOfLines = 3;
    }

    switch (indexPath.section) {
        case 0: 
			cell.textLabel.text = @"Your location is";
            cell.detailTextLabel.text = currentLocation;//currentCoordinatesString; //@"135 B Yakal, Makati City, Philippines";			
			break;

        case 1:
			
            cell.textLabel.text = [[records	objectAtIndex:indexPath.row] getName];
            
			NSString *text = [NSString stringWithFormat: @"Star Rating: %@",[[records	objectAtIndex:indexPath.row] getStarRating]];
			text = [text stringByAppendingFormat:@"\nDistance: %@" ,[[records objectAtIndex:indexPath.row] getDistance]];
			text = [text stringByAppendingFormat:@"\nRemarks: %@" ,[[records objectAtIndex:indexPath.row] getRemark]];
			cell.detailTextLabel.text = text;
            break;
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
		
		
		NSMutableArray *inputDetails = [[NSMutableArray alloc]init];
		NSLog(@"%@", [[records objectAtIndex:indexPath.row] name]);
		[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getName]];
		[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getLocation]];
		[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getCoordinate]];
		[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getCategory]];
		//[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getContent]];
		[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getRemark]];
		//[inputDetails addObject:[[records	objectAtIndex:indexPath.row] getSource]];
		
		DetailViewController *aController = [[DetailViewController alloc] initWithRecord:[records objectAtIndex:indexPath.row]];
		
		[self.navigationController pushViewController:aController animated:YES];
		[aController release];
        [inputDetails release];
	}
	
}

@end
