//
//  WeightControlGraphView.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "WeightControl.h"

@class WeightControl;

@interface WeightControlGraphView : UIView <CPTPlotDataSource, CPTPlotSpaceDelegate> {
    CPTGraphHostingView *hostingView;
    UIScrollView *graphScrollView;
    
    CPTPlotSpaceAnnotation *normLineAnnotation;
    CPTPlotRange *dataRangeX, *dataRangeY;
    CGFloat scaleFactor;
    NSTimer *scaleHideTimer;
};

@property (nonatomic, assign) WeightControl *delegate;

@property (nonatomic, retain) NSDate *fromDateGraph;
@property (nonatomic, retain) NSDate *toDateGraph;
@property (nonatomic) CGFloat scaleFactor;

@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) IBOutlet UIView *scaleView;

- (NSInteger)getIntegerDateComponent:(NSDate *)date byFormat:(NSString *)format;

//Called for graph initializing
- (void)createGraphLayer;

//Called when weight records are changed
- (void)updatePlotRanges;

//Update all graph's labels for current axis ranges
- (void)updateGraphLabels;

//Subroutines for setting x-axis range
- (void)showLastWeekGraph;
- (void)showFullGraph;
- (void)showGraphFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (void)setGraphWidth:(CGFloat)graphWidth;
- (void)setScaleFactor:(CGFloat)newScaleFactor;
- (void)showDateAtBegin:(NSDate *)showingDate;

- (IBAction)pressScaleButton:(id)sender;
- (void)showScaleView;
- (void)hideScaleView;
- (void)hideScaleViewTimerSelector:(NSTimer *)timer;


- (IBAction)pinchGestureSelector:(UIPinchGestureRecognizer *)sender;
- (IBAction)tapGestureSelector:(UITapGestureRecognizer *)sender;

@end
