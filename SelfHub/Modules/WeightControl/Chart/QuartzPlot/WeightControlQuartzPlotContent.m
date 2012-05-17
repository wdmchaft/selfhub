//
//  WeightControlQuartzPlot.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 10.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlQuartzPlotContent.h"

@implementation WeightControlQuartzPlotContent

@synthesize delegateWeight, weightGraphYAxisView, weightGraphXAxisView;

- (void)dealloc{
    delegateWeight = nil;
    weightGraphYAxisView = nil;
    weightGraphXAxisView = nil;
    
    [super dealloc];
};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        self.frame = CGRectMake(0, 0, 3000, self.frame.size.height);
        verticalGridLinesInterval = 50.0f;
        verticalGridLinesWidth = 0.5f;
        
        horizontalGridLinesInterval = 30.0f;
        horizontalGridLinesWidth = 0.2f;
        
        plotXOffset = 2;
        plotYExpandFactor = 0.2f;
        weightLineWidth = 2.0f;
        weightPointRadius = 2;
    }
    return self;
};

- (void)initializeGraph{
    
};


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    time_t startClock = clock();
    
    //---------- Getting common parameters ----------
    NSTimeInterval oneDay = 60*60*24;
    NSDate *drawPlotFromDate = [[delegateWeight.weightData objectAtIndex:0] objectForKey:@"date"];
    NSDate *drawPlotToDate = [[delegateWeight.weightData lastObject] objectForKey:@"date"];
    NSArray *minMaxWeight = [self calcYRangeFromDates:drawPlotFromDate toDate:drawPlotToDate];
    yAxisFrom = [[minMaxWeight objectAtIndex:0] floatValue];
    yAxisTo = [[minMaxWeight objectAtIndex:1] floatValue];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //---------- Drawing vertical grid lines ----------
    CGContextSetLineWidth(context, verticalGridLinesWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    NSUInteger i;
    //NSUInteger numOfVerticalLines = (NSUInteger)((float)self.frame.size.width / (float)verticalGridLinesInterval);
    NSUInteger startDrawX = rect.origin.x / verticalGridLinesInterval;
    NSUInteger endDrawX = startDrawX + (rect.size.width / verticalGridLinesInterval);
    
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman); //specifying horizontal axis's labels
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:0.7f] CGColor]);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f));
    NSDateFormatter *dateFormatter_day = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter_day.dateFormat = @"dd";
    NSString *curXAxisLabel;
    NSDate *labelingStartDate = [NSDate dateWithTimeIntervalSince1970:[[[delegateWeight.weightData objectAtIndex:0] objectForKey:@"date"] timeIntervalSince1970] - plotXOffset*oneDay];
    NSMutableArray *monthGridIndexes = [[NSMutableArray alloc] init];
    for(i=startDrawX;i<endDrawX;i++){
        //draw one vertical grid line
        CGContextMoveToPoint(context, i*verticalGridLinesInterval, rect.origin.y);
        CGContextAddLineToPoint(context, i*verticalGridLinesInterval, rect.origin.y+rect.size.height-15.0f);
        
        /*
        //draw x-axis's label for this grid line
        if(i>0){
            curXAxisLabel = [dateFormatter_day stringFromDate:[NSDate dateWithTimeInterval:oneDay*i sinceDate:labelingStartDate]];
            CGSize labelSize = [curXAxisLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
            CGContextShowTextAtPoint(context, i*verticalGridLinesInterval-labelSize.width/2, self.frame.size.height-3,
                                     [curXAxisLabel cStringUsingEncoding:NSUTF8StringEncoding], [curXAxisLabel length]);
            
            if([curXAxisLabel isEqualToString:@"01"]){
                [monthGridIndexes addObject:[NSNumber numberWithInt:i]];
            };
        };
         */
    };
    CGContextStrokePath(context);
    
    weightGraphXAxisView.startTimeInterval = [[[delegateWeight.weightData objectAtIndex:0] objectForKey:@"date"] timeIntervalSince1970] - oneDay * plotXOffset;
    weightGraphXAxisView.numOfLabels = endDrawX - startDrawX;
    weightGraphXAxisView.step = oneDay;
    weightGraphXAxisView.verticalGridLinesInterval = verticalGridLinesInterval;
    [weightGraphXAxisView setNeedsDisplay];
    
    
    /*
    //drawing big vertical lines (month)
    CGContextSetLineWidth(context, verticalGridLinesWidth*2.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextSelectFont(context, "Helvetica", 13, kCGEncodingMacRoman); //specifying labels
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:0.7f] CGColor]);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f));
    NSDateFormatter *dateFormatter_month = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter_month.dateFormat = @"LLLL";
    NSString *curMonthLabel;
    for(NSNumber *currentMonthIndex in monthGridIndexes){
        i = [currentMonthIndex intValue];
        CGContextMoveToPoint(context, i*verticalGridLinesInterval, rect.origin.y);
        CGContextAddLineToPoint(context, i*verticalGridLinesInterval, rect.origin.y+rect.size.height-15.0f);
        
        //draw x-axis's label for this grid line
        if(i>0){
            curMonthLabel = [dateFormatter_month stringFromDate:[NSDate dateWithTimeInterval:oneDay*i sinceDate:labelingStartDate]];
            //CGSize labelSize = [curMonthLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
            NSLog(@"%@", curMonthLabel);
            CGContextShowTextAtPoint(context, i*verticalGridLinesInterval+3, self.frame.size.height-17,
                                     [curMonthLabel cStringUsingEncoding:NSISOLatin1StringEncoding], [curMonthLabel length]);
        };
    };
    CGContextStrokePath(context);
     */
    [monthGridIndexes release];
    
    
    //---------- Drawing horizontal grid lines with y-axis's labels ----------
    CGContextSetLineWidth(context, horizontalGridLinesWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    NSUInteger numOfHorizontalLines = (NSUInteger)((float)self.frame.size.height / (float)horizontalGridLinesInterval);
    for(i=0;i<numOfHorizontalLines;i++){
        CGContextMoveToPoint(context, rect.origin.x, i*horizontalGridLinesInterval);
        CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, i*horizontalGridLinesInterval);
    };
    CGContextStrokePath(context);
    
    /*
    //draw horizontal axis
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextMoveToPoint(context, 32.0f, rect.size.height - 15.0f);
    CGContextAddLineToPoint(context, rect.size.width, self.frame.size.height - 15.0f);
    CGContextStrokePath(context);
     */
    
    //draw vertical axis with labels
    weightGraphYAxisView.startWeight = yAxisFrom;
    weightGraphYAxisView.finishWeight = yAxisTo;
    weightGraphYAxisView.horizontalGridLinesInterval = horizontalGridLinesInterval;
    weightGraphYAxisView.numOfHorizontalLines = numOfHorizontalLines;
    [weightGraphYAxisView setNeedsDisplay];
    
    
    
    //---------- Drawing weight line ----------
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, weightLineWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
    
    NSDate *curDate;                     
    
    NSUInteger daysBetweenDates;
    float curWeight = [[[delegateWeight.weightData objectAtIndex:0] objectForKey:@"weight"] floatValue];
    float plotXOffsetPx = plotXOffset * verticalGridLinesInterval;
    CGPoint curPoint;
    CGContextMoveToPoint(context, plotXOffsetPx, [self convertWeightToY:curWeight]);
    for(i=1; i<[delegateWeight.weightData count];i++){
        curDate = [[delegateWeight.weightData objectAtIndex:i] objectForKey:@"date"];
        curWeight = [[[delegateWeight.weightData objectAtIndex:i] objectForKey:@"weight"] floatValue];
        daysBetweenDates = [self daysFromDate:drawPlotFromDate toDate:curDate];
        
        curPoint = CGPointMake(daysBetweenDates*verticalGridLinesInterval+plotXOffsetPx, [self convertWeightToY:curWeight]);
        CGContextAddLineToPoint(context, curPoint.x, curPoint.y);
    };
    CGContextDrawPath(context, kCGPathStroke);
    
    //---------- Drawing data-points ----------
    // Labels for data points
    CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman); //specifying horizontal axis's labels
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:0.8f] CGColor]);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f));
    //NSString *labelStr;
    
    for(i=0; i<[delegateWeight.weightData count]; i++){
        // drawing point
        curDate = [[delegateWeight.weightData objectAtIndex:i] objectForKey:@"date"];
        curWeight = [[[delegateWeight.weightData objectAtIndex:i] objectForKey:@"weight"] floatValue];
        daysBetweenDates = [self daysFromDate:drawPlotFromDate toDate:curDate];
        curPoint = CGPointMake(daysBetweenDates*verticalGridLinesInterval+plotXOffsetPx, [self convertWeightToY:curWeight]);
        CGContextAddEllipseInRect(context, CGRectMake(curPoint.x-weightPointRadius, curPoint.y-weightPointRadius, 2*weightPointRadius, 2*weightPointRadius));   //data-point
        
        /*
        // drawing label for point
        labelStr = [NSString stringWithFormat:@"%.1f", curWeight];
        CGSize labelSize = [labelStr sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10]];
        CGContextShowTextAtPoint(context, curPoint.x-labelSize.width/2, curPoint.y-5,
                                 [labelStr cStringUsingEncoding:NSUTF8StringEncoding], [labelStr length]);
         */
        
    };
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //---------- Drawing normal weight line ----------
    CGFloat normalWeight = [delegateWeight.normalWeight floatValue];
    if(normalWeight != NAN){
        CGContextSetLineWidth(context, 0.8f);
        CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
        CGFloat dashForNormLine[] = {5.0F, 5.0f};
        CGContextSetLineDash(context, 0.0f, dashForNormLine, 2);
        CGContextMoveToPoint(context, 32.0f, [self convertWeightToY:normalWeight]);
        CGContextAddLineToPoint(context, rect.size.width, [self convertWeightToY:normalWeight]);
        CGContextStrokePath(context);
    };
    
    
    //---------- Drawing aim weight line ----------
    CGFloat aimWeight = [delegateWeight.aimWeight floatValue];
    if(aimWeight != NAN){
        CGContextSetLineWidth(context, 0.8f);
        CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
        CGFloat dashForNormLine[] = {5.0F, 5.0f};
        CGContextSetLineDash(context, 0.0f, dashForNormLine, 2);
        CGContextMoveToPoint(context, 32.0f, [self convertWeightToY:aimWeight]);
        CGContextAddLineToPoint(context, rect.size.width, [self convertWeightToY:aimWeight]);
        CGContextStrokePath(context);
    };
    
    time_t endClock = clock();
    
    NSLog(@"drawRect: (%.0f, %.0f, %.0f, %.0f) - %.3f sec", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height, (float)(endClock-startClock)/CLOCKS_PER_SEC);
};

- (NSArray *)calcYRangeFromDates:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSUInteger i;
    float minWeight = 10000.0f, maxWeight = 0.0f;
    NSTimeInterval fromInterval = [fromDate timeIntervalSince1970];
    NSTimeInterval toInterval = [toDate timeIntervalSince1970];
    NSNumber *curWeight;
    for(i = 0; i<[delegateWeight.weightData count]; i++){
        if([[[delegateWeight.weightData objectAtIndex:i] objectForKey:@"date"] timeIntervalSince1970] >= fromInterval){
            curWeight = [[delegateWeight.weightData objectAtIndex:i] objectForKey:@"weight"];
            if([curWeight floatValue] < minWeight) minWeight = [curWeight floatValue];
            if([curWeight floatValue] > maxWeight) maxWeight = [curWeight floatValue];
        };
        
        if([[[delegateWeight.weightData objectAtIndex:i] objectForKey:@"date"] timeIntervalSince1970] > toInterval){
            break;
        };
    };
    
    if([delegateWeight.normalWeight floatValue] != NAN){
        if([delegateWeight.normalWeight floatValue] < minWeight) minWeight = [delegateWeight.normalWeight floatValue];
        if([delegateWeight.normalWeight floatValue] > maxWeight) maxWeight = [delegateWeight.normalWeight floatValue];
    };
    if([delegateWeight.aimWeight floatValue] != NAN){
        if([delegateWeight.aimWeight floatValue] < minWeight) minWeight = [delegateWeight.aimWeight floatValue];
        if([delegateWeight.aimWeight floatValue] > maxWeight) maxWeight = [delegateWeight.aimWeight floatValue];
    };
    
    float expandRange = (maxWeight - minWeight) * (plotYExpandFactor / 2);
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:minWeight-expandRange], [NSNumber numberWithFloat:maxWeight+expandRange], nil];
};

- (float)convertWeightToY:(float)weight{
    return self.frame.size.height - (self.frame.size.height * (weight - yAxisFrom)) / (yAxisTo - yAxisFrom);
};

- (NSUInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSTimeInterval intervalBetweenDates = [toDate timeIntervalSinceDate:fromDate];
    NSTimeInterval oneDay = 60 * 60 * 24;
    
    return intervalBetweenDates / oneDay;
};


#pragma mark - Some intercepted events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesBegan:withEvent:");
    [super touchesBegan:touches withEvent:event];
};

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesMoved:withEvent:");
    [super touchesMoved:touches withEvent:event];
};

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesEnded:withEvent:");
    [super touchesEnded:touches withEvent:event];
};

//Perform updating X-axis during zooming
- (void)setTransform:(CGAffineTransform)transform{
    //NSLog(@"scrollView.setTransform: a = %.2f, b = %.2f, c = %.2f, d = %.2f, tx = %.2f, ty = %.2f", transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
    [weightGraphXAxisView setNeedsDisplay];
    transform.d = 1.0f;
    [super setTransform:transform];
};

#pragma mark UIScrollViewDelegate's functions

// return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self;
};

// called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_2){
    //NSLog(@"Zooming begin");
};

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //NSLog(@"Zooming processed: zoom_factor = %.3f", scrollView.zoomScale);
};

// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    //NSLog(@"Zooming ended!");
};

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"Scrolling offset: %.0fx%.0f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    //[weightGraphXAxisView setNeedsDisplay];
    //weightGraphXAxisView.center = CGPointMake(-scrollView.contentOffset.x + weightGraphXAxisView.frame.size.width/2, weightGraphXAxisView.center.y);
};



@end
