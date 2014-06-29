//
//  ComposeViewController.m
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *text;
@end

@implementation ComposeViewController

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

    self.title = @"Compose";
    [self addTweetButton];
    [self addBackButton];
}

- (void)didReceiveMemoryWarning
{
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
    
}

- (void)addTweetButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onTweetClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Tweet" forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:TRUE];
    
    button.frame = CGRectMake(0.0, 0.0, 48.0, 28.0);
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

@end
