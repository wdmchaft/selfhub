//
//  WeightControlChart.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlChart.h"

@interface WeightControlChart ()

@end

@implementation WeightControlChart

@synthesize delegate;
@synthesize weightGraph;
@synthesize todayWeightLabel, todayWeightStepper, topGraphStatus, bottomGraphStatus;

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
    
    weightGraph.delegate = delegate;
    [weightGraph createGraphLayer];
    [weightGraph showLastWeekGraph];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    todayWeightLabel = nil;
    todayWeightStepper = nil;
    topGraphStatus = nil;
    bottomGraphStatus = nil;
    weightGraph = nil;
}

-(void)dealloc{
    [todayWeightLabel release];
    [todayWeightStepper release];
    [topGraphStatus release];
    [bottomGraphStatus release];
    [weightGraph release];
    
    [super dealloc];
};


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
};

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)todayWeightStepperChanged:(id)sender{
    todayWeightLabel.text = [NSString stringWithFormat:@"Today's weight:  %.1f kg", todayWeightStepper.value];
};

@end
