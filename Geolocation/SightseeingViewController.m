//
//  SightseeingViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "SightseeingViewController.h"


@implementation SightseeingViewController

- (void) loadView {
    [super loadView];
    
    UITableView *mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds),375) style:UITableViewStylePlain];
    [mainTableView setDataSource:self];
	[mainTableView setDelegate:self];
    [self.view addSubview:mainTableView];
}
#pragma mark -
#pragma mark Table view methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return 10;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell"; 
    
	// if a cell can be reused, it returns a UITableViewCell with the associated identifier or nil if no such cell exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// if no cell to reuse, then create a new one
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	// Set up the cell...	
	cell.textLabel.text = [NSString stringWithFormat:@"sightseeing item %d",indexPath.row];
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableview didSelectRowAtIndexPath START");
	NSLog(@"tableview didSelectRowAtIndexPath END");
	
}

@end
