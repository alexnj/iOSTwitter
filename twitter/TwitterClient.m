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



@end
