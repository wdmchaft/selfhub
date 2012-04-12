//
//  WeightControlChart.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightControl.h"
#import "WeightControlGraphView.h"

@class WeightControl;
@class WeightControlGraphView;

@interface WeightControlChart : UIViewController{
    
};

@property (nonatomic, assign) WeightControl *delegate;

@property (nonatomic, retain) IBOutlet WeightControlGraphView *weightGraph;
@property (nonatomic, retain) IBOutlet UILabel *todayWeightLabel;
@property (nonatomic, retain) IBOutlet UIStepper *todayWeightStepper;
@property (nonatomic, retain) IBOutlet UILabel *topGraphStatus;
@property (nonatomic, retain) IBOutlet UILabel *bottomGraphStatus;

- (IBAction)todayWeightStepperChanged:(id)sender;

@end
