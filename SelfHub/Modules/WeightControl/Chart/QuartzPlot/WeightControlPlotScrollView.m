//
//  WeightControlPlotScrollView.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlPlotScrollView.h"

@implementation WeightControlPlotScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


//Perform updating (offseting) X-axis during scrolling
- (void)setContentOffset:(CGPoint)contentOffset{
    //NSLog(@"setContentOffset");
    WeightControlQuartzPlot *superView = (WeightControlQuartzPlot *)[self superview];
    superView.xAxis.center = CGPointMake(-contentOffset.x + superView.xAxis.frame.size.width/2, superView.xAxis.center.y);
    //[superView.yAxis performSelectorInBackground:@selector(setNeedsDisplay) withObject:nil];
    [super setContentOffset:contentOffset];
}

@end
