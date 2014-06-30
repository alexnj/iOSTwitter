//
//  AppDelegate.m
//  twitter
//
//  Created by Alex on 6/28/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) ECSlidingViewController *slidingViewController;
@end

@implementation AppDelegate

- (id)init {
    self = [super init];
    return self;
}

- (void)showLogin {
    LoginViewController* loginView = [[LoginViewController alloc] init];
    [self.window setRootViewController:loginView];
}

- (void)showMainView {
    // Initialize TweetListView
    TweetListViewController *vc = [[TweetListViewController alloc] init];
    
    // Setup navigation controller.
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x55acee)];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:16.0], NSFontAttributeName, nil]];

    // Install Left slide view controller.
    [self installLeftSlideViewWithTopViewController:nvc];
}

#pragma mark Setup a slide-menu view.

- (void)slideToRevealLeftMenu {
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    }
}

- (void)installLeftSlideViewWithTopViewController:(UIViewController*)nvc {
    UIViewController *underLeftViewController  = [[LeftSlideViewMenuController alloc] init];
    
    // configure sliding view controller
    self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:nvc];
    self.slidingViewController.underLeftViewController  = underLeftViewController;
    
    // enable swiping on the top view
    [nvc.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // configure anchored layout
    self.slidingViewController.anchorRightPeekAmount  = 160.0;
    
    self.window.rootViewController = self.slidingViewController;
}

#pragma Lifecycle of the app.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[TwitterClient sharedInstance] isAuthorized]) {
        [self showMainView];
    }
    else {
        [self showLogin];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"iostwitterapp"]) {
        if ([url.host isEqualToString:@"request"]) {
            [[TwitterClient sharedInstance] handleOAuthCallbackWithSuccess:url.query success:^{
                [self showMainView];
            }];
        }
        
        return YES;
    }
    
    return NO;
}

@end
