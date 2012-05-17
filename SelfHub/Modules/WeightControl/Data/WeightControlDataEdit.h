//
//  WeightControlDataEdit.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightControlData.h"

@class WeightControlData;
@interface WeightControlDataEdit : UIViewController{
    
}

@property (nonatomic, assign) WeightControlData *delegate;
@property (nonatomic) NSInteger editingRecordIndex;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePick;
@property (nonatomic, retain) IBOutlet UILabel *weightLabel;
@property (nonatomic, retain) IBOutlet UIStepper *weightStepper;

- (IBAction)weightStepperChanged:(id)sender;
- (IBAction)saveRecord:(id)sender;

@end
