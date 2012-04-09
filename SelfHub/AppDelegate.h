//
//  AppDelegate.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomPanelViewController.h"
#import "SelfhubNavigationController.h"
#import "InfoViewController.h"

@class DesktopViewController;
@class InfoViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) DesktopViewController *desktopViewController;
@property (nonatomic, retain) InfoViewController *infoViewController;

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) BottomPanelViewController *bottomPanel;

- (IBAction)pressTab1:(id)sender;
- (IBAction)pressTab2:(id)sender;
- (IBAction)pressTab3:(id)sender;

@end
