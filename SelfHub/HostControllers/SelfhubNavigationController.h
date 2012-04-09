//
//  SelfhubNavigationController.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomPanelViewController.h"

@interface SelfhubNavigationController : UINavigationController{
    BottomPanelViewController *bottomPanel;
};

@property (nonatomic, assign) BottomPanelViewController *bottomPanel;

@end
