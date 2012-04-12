//
//  WeightControlDataEdit.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightControlDataEdit : UIViewController{
    
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePick;
@property (nonatomic, retain) IBOutlet UILabel *weightLabel;
@property (nonatomic, retain) IBOutlet UIStepper *weightStepper;

- (IBAction)weightStepperChanged:(id)sender;

@end
