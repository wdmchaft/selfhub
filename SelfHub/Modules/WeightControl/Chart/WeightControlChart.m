//
//  WeightControlChart.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlChart.h"
//#import "WeightControlQuartzPlot.h"

//@interface WeightControlChart ()
//
//@end

@implementation WeightControlChart

@synthesize delegate;
//@synthesize weightGraphScrollView, weightGraph, weightGraphYAxisView;
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
    
    /*weightGraphYAxisView.backgroundColor = [UIColor whiteColor];
    weightGraph.delegateWeight = delegate;
    weightGraph.weightGraphYAxisView = weightGraphYAxisView;
    [weightGraph initializeGraph];
    
    weightGraphScrollView.delegate = weightGraph;
    weightGraphScrollView.minimumZoomScale = 0.5f;
    weightGraphScrollView.maximumZoomScale = 6.0f;
    weightGraphScrollView.contentSize = weightGraph.frame.size;
    weightGraphScrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [weightGraphScrollView setScrollEnabled:YES];*/
    
    //[weightGraph setNeedsDisplay];
    
    //[weightGraph createGraphLayer];
    //[weightGraph showLastWeekGraph];
    
    weightGraph = [[WeightControlQuartzPlot alloc] initWithFrame:CGRectMake(0.0, 107.0, 320.0, 256.0) andDelegate:delegate];
    [self.view addSubview:weightGraph];
    
    
    [self updateTodaysWeightState];
    //[weightGraph.hostingView.hostedGraph reloadData];
    
};

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    todayWeightLabel = nil;
    todayWeightStepper = nil;
    topGraphStatus = nil;
    bottomGraphStatus = nil;
    //weightGraphScrollView = nil;
    //weightGraph = nil;
    //weightGraphYAxisView = nil;
}

-(void)dealloc{
    [todayWeightLabel release];
    [todayWeightStepper release];
    [topGraphStatus release];
    [bottomGraphStatus release];
    //[weightGraphScrollView release];
    //[weightGraph release];
    //[weightGraphYAxisView release];
    
    [super dealloc];
};


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSLog(@"graph will appear");
    //[weightGraph.hostingView.hostedGraph reloadData];
    //[weightGraph setNeedsDisplay];

    [self updateTodaysWeightState];
};

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressDefault{
    //NSLog(@"gesture recognizers: %d", [weightGraph.hostingView.gestureRecognizers count]);
    //[weightGraph.hostingView.hostedGraph.defaultPlotSpace ]
    //self.xRange = newRangeX;
    
    //[weightGraph setScaleFactor:weightGraph.scaleFactor-0.1];
    //return;
    
    [delegate fillTestData:33];
    
    //[weightGraph setNeedsDisplay];
    
    //[weightGraph.hostingView.hostedGraph reloadData];
    //[weightGraph updatePlotRanges];
    //[weightGraph showLastWeekGraph];
};

- (void)updateTodaysWeightState{
    NSNumber *weightFromAntropometry = [delegate.delegate getValueForName:@"weight" fromModuleWithID:@"selfhub.antropometry"];
    NSDate *lastRecordDate = [[delegate.weightData lastObject] objectForKey:@"date"];
    if(lastRecordDate==nil){
        if(weightFromAntropometry==nil){
            todayWeightLabel.text = @"Today's weight: 75.0 kg";
            todayWeightStepper.value = 75.0f;
        }else{
            todayWeightLabel.text = [NSString stringWithFormat:@"Today's weight: %.1f kg", [weightFromAntropometry floatValue]];
            todayWeightStepper.value = [weightFromAntropometry floatValue];
        };
    }else{
        NSNumber *lastRecordWeight = [[delegate.weightData lastObject] objectForKey:@"weight"];
        todayWeightLabel.text = [NSString stringWithFormat:@"Today's weight: %.1f kg", [lastRecordWeight floatValue]];
        todayWeightStepper.value = [lastRecordWeight floatValue];
        
        if([delegate compareDateByDays:lastRecordDate WithDate:[NSDate date]]==NSOrderedSame){
            todayWeightLabel.textColor = [UIColor darkTextColor];
        }else{
            todayWeightLabel.textColor = [UIColor darkGrayColor];
        };
    };

};

- (IBAction)todayWeightStepperChanged:(id)sender{    
    NSComparisonResult compRes;
    int i;
    for(i=[delegate.weightData count]-1;i>=0;i--){
        NSDictionary *oneRec = [delegate.weightData objectAtIndex:i];
        compRes = [delegate compareDateByDays:[NSDate date] WithDate:[oneRec objectForKey:@"date"]];
        if(compRes==NSOrderedSame){
            [delegate.weightData removeObject:oneRec];
            i--;
            break;
        };
        if(compRes==NSOrderedDescending){
            break;
        };
    };
    
    NSDate *newDate = [NSDate date];
    NSNumber *newWeight = [NSNumber numberWithFloat:todayWeightStepper.value];
    
    newDate = [delegate getDateWithoutTime:newDate];
    
    [delegate.weightData insertObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:newDate, newWeight, nil] forKeys:[NSArray arrayWithObjects:@"date", @"weight", nil]] atIndex:i+1];
    
    todayWeightLabel.text = [NSString stringWithFormat:@"Today's weight:  %.1f kg", todayWeightStepper.value];
    todayWeightLabel.textColor = [UIColor darkTextColor];
    
    if([delegate compareDateByDays:newDate WithDate:[NSDate date]] == NSOrderedSame){   //Setting weight in antropometry module
        [delegate.delegate setValue:newWeight forName:@"weight" forModuleWithID:@"selfhub.antropometry"];
    }
    
    [weightGraph redrawPlot];
    /*
    CGRect updatedRect = CGRectMake(weightGraphScrollView.contentOffset.x, 
                                    weightGraphScrollView.contentOffset.y,
                                    weightGraphScrollView.frame.size.width,
                                    weightGraphScrollView.frame.size.height);
    [weightGraph setNeedsDisplayInRect:updatedRect];
     */
    
    //[weightGraph.hostingView.hostedGraph reloadData];
};

- (IBAction)pressScaleButton:(id)sender{
    NSLog(@"WeightControlChart: scaleButtonPressed - tag = %d", [sender tag]);
};

@end
