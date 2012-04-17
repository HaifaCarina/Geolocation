//
//  FilterDistanceViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/17/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "FilterDistanceViewController.h"


@implementation FilterDistanceViewController
@synthesize distanceField;

- (void) loadView {
	[super loadView];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Done"                                            
                                   style:UIBarButtonItemStyleDone
                                   target:self 
                                   action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
	
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 20)];
	
	distanceLabel.text = @"Distance";
	[self.view addSubview:distanceLabel];
	[distanceLabel release];
    
	distanceField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 280, 31)];
    distanceField.borderStyle = UITextBorderStyleRoundedRect;
    distanceField.textColor = [UIColor blackColor];
    distanceField.font = [UIFont systemFontOfSize:17.0];
    distanceField.placeholder = @"Enter in miles";  //place holder
    distanceField.backgroundColor = [UIColor whiteColor];
    distanceField.autocorrectionType = UITextAutocorrectionTypeNo;  
    distanceField.backgroundColor = [UIColor clearColor];
    distanceField.keyboardType = UIKeyboardTypeDecimalPad;  
    distanceField.returnKeyType = UIReturnKeyDone;  
    
    distanceField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:distanceField];
}
#pragma mark -
#pragma mark Custom methods
- (void) doneAction {
	
    NSString *distanceString = distanceField.text;
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setRoundingIncrement:[NSNumber numberWithDouble:0.00001]];
    NSNumber * distance = [f numberFromString:distanceString];
	[f release];
    
	[GlobalData sharedGlobalData].distance = distance;
	
    [[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count]-2] viewWillAppear: YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
