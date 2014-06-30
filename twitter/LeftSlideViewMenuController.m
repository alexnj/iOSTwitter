//
//  LeftSlideViewMenuController.m
//  twitter
//
//  Created by Alex on 6/29/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "LeftSlideViewMenuController.h"

@interface LeftSlideViewMenuController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* sectionTitleArray;
@property (strong, nonatomic) NSArray* menuHierarchy;
@end

@implementation LeftSlideViewMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sectionTitleArray = @[@"Menu", @"My account"];
        self.menuHierarchy = @[
                               @[
                                   @"Settings"
                                   ],
                               @[
                                   @"Sign out"
                                   ]
                               ];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Point table view data source and delegates to this class itself.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setBackgroundColor:UIColorFromRGB(0x24272b)];
    [self.tableView setSeparatorColor:UIColorFromRGB(0x393f45)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuHierarchy[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setBackgroundColor:UIColorFromRGB(0x212326)];
    cell.textLabel.text = self.menuHierarchy[indexPath.section][indexPath.row];
    [cell.textLabel setTextColor:UIColorFromRGB(0x9ca4af)];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitleArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuHierarchy.count;
}

// Custom color handlers.
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        [castView.contentView setBackgroundColor:UIColorFromRGB(0x24272b)];
        [castView.textLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self onClickSignout];
                    break;
            }
            break;
    }
}


#pragma mark Menu click handlers.

- (void) onClickSignout {
    [[TwitterClient sharedInstance] deauthorizeWithCompletion:^{
        [UIAppDelegate showLogin];
    }];
}

@end
