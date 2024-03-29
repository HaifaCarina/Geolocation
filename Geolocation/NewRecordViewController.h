//
//  NewRecordViewController.h
//  Geolocation
//
//  Created by Haifa Carina Baluyos on 4/18/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalData.h"
#import "NSString+Encode.h"
#import "NewCoordinateViewController.h"
#import "Records.h"
#import "EditCoordinateViewController.h"
@interface NewRecordViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>{
    UITextField *nameField;
	UITextField *categoryField;
	UITextField *starField;
	UITextField *remarkField;
    UITextField *address1Field;
    UITextField *address2Field;
	UITextField *cityField;
	UITextField *stateField;
	UITextField *zipField;
    UITextField *coordinatesField;
    
    NSArray *categories;
    
    int inputTypeTag;
    NSString *recordId;
}
- (id) initWithRecord:(Records *)inputRecord;

@end
