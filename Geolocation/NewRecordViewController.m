//
//  NewRecordViewController.m
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/18/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "NewRecordViewController.h"


@implementation NewRecordViewController

- (void) getCoordinatesMethod: (id) button {
	
	NSLog(@"button is pressed");
	NewCoordinateViewController *aController = [[NewCoordinateViewController alloc] init];
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
}
#pragma mark -
#pragma mark Custom methods
- (void) doneAction {
	NSLog(@"NEW RECORD DONE!");
	
	NSLog(@"Name: %@", nameField.text);
	NSLog(@"Category: %@", categoryField.text);
	NSLog(@"Location: %@", address1Field.text);
	NSLog(@"Remark: %@", remarkField.text);
	NSLog(@"StarRating: %@", starField.text);
    
    if (([cityField.text length] == 0) && 
        ([stateField.text length] == 0) &&
        ([zipField.text length] == 0) ){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Input value for either city, state or zip is required. " delegate:self 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else if (([address1Field.text length] == 0) || 
               ([nameField.text length] == 0) ||
               ([categoryField.text length] == 0 )){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Please complete all required fields" delegate:self 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        NSString *urlAddress = [NSString stringWithFormat:@"http://mobile.nmgdev.com/juno/add.php?name=%@&category=%@&star_rating=%@&remarks=%@&address_1=%@&address_2=%@&city=%@&state=%@&zip=%@&coordinates=%@&user_id=%@",
                                [nameField.text encodeString:NSUTF8StringEncoding],
                                [categoryField.text encodeString:NSUTF8StringEncoding],
                                [starField.text encodeString:NSUTF8StringEncoding],
                                [remarkField.text encodeString:NSUTF8StringEncoding],
                                [address1Field.text encodeString:NSUTF8StringEncoding],
                                [address2Field.text encodeString:NSUTF8StringEncoding],
                                [cityField.text encodeString:NSUTF8StringEncoding],
                                [stateField.text encodeString:NSUTF8StringEncoding],
                                [zipField.text encodeString:NSUTF8StringEncoding],
                                [GlobalData sharedGlobalData].newCoordinates,
                                [NSString stringWithFormat:@"1"] ]; // THIS SHOULD BE DYNAMIC
        
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [request release]; 
        [connection release];
    }
	
    
   
}
#pragma mark -
#pragma mark LifeCycle methods
- (void) viewWillAppear:(BOOL)animated {
	[coordinatesField setText:[GlobalData sharedGlobalData].newCoordinates];
}

- (void) loadView {
    [super loadView];
	
	UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[scrollview setContentSize: CGSizeMake(self.view.frame.size.width, 700)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Done"                                            
                                   style:UIBarButtonItemStyleDone//UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    categories = [[NSArray alloc]initWithObjects: @"Food",@"Shopping",@"Hotel", nil];
    
	UILabel *nameLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 10, 100, 30)];
	nameLabel.text = @"Name";
	[scrollview addSubview: nameLabel];
    [nameLabel release];
	
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 200, 30 )];
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.textColor = [UIColor blackColor];
    nameField.font = [UIFont systemFontOfSize:17.0];
    nameField.placeholder = @"(Required)";  //place holder
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;  
    nameField.backgroundColor = [UIColor clearColor];
    nameField.keyboardType = UIKeyboardTypeDefault;  
    nameField.returnKeyType = UIReturnKeyDone;  
    nameField.delegate = self;
    [scrollview addSubview:nameField];
	
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 50, 100, 30)];
	categoryLabel.text = @"Category";
	[scrollview addSubview:categoryLabel];
	[categoryLabel release];
	
	categoryField = [[UITextField alloc] initWithFrame:CGRectMake(110, 50, 200, 30)];
    categoryField.borderStyle = UITextBorderStyleRoundedRect;
    categoryField.textColor = [UIColor blackColor];
    categoryField.font = [UIFont systemFontOfSize:17.0];
    categoryField.placeholder = @"(Required)";  //place holder
    categoryField.backgroundColor = [UIColor whiteColor];
    categoryField.autocorrectionType = UITextAutocorrectionTypeNo;  
    categoryField.backgroundColor = [UIColor clearColor];
    categoryField.keyboardType = UIKeyboardTypeDefault; 
    categoryField.returnKeyType = UIReturnKeyDone; 
    categoryField.delegate = self;
    [scrollview addSubview:categoryField];
	
    UILabel *starLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 90, 100, 30)];
	starLabel.text = @"Star Rating";
	[scrollview addSubview: starLabel];
	[starLabel release];
	
    starField = [[UITextField alloc] initWithFrame:CGRectMake(110, 90, 200, 30)];
    starField.borderStyle = UITextBorderStyleRoundedRect;
    starField.textColor = [UIColor blackColor];
    starField.font = [UIFont systemFontOfSize:17.0];
    starField.placeholder = @"(1-5)";  //place holder
    starField.backgroundColor = [UIColor whiteColor];
    starField.autocorrectionType = UITextAutocorrectionTypeNo;  
    starField.backgroundColor = [UIColor clearColor];
    starField.keyboardType = UIKeyboardTypeDecimalPad; 
    starField.returnKeyType = UIReturnKeyDone; 
    starField.delegate = self;
    [scrollview addSubview: starField];
    
	UILabel *remarkLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 130, 100, 30)];
	remarkLabel.text = @"Remarks";
	[scrollview addSubview: remarkLabel];
	[remarkLabel release];
	
	remarkField = [[UITextField alloc] initWithFrame:CGRectMake(110, 130, 200, 30 )];
    remarkField.borderStyle = UITextBorderStyleRoundedRect;
    remarkField.textColor = [UIColor blackColor];
    remarkField.font = [UIFont systemFontOfSize:17.0];
    remarkField.placeholder = @"Remarks";  //place holder
    remarkField.backgroundColor = [UIColor whiteColor];
    remarkField.autocorrectionType = UITextAutocorrectionTypeNo;  
    remarkField.backgroundColor = [UIColor clearColor];
    remarkField.keyboardType = UIKeyboardTypeDefault;  
    remarkField.returnKeyType = UIReturnKeyDone; 
    remarkField.delegate = self;
    [scrollview addSubview:remarkField];
    
    UILabel *address1Label = [[UILabel alloc]initWithFrame: CGRectMake(10, 170, 100, 30)];
	address1Label.text = @"Address 1";
	[scrollview addSubview:address1Label];
	[address1Label release];
	
	address1Field = [[UITextField alloc] initWithFrame:CGRectMake(110, 170, 200, 30 )];
    address1Field.borderStyle = UITextBorderStyleRoundedRect;
    address1Field.textColor = [UIColor blackColor];
    address1Field.font = [UIFont systemFontOfSize:17.0];
    address1Field.placeholder = @"(Required)";  //place holder
    address1Field.backgroundColor = [UIColor whiteColor];
    address1Field.autocorrectionType = UITextAutocorrectionTypeNo;  
    address1Field.backgroundColor = [UIColor clearColor];
    address1Field.keyboardType = UIKeyboardTypeDefault;  
    address1Field.returnKeyType = UIReturnKeyDone; 
    address1Field.delegate = self;
    [self.view addSubview:address1Field];
	[scrollview addSubview:address1Field];
	
	UILabel *address2Label = [[UILabel alloc]initWithFrame: CGRectMake(10, 210, 100, 30)];
	address2Label.text = @"Address 2";
	[scrollview addSubview:address2Label];
	[address2Label release];
	
	address2Field = [[UITextField alloc] initWithFrame:CGRectMake(110, 210, 200, 30 )];
    address2Field.borderStyle = UITextBorderStyleRoundedRect;
    address2Field.textColor = [UIColor blackColor];
    address2Field.font = [UIFont systemFontOfSize:17.0];
    address2Field.backgroundColor = [UIColor whiteColor];
    address2Field.autocorrectionType = UITextAutocorrectionTypeNo;  
    address2Field.backgroundColor = [UIColor clearColor];
    address2Field.keyboardType = UIKeyboardTypeDefault;  
    address2Field.returnKeyType = UIReturnKeyDone; 
    address2Field.delegate = self;
    [scrollview addSubview:address2Field];
	
	UILabel *cityLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 250, 100, 30)];
	cityLabel.text = @"City";
	[scrollview addSubview:cityLabel];
	[cityLabel release];
	
	cityField = [[UITextField alloc] initWithFrame:CGRectMake(110, 250, 200, 30 )];
    cityField.borderStyle = UITextBorderStyleRoundedRect;
    cityField.textColor = [UIColor blackColor];
    cityField.font = [UIFont systemFontOfSize:17.0];
    cityField.placeholder = @"City";  //place holder
    cityField.backgroundColor = [UIColor whiteColor];
    cityField.autocorrectionType = UITextAutocorrectionTypeNo;  
    cityField.backgroundColor = [UIColor clearColor];
    cityField.keyboardType = UIKeyboardTypeDefault;  
    cityField.returnKeyType = UIReturnKeyDone; 
    cityField.delegate = self;
    [scrollview addSubview:cityField];
    
	UILabel *stateLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 290, 100, 30)];
	stateLabel.text = @"State";
	//[self.view addSubview:stateLabel];
	[scrollview addSubview: stateLabel];
	[stateLabel release];
	
	stateField = [[UITextField alloc] initWithFrame:CGRectMake(110, 290, 200, 30 )];
    stateField.borderStyle = UITextBorderStyleRoundedRect;
    stateField.textColor = [UIColor blackColor];
    stateField.font = [UIFont systemFontOfSize:17.0];
    stateField.placeholder = @"State";  //place holder
    stateField.backgroundColor = [UIColor whiteColor];
    stateField.autocorrectionType = UITextAutocorrectionTypeNo;  
    stateField.backgroundColor = [UIColor clearColor];
    stateField.keyboardType = UIKeyboardTypeDefault;  
    stateField.returnKeyType = UIReturnKeyDone; 
    stateField.delegate = self;
    [scrollview addSubview:stateField];
    
	
    UILabel *zipLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 330, 100, 30)];
	zipLabel.text = @"Zip";
	[scrollview addSubview:zipLabel];
	[zipLabel release];
	
    zipField = [[UITextField alloc] initWithFrame:CGRectMake(110, 330, 200, 30)];
    zipField.borderStyle = UITextBorderStyleRoundedRect;
    zipField.textColor = [UIColor blackColor];
    zipField.font = [UIFont systemFontOfSize:17.0];
    zipField.placeholder = @"Zip";  //place holder
    zipField.backgroundColor = [UIColor whiteColor];
    zipField.autocorrectionType = UITextAutocorrectionTypeNo;  
    zipField.backgroundColor = [UIColor clearColor];
    zipField.keyboardType = UIKeyboardTypeDecimalPad; 
    zipField.returnKeyType = UIReturnKeyDone; 
    zipField.delegate = self;
    [scrollview addSubview:zipField];
    
	UILabel *coordinate = [[UILabel alloc]initWithFrame: CGRectMake(10, 370, 100, 30)];
	coordinate.text = @"Coordinates";
	[scrollview addSubview:coordinate];
	[coordinate release];
	
	coordinatesField = [[UILabel alloc]initWithFrame: CGRectMake(110, 370, 200, 30)];
	coordinatesField.text = [GlobalData sharedGlobalData].newCoordinates;
	[scrollview addSubview:coordinatesField];
	
    UIButton *route = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[route addTarget:self 
			  action:@selector(getCoordinatesMethod:)
	forControlEvents:UIControlEventTouchDown];
	[route setTitle:@"Get Coordinates" forState:UIControlStateNormal];
	route.frame = CGRectMake(80.0, 410.0, 160.0, 40.0);
    [scrollview addSubview:route];
	
	[self.view	addSubview:scrollview];
    [scrollview release];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
-(UIView*)viewForZoomingInScrollView:(UIScrollView*) scroll  {
    return scroll;
}


#pragma mark -
#pragma mark NSURLConnection methods
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[[self.navigationController topViewController] viewWillAppear: YES];

	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"New Record Added" delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}	

#pragma mark -
#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {// When the return button is pressed on a textField.
	[textField resignFirstResponder];
    return YES; // Set the BOOL to YES.
}

#pragma mark -
#pragma mark UIPickerView methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [categories count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [categories objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

@end
