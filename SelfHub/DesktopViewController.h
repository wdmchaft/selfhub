//
//  ViewController.h
//  HealthCare
//
//  Created by Eugine Korobovsky on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesktopViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *modulesArray;
}

@property (nonatomic, retain) IBOutlet UITableView *modulesTable;

@end
