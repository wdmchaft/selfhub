//
//  WeightControlGraphView.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 28.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlGraphView.h"

#define NORMAL_DAY_WIDTH 54.0f

@implementation WeightControlGraphView

NSString *const kWeightLine	 = @"Data Line";
NSString *const kNormalLine	 = @"Normal Line";
NSString *const kAimLine	 = @"Aim Line";

@synthesize delegate, hostingView, fromDateGraph, toDateGraph, scaleFactor, scaleView;

- (id)init{
    self = [super init];
    if (self) {
    }
    
    return self;
};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc{
    if(hostingView){
        [hostingView release];
    };
    
    [super dealloc];
};

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)getIntegerDateComponent:(NSDate *)date byFormat:(NSString *)format{
    NSString *result;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    result = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return [result integerValue];
}

- (void)createGraphLayer{
    if(hostingView) [hostingView release];
    
    if(graphScrollView){
        [graphScrollView removeFromSuperview];
        [graphScrollView release];
        graphScrollView = nil;
    };
    graphScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    graphScrollView.contentSize = CGSizeMake(500.0f, self.bounds.size.height);
    graphScrollView.scrollEnabled = YES;
    //[self addSubview:graphScrollView];
    
    hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 9000.0f, self.bounds.size.height)/*self.bounds*/];
    
    CPTGraph *graph = [[[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 9000.0f, self.bounds.size.height)/*self.bounds*/] autorelease];
    hostingView.hostedGraph = graph;
    
    
    graph.plotAreaFrame.paddingTop	  = 10.0;
    graph.plotAreaFrame.paddingRight  = 0.0;
    graph.plotAreaFrame.paddingBottom = 30.0;
    graph.plotAreaFrame.paddingLeft	  = 25.0;
    
    //[self addSubview:hostingView];
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.8];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.5];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = NO; //YES;
    plotSpace.delegate = self;
    //[plotSpace setScaleType:CPTScaleTypeDateTime forCoordinate:CPTCoordinateX];
    
    // Text styles
	CPTMutableTextStyle *xAxisTitleTextStyle = [CPTMutableTextStyle textStyle];
	xAxisTitleTextStyle.fontName = @"Helvetica-Bold";
	xAxisTitleTextStyle.fontSize = 12.0;
    xAxisTitleTextStyle.color = [CPTColor blackColor];
    CPTMutableTextStyle *xAxisLabelTextStyle = [CPTMutableTextStyle textStyle];
	xAxisLabelTextStyle.fontName = @"Helvetica";
	xAxisLabelTextStyle.fontSize = 10.0;
    xAxisLabelTextStyle.color = [CPTColor grayColor];
    
    //Label Formatters
    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    labelFormatter.maximumFractionDigits = 1;
    
    // !!!!!!!!!!!! X axis !!!!!!!!!!!!!!
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x		  = axisSet.xAxis;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    //x.majorIntervalLength = CPTDecimalFromFloat(oneDay);
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.tickDirection = CPTSignNone;
    x.labelingPolicy	 = CPTAxisLabelingPolicyLocationsProvided;
    
    x.labelOffset = 10;
    x.labelTextStyle = xAxisLabelTextStyle;
    x.labelAlignment = CPTAlignmentLeft;
    x.minorTickLabelOffset = 0;
    x.minorTickLabelTextStyle = xAxisLabelTextStyle;
    
    
    // X-axis line
    CPTMutableLineStyle *xAxisLineStyle = [CPTMutableLineStyle lineStyle];
	xAxisLineStyle.lineWidth = 1.0;
    x.axisLineStyle = xAxisLineStyle;
    // X-Axis arrow  
    CPTLineCap *xAxisCap = [[CPTLineCap alloc] init];
    xAxisCap.lineStyle = x.axisLineStyle;
    xAxisCap.lineCapType = CPTLineCapTypeSolidArrow;
    xAxisCap.size = CGSizeMake(5.0, 15.0);
    xAxisCap.fill = [CPTFill fillWithColor:x.axisLineStyle.lineColor];
    x.axisLineCapMax = xAxisCap;
    [xAxisCap release];
    
    // X-axis title
    x.title = @"date";
    x.titleTextStyle = xAxisTitleTextStyle;
    x.titleOffset = 12.0;
    
    // !!!!!!!!!!!! Y axis !!!!!!!!!!!!!!
    CPTXYAxis *y = axisSet.yAxis;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:5.0f];
    y.labelingPolicy	 = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle = minorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.labelFormatter	 = labelFormatter;
    y.title		  = @"weight";
    y.titleOffset = 0.0;
    y.tickDirection = CPTSignNone;
    
    
    // Y-axis line
    CPTMutableLineStyle *yAxisLineStyle = [CPTMutableLineStyle lineStyle];
	yAxisLineStyle.lineWidth = 1.0;
    y.axisLineStyle = xAxisLineStyle;
    
    // Y-axis arrow  
    CPTLineCap *yAxisCap = [[CPTLineCap alloc] init];
    yAxisCap.lineStyle = x.axisLineStyle;
    yAxisCap.lineCapType = CPTLineCapTypeSolidArrow;
    yAxisCap.size = CGSizeMake(5.0, 15.0);
    yAxisCap.fill = [CPTFill fillWithColor:y.axisLineStyle.lineColor];
    y.axisLineCapMax = yAxisCap;
    [yAxisCap release];
    
    // Y-axis text styles
	CPTMutableTextStyle *yAxisTitleTextStyle = [CPTMutableTextStyle textStyle];
	yAxisTitleTextStyle.fontName = @"Helvetica-Bold";
	yAxisTitleTextStyle.fontSize = 12.0;
    yAxisTitleTextStyle.color = [CPTColor blackColor];
    CPTMutableTextStyle *yAxisLabelTextStyle = [CPTMutableTextStyle textStyle];
	yAxisLabelTextStyle.fontName = @"Helvetica";
	yAxisLabelTextStyle.fontSize = 10.0;
    yAxisLabelTextStyle.color = [CPTColor grayColor];
    
    // Y-axis title
    y.title = @"Kg";
    y.titleTextStyle = yAxisTitleTextStyle;
    y.titleOffset = 6.0;
    //y.titleLocation = CPTDecimalFromInt(110);
    
    // Y-axis labels
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.labelFormatter = labelFormatter;
    y.labelTextStyle = yAxisLabelTextStyle;
    y.minorTickLabelFormatter = labelFormatter;
    y.minorTickLabelTextStyle = yAxisLabelTextStyle;
    
    
    
    // Setting graph lines
    // Ideal weight line
	CPTScatterPlot *normalLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
	normalLinePlot.identifier = kNormalLine;
	CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.lineWidth = 1.0;
	lineStyle.lineColor = [CPTColor blueColor];
	lineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInteger:10], [NSNumber numberWithInteger:6], nil];
	normalLinePlot.dataLineStyle = lineStyle;
	normalLinePlot.dataSource = self;
	[graph addPlot:normalLinePlot];
    
    // Setup a style for the annotation
	CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
	hitAnnotationTextStyle.color	= [CPTColor blueColor];
	hitAnnotationTextStyle.fontSize = 10.0f;
	hitAnnotationTextStyle.fontName = @"Helvetica";
	// Determine point of annotation @"norm" in plot coordinates
	NSArray *anchorPoint = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
	// Add annotation
	NSString *normAnnotationString = @"norm";
	CPTTextLayer *textLayer = [[[CPTTextLayer alloc] initWithText:normAnnotationString style:hitAnnotationTextStyle] autorelease];
	normLineAnnotation			  = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:normalLinePlot.plotSpace anchorPlotPoint:anchorPoint];
	normLineAnnotation.contentLayer = textLayer;
	normLineAnnotation.displacement = CGPointMake(14.0f, 5.0f);
    [graph.plotAreaFrame.plotArea addAnnotation:normLineAnnotation];
    [normLineAnnotation release];
    
    
    
    
    // Data line
	CPTScatterPlot *linePlot = [[[CPTScatterPlot alloc] init] autorelease];
    linePlot.identifier = kWeightLine;
	lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.lineWidth			 = 1.5;
	lineStyle.lineColor			 = [CPTColor orangeColor];
	linePlot.dataLineStyle = lineStyle;
    
	linePlot.dataSource = self;
	[graph addPlot:linePlot];
    
    // Add plot symbols
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor orangeColor];
	CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill		 = [CPTFill fillWithColor:[CPTColor orangeColor]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size		 = CGSizeMake(5.0, 5.0);
	linePlot.plotSymbol	 = plotSymbol;
    
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    
    NSDate *fromDate = [[delegate.weightData objectAtIndex:0] objectForKey:@"date"];
    NSDate *toDate = [NSDate date];
    NSUInteger daysBetweenDates = (NSUInteger)([toDate timeIntervalSinceDate:fromDate] / oneDay);
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat([toDate timeIntervalSinceDate:fromDate] + oneDay*7)];
    graph.frame = CGRectMake(graph.frame.origin.x, graph.frame.origin.y, daysBetweenDates*NORMAL_DAY_WIDTH, graph.frame.size.height);
    graphScrollView.contentSize = CGSizeMake(daysBetweenDates*NORMAL_DAY_WIDTH, graph.frame.size.height);
    scaleFactor = 1.0f;
    //x.titleLocation = CPTDecimalFromFloat([toDate timeIntervalSinceDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"]] - oneDay);
    [self updateGraphLabels];

    
    
    [graphScrollView addSubview:hostingView];   //Scroll content adding
    [self addSubview:graphScrollView];
    
    //Simple variant
    //[self addSubview:hostingView];

    [self updatePlotRanges];
    
    
    //NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:(oneDay * -7)];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - (oneDay * 10))];
    //NSDate *startDate = [[delegate.weightData objectAtIndex:15] objectForKey:@"date"];
    //NSDate *startDate = [NSDate date];
    [self showDateAtBegin:startDate];
    
    
    //Adding Gesture Recognizers
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureSelector:)];
    [self addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    [self bringSubviewToFront:scaleView];
};

- (void)updatePlotRanges{
    NSTimeInterval oneDay = 24 * 60 * 60;
    CPTGraph *graph = hostingView.hostedGraph;
    
    // Initializing ranges variables
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    CPTMutablePlotRange *xRange = [[[CPTMutablePlotRange alloc] init] autorelease];
    CPTMutablePlotRange *yRange = [[[CPTMutablePlotRange alloc] init] autorelease];
    
    //Setting x-axis range (expanded by 1 mounth)
    xRange.location = CPTDecimalFromFloat(0.0f - oneDay*3);
    xRange.length = CPTDecimalFromFloat([[[delegate.weightData lastObject] objectForKey:@"date"] timeIntervalSinceDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"]] + oneDay * 30);
    
    
    //Setting y-axis range (expanded by factor 1.5f)
    float minWeight = INFINITY;
    float maxWeight = 0.0f;
    float curWeight;
    for(NSDictionary *oneRec in delegate.weightData){
        curWeight = [[oneRec objectForKey:@"weight"] floatValue];
        if(curWeight < minWeight) minWeight = curWeight;
        if(curWeight > maxWeight) maxWeight = curWeight;
    };
    float yRangeLocation = minWeight;
    float yRangeLength = maxWeight - minWeight;
    float deltaYRange = yRangeLocation - [delegate.normalWeight floatValue];
    if(deltaYRange > 0){
        yRangeLocation -= deltaYRange;
        yRangeLength += deltaYRange;
    };
    deltaYRange = (yRangeLocation + yRangeLength) - [delegate.normalWeight floatValue];
    if(deltaYRange < 0){
        yRangeLength -= deltaYRange;
    };
    yRangeLocation -= (yRangeLength*0.5)/2;
    yRangeLength += (yRangeLength*0.5);
    if(yRangeLocation<0) yRangeLocation = 0.0f;
    
    yRange.location = CPTDecimalFromFloat(yRangeLocation);
    yRange.length = CPTDecimalFromFloat(yRangeLength);
    
    
    //Setting graph ranges
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    CPTXYAxis *y = axisSet.yAxis;
    
    x.gridLinesRange = yRange;//[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(200)];
	y.gridLinesRange = xRange;
    
	//plotSpace.xRange = xRange;
	plotSpace.yRange = yRange;
    
    y.titleLocation = yRange.end;
    x.titleLocation = xRange.end;
    
    
    //Creating new minor&major tick locations
    // X-axis minor and major locations
    NSMutableSet *minorTickLocations = [NSMutableSet set];
    NSMutableSet *majorTickLocations = [NSMutableSet set];
    NSUInteger tickLength = 1;
    int i;
    int curMonth = [self getIntegerDateComponent:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"] byFormat:@"MM"];
    NSUInteger totalDays = [[[delegate.weightData lastObject] objectForKey:@"date"] timeIntervalSinceDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"]] / oneDay;
    totalDays += 30;
	for (i=-3; i <= (int)(totalDays-3); i ++ ) {
        //NSTimeInterval curInt = oneDay*i;
        NSTimeInterval realDateInterval = [[[delegate.weightData objectAtIndex:0] objectForKey:@"date"] timeIntervalSince1970] + oneDay*i;
        NSDate *realDate = [NSDate dateWithTimeIntervalSince1970:realDateInterval];
        //NSLog(@"Real day: %d", [self getIntegerDateComponent:realDate byFormat:@"dd"]);
		if([self getIntegerDateComponent:realDate byFormat:@"dd"] % tickLength == 0){
            [minorTickLocations addObject:[NSDecimalNumber numberWithFloat:oneDay*i]];
        }
        
        if([self getIntegerDateComponent:realDate byFormat:@"MM"] != curMonth){
            [majorTickLocations addObject:[NSDecimalNumber numberWithFloat:oneDay*i]];
            curMonth = [self getIntegerDateComponent:realDate byFormat:@"MM"];
        };
	};
    x.minorTickLocations = minorTickLocations;
    x.majorTickLocations = majorTickLocations;
    
    //Saving current ranges for correct scaling and dragging
    if(dataRangeX) [dataRangeX release];
    if(dataRangeY) [dataRangeY release];
    dataRangeX = [xRange retain];
    dataRangeY = [yRange retain];
};

- (void)updateGraphLabels{
    // Initializing ranges variables
    NSTimeInterval oneDay = 24 * 60 * 60;
    CPTGraph *graph = hostingView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    CPTPlotRange *xRange = plotSpace.xRange;
    CPTPlotRange *yRange = plotSpace.yRange;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    CPTXYAxis *y = axisSet.yAxis;
    
    //Label Formatters
    NSNumberFormatter *labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    labelFormatter.maximumFractionDigits = 1;
    
    NSDateFormatter *dateFormatter_day = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter_day.dateFormat = @"dd";
	CPTTimeFormatter *timeFormatter_day = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter_day] autorelease];
	timeFormatter_day.referenceDate = [[delegate.weightData objectAtIndex:0] objectForKey:@"date"];
    
    NSDateFormatter *dateFormatter_mounth = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter_mounth.dateFormat = @"MMM''yy";
	CPTTimeFormatter *timeFormatter_mounth = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter_mounth] autorelease];
	timeFormatter_mounth.referenceDate = [[delegate.weightData objectAtIndex:0] objectForKey:@"date"];
    
    NSDateFormatter *dateFormatter_void = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter_mounth.dateFormat = @"MMM''yy";
	CPTTimeFormatter *timeFormatter_void = [[[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter_void] autorelease];
	timeFormatter_mounth.referenceDate = [[delegate.weightData objectAtIndex:0] objectForKey:@"date"];
    
    NSUInteger daysBetweenDates = xRange.lengthDouble / oneDay;
    if(scaleFactor<=2.0f && scaleFactor>=0.5f){
        x.minorTickLabelFormatter = timeFormatter_day;
        x.labelFormatter = timeFormatter_mounth;
        x.labelOffset = 10.0f;
    }else if(daysBetweenDates>21){
        x.minorTickLabelFormatter = timeFormatter_void;
        x.labelFormatter = timeFormatter_mounth;
        x.labelOffset = 0.0f;
    };
    
    //Show points labels (if required)
    CPTMutableTextStyle *pointLabelStyle = [CPTMutableTextStyle textStyle];
	pointLabelStyle.color	 = [CPTColor grayColor];
	pointLabelStyle.fontSize	 = 10.0;
    if(scaleFactor<=2.0f && scaleFactor>=0.5f){
        [graph plotWithIdentifier:kWeightLine].labelTextStyle = pointLabelStyle;
    }else{
        [graph plotWithIdentifier:kWeightLine].labelTextStyle = nil;
    };
    

    double titleOffsetPlace = ((double)daysBetweenDates * (25.0f / 250.0f)) / 2.0f;
    x.titleLocation = CPTDecimalFromDouble(xRange.locationDouble + xRange.lengthDouble - oneDay*titleOffsetPlace);
    y.titleLocation = CPTDecimalFromDouble(yRange.locationDouble + yRange.lengthDouble*0.95f);
    
    
    NSNumber *anchorX = [NSNumber numberWithFloat:(xRange.locationDouble>=0 ? xRange.locationDouble : 0) + oneDay*titleOffsetPlace/2];
	NSNumber *anchorY = [NSNumber numberWithFloat:[delegate.normalWeight floatValue]];
	NSArray *anchorPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    normLineAnnotation.anchorPlotPoint = anchorPoint;
    

    
    
    
    //if(daysBetweenDates>=150){
    //    tickLength = INT32_MAX;
    //};
    //if(daysBetweenDates<=31 && [self getIntegerDateComponent:fromDate byFormat:@"MM"] == [self getIntegerDateComponent:toDate byFormat:@"MM"]){
    //    [majorTickLocations addObject:[NSDecimalNumber numberWithFloat:startTimeInterval]];
    //}

    
};


- (void)showLastWeekGraph{
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *nowDate = [NSDate date];
    NSDate *lastWeekDate = [NSDate dateWithTimeIntervalSince1970:[nowDate timeIntervalSince1970] - oneDay*7];
    [self showGraphFromDate:lastWeekDate toDate:nowDate];
    
};

- (void)showFullGraph{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setMonth:3];
	[dateComponents setDay:25];
	[dateComponents setYear:2012];
	[dateComponents setHour:12];
	[dateComponents setMinute:0];
	[dateComponents setSecond:0];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *refDate = [gregorian dateFromComponents:dateComponents];
    [dateComponents release];
	[gregorian release];

    [self showGraphFromDate:refDate toDate:[[delegate.weightData lastObject] objectForKey:@"date"]];
    
    //[self showGraphFromDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"] toDate:[[delegate.weightData lastObject] objectForKey:@"date"]];
};

- (void)showGraphFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    // Calcing number of days between dates
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSUInteger daysBetweenDates = (NSUInteger)([toDate timeIntervalSinceDate:fromDate] / oneDay);
    //NSLog(@"Days between two dates: %d", daysBetweenDates);
    
    if([fromDate timeIntervalSince1970] >= [toDate timeIntervalSince1970]) return;
    
    if(fromDateGraph) [fromDateGraph release];
    if(toDateGraph) [toDateGraph release];
    fromDateGraph = [fromDate retain];
    toDateGraph = [toDate retain];
    
    CPTGraph *graph = hostingView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x		  = axisSet.xAxis;

    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([fromDate timeIntervalSinceDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"]]) length:CPTDecimalFromFloat([toDate timeIntervalSinceDate:fromDate])];
    x.titleLocation = CPTDecimalFromFloat([toDate timeIntervalSinceDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"]] - oneDay);
    
    [self updateGraphLabels];
};

- (void)setGraphWidth:(CGFloat)graphWidth{
    CGRect curRect = hostingView.hostedGraph.frame;
    scaleFactor = scaleFactor * (graphWidth / curRect.size.width);
    hostingView.hostedGraph.frame = CGRectMake(curRect.origin.x, curRect.origin.y, graphWidth, curRect.size.height);
    graphScrollView.contentSize = CGSizeMake(graphWidth, curRect.size.height);
    [self updatePlotRanges];
};

- (void)setScaleFactor:(CGFloat)newScaleFactor{
    CGRect curRect = hostingView.hostedGraph.frame;
    CGFloat graphWidth = fabs(curRect.size.width * (newScaleFactor / scaleFactor));
    scaleFactor = fabs(newScaleFactor);
    hostingView.hostedGraph.frame = CGRectMake(curRect.origin.x, curRect.origin.y, graphWidth, curRect.size.height);
    graphScrollView.contentSize = CGSizeMake(graphWidth, curRect.size.height);
    [self updateGraphLabels];
};

- (void)showDateAtBegin:(NSDate *)showingDate{
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSUInteger daysBetweenDates = (NSUInteger)([showingDate timeIntervalSinceDate:[[delegate.weightData objectAtIndex:0] objectForKey:@"date"]] / oneDay);
    
    float offset = scaleFactor * NORMAL_DAY_WIDTH * daysBetweenDates;
    [graphScrollView setContentOffset:CGPointMake(offset, 0) animated:NO];
    
};

- (void)showScaleView{
    [UIView animateWithDuration:0.5f animations:^(void){
        scaleView.alpha = 1.0f; 
    }];
};

- (void)hideScaleView{
    [UIView animateWithDuration:0.5f animations:^(void){
        scaleView.alpha = 0.0f; 
    }];
};

- (void)hideScaleViewTimerSelector:(NSTimer *)timer{
    [self hideScaleView];
    
    [timer invalidate];
    scaleHideTimer = nil;
}

- (IBAction)pressScaleButton:(id)sender{
    [self tapGestureSelector:nil];
    
    NSInteger tagScale = [sender tag];
    //NSLog(@"WeightControlGraphView: scaleButtonPressed - tag = %d", tagScale);
    
    NSDate *fromDate = [[delegate.weightData objectAtIndex:0] objectForKey:@"date"];
    NSDate *toDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSUInteger daysBetweenDates = (NSUInteger)([toDate timeIntervalSinceDate:fromDate] / oneDay) + 7;
    CGFloat newScaleFactor = 1.0f;
    
    CGFloat minScaleFactor = (self.frame.size.width + 60) / (daysBetweenDates * NORMAL_DAY_WIDTH);
    
    
    switch(tagScale){
        case 1:
            newScaleFactor = 1.0f;
            break;
        case 2:
            newScaleFactor = 1.0f / 2.0f;
            break;
        case 3:
            newScaleFactor = 1.0f / 4.0f;
            break;
        case 4:
            newScaleFactor = 1.0f / 8.0f;
            break;
        case 5:
            newScaleFactor = 1.0f / 26.0f;
            break;
    };
    
    if(newScaleFactor < minScaleFactor){
        newScaleFactor = minScaleFactor;
    };
    NSLog(@"Scaling factor: old (%.3f), new (%.3f), min (%.3f). Days Between Dates: %d", scaleFactor, newScaleFactor, minScaleFactor, daysBetweenDates);
    
    [self setScaleFactor:newScaleFactor];
};

#pragma mark - CPTPlotDataSource delegate's functions

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return [delegate.weightData count];
};


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    //return [NSNumber numberWithFloat:
    NSDate *curDate;
    NSTimeInterval timeInt;
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            curDate = [[delegate.weightData objectAtIndex:index] objectForKey:@"date"];
            timeInt = [curDate timeIntervalSince1970] - [[[delegate.weightData objectAtIndex:0] objectForKey:@"date"] timeIntervalSince1970];
            
            if(plot.identifier==kWeightLine){
                return [[[NSNumber alloc] initWithFloat:timeInt] autorelease];
                //NSLog(@"X-point: %.0f", timeInt);
            }else{
                return [[[NSNumber alloc] initWithFloat:timeInt] autorelease];
            }
            
            break;
            
        case CPTScatterPlotFieldY:
            if(plot.identifier==kWeightLine){
                return [[[NSNumber alloc] initWithDouble:[[[delegate.weightData objectAtIndex:index] objectForKey:@"weight"] doubleValue]] autorelease];
            }else if(plot.identifier==kNormalLine){
                return [[[NSNumber alloc] initWithFloat:[delegate.normalWeight floatValue]] autorelease];
                //NSLog(@"Normal for index %d: %.0f", index, [result floatValue]);
            }else if(plot.identifier==kAimLine){
                return [[[NSNumber alloc] initWithFloat:[delegate.aimWeight floatValue]] autorelease];
            };
            return nil;
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - CPTPlotSpaceDelegate functions


-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    //NSLog(@"willChangePlotRangeTo: %@", coordinate==CPTCoordinateX ? @"X-axis" : @"Y-axis");
	// Impose a limit on how far user can scroll in x
    //NSDate *firstDate = [[delegate.weightData objectAtIndex:0] objectForKey:@"date"];
    //NSDate *lastDate = [[delegate.weightData lastObject] objectForKey:@"date"];
    //NSTimeInterval oneDay = 60 * 60 *24;
	if ( coordinate == CPTCoordinateX ) {
        CPTMutablePlotRange *changedRange = [[newRange mutableCopy] autorelease];
		[changedRange shiftEndToFitInRange:dataRangeX];
		[changedRange shiftLocationToFitInRange:dataRangeX];
		newRange = changedRange;
	};
    
    if (coordinate == CPTCoordinateY){
        newRange = [(CPTXYPlotSpace *)space yRange];
    }
    
	return newRange;
}

-(void)plotSpace:(CPTPlotSpace *)space didChangePlotRangeForCoordinate:(CPTCoordinate)coordinate{
    /*CPTXYPlotSpace *xySpace = (CPTXYPlotSpace *)space;
    if(coordinate == CPTCoordinateX){
        NSLog(@"didChangePlotRangeForCoordinate: <X-axis> (%.0f, %.0f)", xySpace.xRange.locationDouble, xySpace.xRange.lengthDouble);
    }else{
        NSLog(@"didChangePlotRangeForCoordinate: <Y-axis> (%.0f, %.0f)", xySpace.yRange.locationDouble, xySpace.yRange.lengthDouble);
    }*/
    
    // !!! Maintain X-axis relabeling !!!
    [self updateGraphLabels];
};

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint{
    //NSLog(@"shouldScaleBy:(%.3f) aboutPoint:(%.0fx%.0f)", interactionScale, interactionPoint.x, interactionPoint.y);
    
    //CPTXYAxisSet *graphAxisSet = (CPTXYAxisSet *)space.graph.axisSet;
    //CPTXYAxis *x = graphAxisSet.xAxis;
    //CPTXYAxis *y = graphAxisSet.yAxis;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)space;
    //double xRangeLocation = plotSpace.xRange.locationDouble;
    //double xRangeLength = plotSpace.xRange.lengthDouble;
    
    // Determine point in plot coordinates
	NSDecimal const decimalScale = CPTDecimalFromCGFloat(interactionScale);
	NSDecimal plotInteractionPoint[2];    
	[plotSpace plotPoint:plotInteractionPoint forPlotAreaViewPoint:interactionPoint];
    
	// Cache old ranges
	CPTPlotRange *oldRangeX = plotSpace.xRange;
	CPTPlotRange *oldRangeY = plotSpace.yRange;
    
	// Lengths are scaled by the pinch gesture inverse proportional
	//NSDecimal newLengthX = CPTDecimalDivide(oldRangeX.length, decimalScale);
	//NSDecimal newLengthY = CPTDecimalDivide(oldRangeY.length, decimalScale);
    
	// New locations
	NSDecimal newLocationX;
	if ( CPTDecimalGreaterThanOrEqualTo( oldRangeX.length, CPTDecimalFromInteger(0) ) ) {
		NSDecimal oldFirstLengthX = CPTDecimalSubtract(plotInteractionPoint[CPTCoordinateX], oldRangeX.minLimit); // x - minX
		NSDecimal newFirstLengthX = CPTDecimalDivide(oldFirstLengthX, decimalScale);                              // (x - minX) / scale
		newLocationX = CPTDecimalSubtract(plotInteractionPoint[CPTCoordinateX], newFirstLengthX);
	}
	else {
		NSDecimal oldSecondLengthX = CPTDecimalSubtract(oldRangeX.maxLimit, plotInteractionPoint[0]); // maxX - x
		NSDecimal newSecondLengthX = CPTDecimalDivide(oldSecondLengthX, decimalScale);                // (maxX - x) / scale
		newLocationX = CPTDecimalAdd(plotInteractionPoint[CPTCoordinateX], newSecondLengthX);
	}
    
	NSDecimal newLocationY;
	if ( CPTDecimalGreaterThanOrEqualTo( oldRangeY.length, CPTDecimalFromInteger(0) ) ) {
		NSDecimal oldFirstLengthY = CPTDecimalSubtract(plotInteractionPoint[CPTCoordinateY], oldRangeY.minLimit); // y - minY
		NSDecimal newFirstLengthY = CPTDecimalDivide(oldFirstLengthY, decimalScale);                              // (y - minY) / scale
		newLocationY = CPTDecimalSubtract(plotInteractionPoint[CPTCoordinateY], newFirstLengthY);
	}
	else {
		NSDecimal oldSecondLengthY = CPTDecimalSubtract(oldRangeY.maxLimit, plotInteractionPoint[1]); // maxY - y
		NSDecimal newSecondLengthY = CPTDecimalDivide(oldSecondLengthY, decimalScale);                // (maxY - y) / scale
		newLocationY = CPTDecimalAdd(plotInteractionPoint[CPTCoordinateY], newSecondLengthY);
	}
    
    
    if(CPTDecimalLessThanOrEqualTo(newLocationX, CPTDecimalFromInt(-60*60*24*3))){
        //NSDecimalNumber *tmpNum = [NSDecimalNumber decimalNumberWithDecimal:newLocationX];
        //NSLog(@"Rejecting scale: newLoc = %.0f, x.ragne.loc = %.0f", [tmpNum floatValue], );
        return NO;
    }
    
    //NSDecimalNumber *tmpNum = [NSDecimalNumber decimalNumberWithDecimal:newLocationX];
    //NSLog(@"Rejecting scale: newLoc = %.0f, x.gridLinesRange.location = %.0f", [tmpNum stringValue]);

    
    
    
    //NSLog(@"shouldScaleBy:(%.3f) aboutPoint:(%.0fx%.0f) | x.visibleRange (%.2f, %.2f)", interactionScale, interactionPoint.x, interactionPoint.y, plotSpace.xRange.locationDouble, plotSpace.xRange.lengthDouble);
    
    return YES;
};


#pragma mark Native Gesture Selectors

- (IBAction)pinchGestureSelector:(UIPinchGestureRecognizer *)sender{
    NSLog(@"pinchGestureScale: %.0f", sender.scale);
};

- (IBAction)tapGestureSelector:(UITapGestureRecognizer *)sender{
    //NSLog(@"Tapping!");
    
    if(scaleView.alpha==0.0f){
        [self showScaleView];
    };
    
    if(scaleHideTimer){
        [scaleHideTimer invalidate];
    };
    scaleHideTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideScaleViewTimerSelector:) userInfo:nil repeats:NO];
    [self bringSubviewToFront:scaleView];
    [scaleView becomeFirstResponder];
    
    //[self performSelector:@selector(hideScaleView) withObject:nil afterDelay:5.0f];
};


@end
