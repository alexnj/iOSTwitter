//
//  Tweet.m
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

// A static dateformatter (creating these are costly)
+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

// Map model to JSON fields.
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"text": @"text",
             @"url": @"url",
             @"dateTweeted": @"created_at",
             @"userName": @"user.name",
             @"userScreenName": @"user.screen_name",
             @"userProfileImageUrl": @"user.profile_image_url"
             };
}

// Transformer URL<->String.
+ (NSValueTransformer *)URLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// Transformer dateTweeted<->NSDate
+ (NSValueTransformer *)dateTweetedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
