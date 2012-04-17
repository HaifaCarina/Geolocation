//
//  GlobalData.h
//  Juno
//
//  Created by Haifa Carina Baluyos on 1/27/12.
//  Copyright 2012 Haifa Carina Baluyos, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject {
    NSString *message; // global variable
    NSNumber *distance;
	NSMutableString *jsonData;
	NSMutableString *jsonDataDistance;
	NSMutableArray *records;
	NSMutableString *newCoordinates;
    NSString *currentLocation;
	
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSMutableString *jsonData;
@property (nonatomic, retain) NSMutableString *jsonDataDistance;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) NSMutableString *newCoordinates;
@property (nonatomic, retain) NSString *currentLocation;
+ (GlobalData*)sharedGlobalData;

// global function
- (void) myFunc;

@end
