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
    CPTPlotSpaceAnnotation *normLineAnnotation;
    CPTPlotRange *dataRangeX, *dataRangeY;
};

@property (nonatomic, assign) WeightControl *delegate;

@property (nonatomic, retain) NSDate *fromDateGraph;
@property (nonatomic, retain) NSDate *toDateGraph;

@property (nonatomic, retain) CPTGraphHostingView *hostingView;

- (NSInteger)getIntegerDateComponent:(NSDate *)date byFormat:(NSString *)format;

- (void)createGraphLayer;
- (void)showLastWeekGraph;
- (void)showFullGraph;
- (void)showGraphFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)updatePlotRanges;

@end
