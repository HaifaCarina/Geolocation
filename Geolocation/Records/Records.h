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
	 NSString *location;
	 NSString *coordinate;
	 NSString *category;
	 NSString *content;
	 NSString *remark;
	 NSString *source;
	 NSString *starRating;
	 NSString *distance;
}


@property (retain) NSString *name;
@property (retain) NSString *location;
@property (retain) NSString *coordinate;
@property (retain) NSString *category;
@property (retain) NSString *content;
@property (retain) NSString *remark;
@property (retain) NSString *source;
@property (retain) NSString *starRating;
@property (retain) NSString *distance;
/*
- (id) initWithName: (NSString *)inName 
		   location: (NSString *)inLocation 
		 coordinate: (NSString *)inCoordinate 
		   category: (NSString *)inCategory 
			content: (NSString *) inContent
			 remark: (NSString *) inRemark
			 source: (NSString *) inSource
		 starRating: (NSString *) inStarRating
		   distance: (NSString *) inDistance;
*/
- (id) getName;
- (id) getLocation;
- (id) getCoordinate;
- (id) getCategory;
- (id) getContent;
- (id) getRemark;
- (id) getSource;
- (id) getStarRating;
- (id) getDistance;

@end
