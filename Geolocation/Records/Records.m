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
@synthesize location;
@synthesize coordinate;
@synthesize category;
@synthesize content;
@synthesize remark;
@synthesize source;
@synthesize starRating;
@synthesize distance;

/*
- (id) initWithName: (NSString *)inName 
		   location: (NSString *)inLocation 
		 coordinate: (NSString *)inCoordinate 
		   category: (NSString *)inCategory 
			content: (NSString *) inContent
			 remark: (NSString *) inRemark
			 source: (NSString *) inSource
		 starRating: (NSString *) inStarRating
		   distance: (NSString *) inDistance
{
	self = [super init];
	if (self) {
		NSLog(@"_init: %@", self);
		
		name = inName;
		location = inLocation;
		coordinate = inCoordinate;
		category = inCategory;
		content = inContent;
		remark	 = inRemark;
		source = inSource;
		starRating = inStarRating;
		distance = inDistance;
		
	}
	return self;
	
}
*/

- (id) getName {
	return name;
}
- (id) getLocation {
	return location;
}
- (id) getCoordinate {
    NSLog(@"RECORD %@", coordinate);
	return coordinate;
}
- (id) getCategory {
	return category;
}
- (id) getContent {
	return content;
}
- (id) getRemark {
	return remark;
}
- (id) getSource {
	return source;
}
- (id) getStarRating {
	return starRating;
}
- (id) getDistance {
	return distance;
}


@end
