//
//  TweetListViewController.m
//  twitter
//
//  Created by Alex on 6/28/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "TweetListViewController.h"

@implementation TweetListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadTweets];
    }
    return self;
}

- (void)loadTweets {
    [[TwitterClient sharedInstance] getTimeline:20 success:^(AFHTTPRequestOperation *operation, NSArray* jsonTweetsArray) {
        NSLog(@"Success %@", jsonTweetsArray);
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Tweet.class];
        NSArray *tweets = [transformer transformedValue:jsonTweetsArray];
        
        NSLog(@"Success %@", tweets);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
