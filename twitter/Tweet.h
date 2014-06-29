//
//  Tweet.h
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "Mantle.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString  *text;
@property (nonatomic) NSURL     *url;
@property (nonatomic) NSDate    *createdAt;
@property (nonatomic) NSString  *userName;
@property (nonatomic) NSString  *userScreenName;
@property (nonatomic) NSString  *userProfileImageUrl;

- (NSString *)createdAtAsElapsed;

@end
