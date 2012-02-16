//
//  AppDelegate.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesktopViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) DesktopViewController *desktopViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
