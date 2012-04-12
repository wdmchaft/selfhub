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

@end
