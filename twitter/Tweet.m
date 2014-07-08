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
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    
    return dateFormatter;
}

// Map model to JSON fields.
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"id":@"id",
             @"text": @"text",
             @"url": @"url",
             @"createdAt": @"created_at",
             @"userName": @"user.name",
             @"userScreenName": @"user.screen_name",
             @"userProfileImageUrl": @"user.profile_image_url",
             @"retweetCount" : @"retweet_count",
             @"favoriteCount" : @"favourites_count"
             };
}

// Transformer URL<->String.
+ (NSValueTransformer *)URLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// Transformer createdAt<->NSDate
+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

// Return createdAt as a human readable time elapsed string.
- (NSString *)createdAtAsElapsed {
    NSTimeInterval interval = [self.createdAt timeIntervalSinceNow];
    
    NSString *retVal = @"now";
    if (interval == 0) return retVal;
    
    int second = 1;
    int minute = second*60;
    int hour = minute*60;
    int day = hour*24;
    // interval can be before (negative) or after (positive)
    int num = abs(interval);
    
    NSString *beforeOrAfter = @"before";
    NSString *unit = @"day";
    if (interval > 0) {
        beforeOrAfter = @"after";
    }
    
    if (num >= day) {
        num /= day;
        if (num > 1) unit = @"d";
    } else if (num >= hour) {
        num /= hour;
        unit = (num > 1) ? @"h" : @"h";
    } else if (num >= minute) {
        num /= minute;
        unit = (num > 1) ? @"m" : @"m";
    } else if (num >= second) {
        num /= second;
        unit = (num > 1) ? @"s" : @"s";
        
    }
    
    return [NSString stringWithFormat:@"%d%@", num, unit];
}

/* Network based operations supported by the model */

+ (void)timeline:(int)count success:(void (^)(NSArray* tweets))successBlock failure:(void (^)(void))failureBlock {
    [[TwitterClient sharedInstance] getTimeline:count success:^(AFHTTPRequestOperation *operation, NSArray* jsonTweetsArray) {
        // Convert JSON response to Tweet Mantel Model objects.
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Tweet.class];
        NSArray* tweets = [transformer transformedValue:jsonTweetsArray];
        
        successBlock(tweets);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
}

+ (void)tweet:(NSString*)message success:(void (^)(Tweet* tweet))successBlock failure:(void (^)(void))failureBlock {
    [[TwitterClient sharedInstance] tweet:message success:^(AFHTTPRequestOperation *operation, NSDictionary* jsonTweet) {
        NSLog(@"Tweet Successful %@", jsonTweet);
        
        // Convert JSON response to Tweet Mantel Models.
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Tweet.class];
        Tweet *c = [transformer transformedValue:jsonTweet];
        
        successBlock(c);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet failure: %@", error);
        
        failureBlock();
    }];
}

- (void)retweet:(void (^)(Tweet* tweet))successBlock failure:(void (^)(void))failureBlock {
    [[TwitterClient sharedInstance] retweet:self.id success:^(AFHTTPRequestOperation *operation, NSDictionary* jsonTweet) {
        NSLog(@"Retweet Successful %@", jsonTweet);

        // Convert JSON response to Tweet Mantel Models.
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Tweet.class];
        Tweet *c = [transformer transformedValue:jsonTweet];
        
        successBlock(c);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet failure: %@", error);
        
        failureBlock();
    }];
}

@end