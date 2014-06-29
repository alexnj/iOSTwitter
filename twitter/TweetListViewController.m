//
//  TweetListViewController.m
//  twitter
//
//  Created by Alex on 6/28/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "TweetListViewController.h"
#import "TweetTableViewCell.h"

@interface TweetListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tweetListTableView;
@property (strong, nonatomic) NSArray *tweets;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Point table view data source and delegates to this class itself.
    self.tweetListTableView.delegate = self;
    self.tweetListTableView.dataSource = self;
    
    // Set fixed row height.
    self.tweetListTableView.rowHeight = 100;
    
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

@end
