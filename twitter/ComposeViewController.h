//
//  ComposeViewController.h
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TwitterClient.h"

@interface ComposeViewController : UIViewController
- (void)setTweetUpdateCallback:(UIViewController*)vc selector:(SEL)selector;
@end
