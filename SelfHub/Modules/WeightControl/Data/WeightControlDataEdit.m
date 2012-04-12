//
//  WeightControlDataEdit.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlDataEdit.h"

@interface WeightControlDataEdit ()

@end

@implementation WeightControlDataEdit

@synthesize datePick, weightLabel, weightStepper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Record Details";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    datePick = nil;
    weightLabel = nil;
    weightStepper = nil;
}

-(void)dealloc{
    [datePick release];
    [weightLabel release];
    [weightStepper release];
    
    [super dealloc];
};


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    weightLabel.text = [NSString stringWithFormat:@"Weight: %.1f kg", weightStepper.value];
};

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)weightStepperChanged:(id)sender{
    weightLabel.text = [NSString stringWithFormat:@"Weight: %.1f kg", weightStepper.value];
};

@end
