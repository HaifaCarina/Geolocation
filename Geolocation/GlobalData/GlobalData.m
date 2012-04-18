//
//  GlobalData.m
//  Juno
//
//  Created by Haifa Carina Baluyos on 1/27/12.
//  Copyright 2012 Haifa Carina Baluyos, Inc. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData
@synthesize message, distance, jsonData, jsonDataDistance,records,newCoordinates,currentLocation, cellFont;
static GlobalData *sharedGlobalData = nil;

+ (GlobalData*)sharedGlobalData {
    if (sharedGlobalData == nil) {
        sharedGlobalData = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        sharedGlobalData.message = @"Default Global Message";
        sharedGlobalData.distance = [[NSNumber alloc]initWithFloat: 0.0];
		sharedGlobalData.jsonData = [[NSMutableString alloc] initWithString:@""];
		sharedGlobalData.jsonDataDistance = [[NSMutableString alloc] initWithString:@""];
        sharedGlobalData.records = [[NSMutableArray alloc]init];
		sharedGlobalData.newCoordinates = [[NSMutableString alloc] initWithString:@""];
        sharedGlobalData.currentLocation = @"";
        
        sharedGlobalData.cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
		
    }
    return sharedGlobalData;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self)
    {
        if (sharedGlobalData == nil)
        {
            sharedGlobalData = [super allocWithZone:zone];
            return sharedGlobalData;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax; //denotes an object that cannot be released
}
/*
- (void)release {
    //do nothing
}
*/
- (id)autorelease {
    return self;
}

// this is my global function
- (void)myFunc {
    self.message = @"Some Random Text";
}

@end
