//
//  WeightControlTestClass.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeightControl.h"
#import "WeightControlPlotScrollView.h"
#import "WeightControlQuartzPlotContent.h"
#import "WeightControlVerticalAxisView.h"
#import "WeightControlHorizontalAxisView.h"

@class WeightControl;
@class WeightControlPlotScrollView;
@class WeightControlQuartzPlotContent;
@class WeightControlVerticalAxisView;
@class WeightControlHorizontalAxisView;

@interface WeightControlQuartzPlot : UIView{
    WeightControlPlotScrollView *scrollView;
    WeightControlQuartzPlotContent *contentView;
    WeightControlVerticalAxisView *yAxis;
    WeightControlHorizontalAxisView *xAxis;
}

@property (nonatomic, assign) WeightControl *delegateWeight;

@property (nonatomic, retain) WeightControlPlotScrollView *scrollView;
@property (nonatomic, retain) WeightControlQuartzPlotContent *contentView;
@property (nonatomic, retain) WeightControlVerticalAxisView *yAxis;
@property (nonatomic, retain) WeightControlHorizontalAxisView *xAxis;


- (id)initWithFrame:(CGRect)frame andDelegate:(WeightControl *)_delegate;

- (void)redrawPlot;

@end

