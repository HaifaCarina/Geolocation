//
//  Records.m
//  Juno2
//
//  Created by Haifa Carina Baluyos on 2/1/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "Records.h"


@implementation Records

@synthesize name;
@synthesize category;
@synthesize starRating;
@synthesize remark;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize coordinate;
@synthesize distance;
@synthesize recordId;

- (id) getDistance {
    return distance;
}

@end
