//
//  WeightControlData.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightControl.h"
#import "WeightControlDataEdit.h"

@class WeightControl;
@class WeightControlDataEdit;

@interface WeightControlData : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    WeightControlDataEdit *detailView;
    NSIndexPath *deletedRow;
};

@property (nonatomic, assign) WeightControl *delegate;
@property (nonatomic, retain) IBOutlet UITableView *dataTableView;

- (IBAction)addDataRecord;
- (IBAction)finishEditingRecord;
- (IBAction)pressEdit;

@end
