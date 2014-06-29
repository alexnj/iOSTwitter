//
//  TwitterClient.h
//  twitter
//
//  Created by Alex on 6/28/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterApiSecrets.h"
#import "NSDictionary+BDBOAuth1Manager.h"
#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*)sharedInstance;
- (id)init;
- (void)authorize;
- (void)deauthorizeWithCompletion:(void (^)(void))completion;

@end
