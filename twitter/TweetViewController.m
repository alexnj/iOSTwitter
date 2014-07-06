//
//  TweetViewController.m
//  twitter
//
//  Created by Alex on 7/6/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userScreenName;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *retweetCount;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self displayTweet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTweet {
    Tweet* tweet = self.tweet;
    
    self.userName.text = tweet.userName;
    self.userScreenName.text = [@"@" stringByAppendingString:tweet.userScreenName];
    self.text.text = tweet.text;
    self.retweetCount.text = [tweet.retweetCount stringValue];
    self.favoriteCount.text = tweet.favoriteCount == 0 ? @"0" : [tweet.favoriteCount stringValue];
    
    // <strong>Output ->  Date: 10/29/2008 08:29PM</strong>
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSString *dateString = [dateFormat stringFromDate:tweet.createdAt];
    
    self.time.text = dateString;
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tweet.userProfileImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        [self setImageOnMainThread:self.userProfileImage image:image];
    }];
}

- (void)setImageOnMainThread: (UIImageView *)imageView image:(UIImage *)image {
    if (!image)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [imageView.layer addAnimation:transition forKey:nil];
        
        imageView.image = image;
    });
}


@end
