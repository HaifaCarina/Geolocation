//
//  SightseeingViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "SightseeingViewController.h"


@implementation SightseeingViewController
#pragma mark -
#pragma mark Life Cycle methods
- (void) loadView {
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
    
    records = [[NSMutableArray alloc]init];
    
    for (Records *r in [GlobalData sharedGlobalData].records) {
        if ([[r category] compare:@"Travel"] == NSOrderedSame) {
            [records addObject:r];
        }
    }
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),375) style:UITableViewStyleGrouped];
	[mainTableView setDataSource:self];
	[mainTableView setDelegate:self];
	[self.view addSubview:mainTableView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewwillappear sight");
    if ([[GlobalData sharedGlobalData].distance compare: [NSNumber numberWithDouble:0.00]] == NSOrderedDescending) {
        [records setArray:[GlobalData sharedGlobalData].records];
        
        NSMutableArray *discardedObjects = [[NSMutableArray alloc]init];
        NSMutableArray *keepObjects = [[NSMutableArray alloc]init];
        
        for (id i in records) {
            if ([[i category] compare:@"Travel"] == NSOrderedSame) {
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
			NewRecordViewController *aController = [[NewRecordViewController alloc] init];
            [self.navigationController pushViewController:aController animated:YES];
            [aController release];
            
            
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
            NSString *cellText = [[records	objectAtIndex:indexPath.row] name] ;
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:[GlobalData sharedGlobalData].cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
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
        cell.textLabel.font = [GlobalData sharedGlobalData].cellFont;
        cell.detailTextLabel.numberOfLines = 3;
    }
    
    switch (indexPath.section) {
        case 0: 
			cell.textLabel.text = @"Your location is";
            cell.detailTextLabel.text = [GlobalData sharedGlobalData].currentLocation;//currentCoordinatesString; //@"135 B Yakal, Makati City, Philippines";			
			break;
            
        case 1:
			
            cell.textLabel.text = [[records	objectAtIndex:indexPath.row] name];
            
			NSString *text = [NSString stringWithFormat: @"Star Rating: %@",[[records	objectAtIndex:indexPath.row] starRating]];
			text = [text stringByAppendingFormat:@"\nDistance: %@" ,[[records objectAtIndex:indexPath.row] distance]];
			text = [text stringByAppendingFormat:@"\nRemarks: %@" ,[[records objectAtIndex:indexPath.row] remark]];
			cell.detailTextLabel.text = text;
            break;
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
		DetailViewController *aController = [[DetailViewController alloc] initWithRecord:[records objectAtIndex:indexPath.row]];
		[self.navigationController pushViewController:aController animated:YES];
		[aController release];
	}
	
}
@end
