//
//  WeightControlTestClass.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlQuartzPlot.h"

@implementation WeightControlQuartzPlot

@synthesize delegateWeight, scrollView, contentView, xAxis, yAxis;

- (id)initWithFrame:(CGRect)frame andDelegate:(WeightControl *)_delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scrollView = [[WeightControlPlotScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        yAxis = [[WeightControlVerticalAxisView alloc] initWithFrame:CGRectMake(0.0, 0.0, 33.0, frame.size.height)];
        [yAxis setBackgroundColor:[UIColor whiteColor]];
        xAxis = [[WeightControlHorizontalAxisView alloc] initWithFrame:CGRectMake(0.0, frame.size.height-15.0, 10000, 15.0)];
        [xAxis setBackgroundColor:[UIColor whiteColor]];
        contentView = [[WeightControlQuartzPlotContent alloc] initWithFrame:CGRectMake(0.0, 0.0, 10000.0, frame.size.height)];
        contentView.delegateWeight = _delegate;
        contentView.weightGraphYAxisView = yAxis;
        contentView.weightGraphXAxisView = xAxis;
        
        scrollView.delegate = contentView;
        scrollView.minimumZoomScale = 0.1f;
        scrollView.maximumZoomScale = 10.0f;
        scrollView.contentSize = contentView.frame.size;
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [scrollView setScrollEnabled:YES];
        [scrollView addSubview:contentView];
        
        [self addSubview:scrollView];
        [self addSubview:xAxis];
        [self addSubview:yAxis];
        
    }
    return self;
}

- (void)dealloc{
    delegateWeight = nil;
    [scrollView release];
    [contentView release];
    [xAxis release];
    [yAxis release];
    
    [super dealloc];
}

- (void)redrawPlot{
    [contentView setNeedsDisplay];
};

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
