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


- (void)handleOAuthCallbackWithSuccess:(NSString *)queryString success:(void (^)(void))success {
    NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:queryString];
    
    if (parameters[BDBOAuth1OAuthTokenParameter] && parameters[BDBOAuth1OAuthVerifierParameter]) {
        [self fetchAccessTokenWithPath:@"/oauth/access_token"
                                method:@"POST"
                          requestToken:[BDBOAuthToken tokenWithQueryString:queryString]
                               success:^(BDBOAuthToken *accessToken) {
                                   NSLog(@"Access token: %@", accessToken);
                                   if (success) {
                                       success();
                                   }
                               }
                               failure:^(NSError *error) {
                                   NSLog(@"Error: %@", error.localizedDescription);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:@"Could not acquire OAuth access token. Please try again later."
                                                                  delegate:self
                                                         cancelButtonTitle:@"Dismiss"
                                                         otherButtonTitles:nil] show];
                                   });
                               }];
    }
}

# pragma mark APIs

- (void)getTimeline:(int)count success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // TODO: Remove hard-coded count.
    NSString *timeline = @"statuses/home_timeline.json?count=20";
    
    [self GET:timeline parameters:nil success:success failure:failure];
    
}

- (void)tweet:(NSString *)update success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *timeline = @"statuses/update.json";
    NSDictionary *parameters = @{@"status": update};
    
    [self POST:timeline parameters:parameters success:success failure:failure];
}

@end
