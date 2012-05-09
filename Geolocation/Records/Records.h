//
//  Records.h
//  Juno2
//
//  Created by Haifa Carina Baluyos on 2/1/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Records : NSObject {
    NSString *name;
    NSString *category;
    NSString *starRating;
    NSString *remark;
    NSString *address1;
    NSString *address2;
    NSString *city;
    NSString *state;
    NSString *zip;
    //NSString *coordinate;
    NSString *distance;
    NSString *recordId;
    NSString *latitude;
    NSString *longitude;
}


@property (retain) NSString *name;
@property (retain) NSString *category;
@property (retain) NSString *starRating;
@property (retain) NSString *remark;
@property (retain) NSString *address1;
@property (retain) NSString *address2;
@property (retain) NSString *city;
@property (retain) NSString *state;
@property (retain) NSString *zip;
//@property (retain) NSString *coordinate;
@property (retain) NSString *distance;
@property (retain) NSString *recordId;
@property (retain) NSString *latitude;
@property (retain) NSString *longitude;

- (id) getDistance;
@end
