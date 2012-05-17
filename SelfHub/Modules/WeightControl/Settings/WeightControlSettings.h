//
//  WeightControlSettings.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightControl.h"

@class WeightControl;

@interface WeightControlSettings : UIViewController{
    
};

@property (nonatomic, assign) WeightControl *delegate;

@property (nonatomic, retain) IBOutlet UILabel *aimLabel;
@property (nonatomic, retain) IBOutlet UIStepper *aimStepper;
@property (nonatomic, retain) IBOutlet UILabel *heightLabel;
@property (nonatomic, retain) IBOutlet UILabel *ageLabel;

- (IBAction)changeAimStepper:(id)sender;
- (IBAction)pressChangeAntropometryValues:(id)sender;

@end
