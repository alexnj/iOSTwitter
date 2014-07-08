//
//  Tweet.h
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "Mantle.h"
#import "TwitterClient.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString  *id;
@property (nonatomic) NSString  *text;
@property (nonatomic) NSURL     *url;
@property (nonatomic) NSDate    *createdAt;
@property (nonatomic) NSString  *userName;
@property (nonatomic) NSString  *userScreenName;
@property (nonatomic) NSString  *userProfileImageUrl;
@property (nonatomic) NSNumber  *retweetCount;
@property (nonatomic) NSNumber  *favoriteCount;

- (NSString *)createdAtAsElapsed;

+ (void)timeline:(int)count success:(void (^)(NSArray* tweets))successBlock failure:(void (^)(void))failureBlock;
+ (void)tweet:(NSString*)message success:(void (^)(Tweet* tweet))successBlock failure:(void (^)(void))failureBlock;
- (void)retweet:(void (^)(Tweet* tweet))successBlock failure:(void (^)(void))failureBlock;

@end
