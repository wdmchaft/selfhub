//
//  AppDelegate.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "DesktopViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize desktopViewController = _desktopViewController;
@synthesize infoViewController = _infoViewController;
@synthesize tabBarController = _tabBarController;
@synthesize bottomPanel = _bottomPanel;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_desktopViewController release];
    [_infoViewController release];
    [_bottomPanel release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.desktopViewController = [[[DesktopViewController alloc] initWithNibName:@"DesktopViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.desktopViewController = [[[DesktopViewController alloc] initWithNibName:@"DesktopViewController_iPad" bundle:nil] autorelease];
    }
    self.infoViewController = [[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil] autorelease];
    
    UINavigationController *modulesNavigationController = [[UINavigationController alloc] initWithRootViewController:_desktopViewController];
    
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:modulesNavigationController, _infoViewController, nil]];
    [modulesNavigationController release];
    
    
    
    /*_navigationController = [[UINavigationController alloc] initWithRootViewController:_desktopViewController];
    UIView *tab1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 48)];
    UIImageView *tab1Subview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomPanel_tab1_norm.png"]];
    [tab1View addSubview:tab1Subview];
    
    UIBarButtonItem *firstTabItem = [[UIBarButtonItem alloc] initWithCustomView:tab1View];
    //[[UIBarButtonItem alloc] initWithTitle:@"Modules" style:UIBarButtonItemStylePlain target:self action:@selector(pressTab1:)];
    UIBarButtonItem *secondTabItem = [[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:UIBarButtonItemStyleBordered target:self action:@selector(pressTab2:)];
    UIBarButtonItem *thirdTabItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(pressTab3:)];
    [_desktopViewController setToolbarItems:[NSArray arrayWithObjects:firstTabItem, secondTabItem, thirdTabItem, nil]];
    [_navigationController setToolbarHidden:NO animated:YES];
    [firstTabItem release];
    [secondTabItem release];
    [thirdTabItem release];*/
    
    //_navigationController.bottomPanel = _bottomPanel;
    
    self.window.rootViewController = self.tabBarController;
    
    //[self.window.rootViewController.view addSubview:self.navigationController.bottomPanel.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark - UITabBarControllerDelegate's methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
};
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
};


- (IBAction)pressTab1:(id)sender{
    
};
- (IBAction)pressTab2:(id)sender{
    
};

- (IBAction)pressTab3:(id)sender{
    
};
                        


@end
