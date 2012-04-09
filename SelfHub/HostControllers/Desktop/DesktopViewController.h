//
//  ViewController.h
//  HealthCare
//
//  Created by Eugine Korobovsky on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"
#import "MainInformation.h"
#import "BottomPanelViewController.h"
#import "SelfhubNavigationController.h"


@interface DesktopViewController : UIViewController <ServerProtocol, UITableViewDelegate, UITableViewDataSource>{
    NSArray *modulesArray;
}

@property (nonatomic, retain) IBOutlet UITableView *modulesTable;

- (IBAction)pressMenuButton:(id)sender;

@end
