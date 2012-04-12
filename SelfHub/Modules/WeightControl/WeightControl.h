//
//  WeightControl.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"
#import "WeightControlChart.h"
#import "WeightControlData.h"
#import "WeightControlStatistics.h"
#import "WeightControlSettings.h"

@class WeightControlGraphView;

@interface WeightControl : UIViewController <ModuleProtocol>{
    NSMutableArray *weightData;
    NSNumber *aimWeight;
    NSNumber *normalWeight;
    
    NSArray *viewControllers;
    NSUInteger currentlySelectedViewController;
};

@property (nonatomic, assign) id <ServerProtocol> delegate;

@property (nonatomic, retain) NSMutableArray *weightData;
@property (nonatomic, retain) NSNumber *aimWeight;
@property (nonatomic, retain) NSNumber *normalWeight;

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIView *hostView;

- (IBAction)segmentedControlChanged:(id)sender;

- (void)fillTestData:(NSUInteger)numOfElements;
- (void)generateNormalWeight;

- (void)sortWeightData;

@end
