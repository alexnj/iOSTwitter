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
    cell.backgroundColor = tableView.backgroundColor;
    cell.textLabel.text = self.menuHierarchy[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitleArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.menuHierarchy.count;
}

@end
