//
//  TwitterClient.m
//  twitter
//
//  Created by Alex on 6/28/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient*)sharedInstance {
    static TwitterClient *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TwitterClient alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark Initialization

- (id)init {
    NSURL *apiURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/"];
    
    self = [self initWithBaseURL:apiURL consumerKey:consumerKey consumerSecret:consumerSecret];
    
    return self;
}

#pragma mark OAuth Authorization

- (void)authorize {
    [self fetchRequestTokenWithPath:@"/oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"iostwitterapp://request"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Error: %@", error.localizedDescription);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Could not acquire OAuth request token. Please try again later."
                                                               delegate:self
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil] show];
                                });
                            }];
}

- (void)deauthorizeWithCompletion:(void (^)(void))completion {
    [self deauthorize];
    
    if (completion) {
        completion();
    }
}


@end
