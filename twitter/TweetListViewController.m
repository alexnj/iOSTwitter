//
//  TweetListViewController.m
//  twitter
//
//  Created by Alex on 6/28/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "TweetListViewController.h"

@interface TweetListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tweetListTableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) TweetTableViewCell* prototypeCell;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TweetListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Load tweets.
        [self updateTimeline];
    }
    return self;
}

- (void)updateTimeline {
    [[TwitterClient sharedInstance] getTimeline:20 success:^(AFHTTPRequestOperation *operation, NSArray* jsonTweetsArray) {
        // Convert JSON response to Tweet Mantel Models.
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Tweet.class];
        self.tweets = [transformer transformedValue:jsonTweetsArray];
        
        // Refresh table view.
        // TODO: Ensure that tableView is ready by this time.
        [self.tweetListTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    // End pull-down-refresh rotation.
    [self.refreshControl endRefreshing];
}

- (void)attachPulldownRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tweetListTableView addSubview:self.refreshControl];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Twitter";
    
    // Point table view data source and delegates to this class itself.
    self.tweetListTableView.delegate = self;
    self.tweetListTableView.dataSource = self;
    
    [self attachPulldownRefresh];
    [self addComposeButton];
    [self addHamburgerButton];
    
    // Register Cell Nib.
    UINib *tableViewNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tweetListTableView registerNib:tableViewNib forCellReuseIdentifier:@"TweetTableViewCell"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (UITableViewCell *) tableView:(UITableView *)tweetListTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tweetListTableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];

    Tweet *tweet = self.tweets[indexPath.row];
    if (tweet!=nil) {
        cell.tweet = tweet;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Compose button

- (void)onComposeClick {
    ComposeViewController *svc = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)addComposeButton {
    UIImage *btnImage = [UIImage imageNamed:@"compose"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onComposeClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Compose" forState:UIControlStateNormal];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:TRUE];
    
    button.frame = CGRectMake(0.0, 0.0, 28.0, 28.0);
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

- (void)onHamburgerClick {
    
}

- (void)addHamburgerButton {
    UIImage *btnImage = [UIImage imageNamed:@"hamburger"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onHamburgerClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:TRUE];
    
    button.frame = CGRectMake(0.0, 0.0, 28.0, 28.0);
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}


# pragma mark Variable height table cells

// The approach is to have a dummy cell (prototypeCell) to do the calculation
// when heightForRowAtIndexPath is requested. To make it more efficient and
// non-sluggish, estimatedHeightForRowAtIndexPath is implemented that returns
// a fixed estimation for offscreen cells.

- (TweetTableViewCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tweetListTableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    }
    return _prototypeCell;
}

- (void) configureCell:(TweetTableViewCell*)prototypeCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the dummy cell to calculate height.
    
    Tweet *tweet = self.tweets[indexPath.row];
    if (tweet!=nil) {
        prototypeCell.tweet = tweet;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];

    // Fix the issue in width calculation on orientation change.
    // Combined with prototypeCell:layoutSubviews, this fixes
    // the issue where text height is wrong for multi-line text
    // (Especially when 3 lines of text, it introduces padding on
    // upper and lower edges).
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tweetListTableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));

    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // Add 1dpx height for the line.
    // Magically, this seems to fix the text layout issue described
    // above.
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
