//
//  ComposeViewController.m
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) UIViewController *tweetCallbackViewController;
@property (assign, nonatomic) SEL tweetCallbackViewMethod;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add save and cancel buttons.
    [self addTweetButton];
    [self addBackButton];
    
    // Set focus on tweet field.
    [self.text becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark Navigation bar buttons


- (void)onBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setShowsTouchWhenHighlighted:TRUE];
    [backButton addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.hidesBackButton = TRUE;
    self.navigationItem.leftBarButtonItem = barBackItem;
}

- (void)onTweetClick {
    [[TwitterClient sharedInstance] tweet:self.text.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.tweetCallbackViewController != nil && self.tweetCallbackViewMethod != nil) {
            
            // Convert JSON response to Tweet Mantle Model.
            NSValueTransformer *transformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Tweet.class];
            Tweet *newTweet = [transformer transformedValue:responseObject];

            // Pass it back to call back to have it locally processed.
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.tweetCallbackViewController performSelector:self.tweetCallbackViewMethod withObject:newTweet];
            #pragma clang diagnostic pop
            
            // Close and go back to previous view.
            [self onBackClick];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Could not post the update. Please try again later."
                                       delegate:self
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        });
    }];
}

- (void)addTweetButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onTweetClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Tweet" forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:TRUE];
    
    button.frame = CGRectMake(0.0, 0.0, 48.0, 28.0);
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}


#pragma mark Local tweet update callback support.

- (void)setTweetUpdateCallback:(UIViewController*)vc selector:(SEL)selector {
    self.tweetCallbackViewController = vc;
    self.tweetCallbackViewMethod = selector;
}

@end
