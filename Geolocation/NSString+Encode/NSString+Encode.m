//
//  NSString+Encode.m
//  Juno2
//
//  Created by Haifa Carina Baluyos on 2/6/12.
//  Copyright 2012 NMG Resources, Inc. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (encode)
- (NSString *)encodeString:(NSStringEncoding)encoding
{
	return (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
																NULL, (CFStringRef)@";/?:@&=$+{}<>,",
																CFStringConvertNSStringEncodingToEncoding(encoding));
}  
@end
