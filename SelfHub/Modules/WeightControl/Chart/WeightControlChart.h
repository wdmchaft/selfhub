//
//  WeightControlChart.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightControl.h"
#import "WeightControlQuartzPlot.h"

@class WeightControl;
@class WeightControlQuartzPlot;

@interface WeightControlChart : UIViewController{
    
};

@property (nonatomic, assign) WeightControl *delegate;

@property (nonatomic, retain) IBOutlet WeightControlQuartzPlot *weightGraph;

//@property (nonatomic, retain) IBOutlet WeightControlPlotScrollView *weightGraphScrollView;
//@property (nonatomic, retain) IBOutlet WeightControlVerticalAxisView *weightGraphYAxisView;

@property (nonatomic, retain) IBOutlet UILabel *todayWeightLabel;
@property (nonatomic, retain) IBOutlet UIStepper *todayWeightStepper;
@property (nonatomic, retain) IBOutlet UILabel *topGraphStatus;
@property (nonatomic, retain) IBOutlet UILabel *bottomGraphStatus;

- (IBAction)pressDefault;
- (void)updateTodaysWeightState;
- (IBAction)todayWeightStepperChanged:(id)sender;

- (IBAction)pressScaleButton:(id)sender;

@end
