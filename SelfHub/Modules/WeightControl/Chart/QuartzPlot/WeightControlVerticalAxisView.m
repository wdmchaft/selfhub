//
//  WeightControlVerticalAxisView.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlVerticalAxisView.h"

@implementation WeightControlVerticalAxisView

@synthesize startWeight, finishWeight, horizontalGridLinesInterval, numOfHorizontalLines;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(numOfHorizontalLines<2 || numOfHorizontalLines>20) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Drawing wertical axis line
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextMoveToPoint(context, 32.0f, 0.0f);
    CGContextAddLineToPoint(context, 32.0f, self.frame.size.height - 13.0f);
    CGContextStrokePath(context);
    
    
    //Labeling Axis
    CGContextSelectFont(context, "Helvetica", 14, kCGEncodingMacRoman); //specifying vertical axis's labels
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f));
    NSString *axisName = @"Kg";
    CGContextShowTextAtPoint(context, 0, 15, [axisName cStringUsingEncoding:NSUTF8StringEncoding], [axisName length]);

    
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman); //specifying vertical axis's labels
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:0.7f] CGColor]);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f));
    NSUInteger i;
    NSString *curYAxisLabel;
    float deltaWeight = (finishWeight - startWeight) / numOfHorizontalLines;
    for(i=1;i<numOfHorizontalLines;i++){
        //CGContextMoveToPoint(context, rect.origin.x, i*horizontalGridLinesInterval);
        //CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, i*horizontalGridLinesInterval);
        
        curYAxisLabel = [NSString stringWithFormat:@"%.1f", startWeight + i*deltaWeight];
        //CGSize labelSize = [curYAxisLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
        CGContextShowTextAtPoint(context, 0, self.frame.size.height - i * horizontalGridLinesInterval - 12.0f,
                                 [curYAxisLabel cStringUsingEncoding:NSUTF8StringEncoding], [curYAxisLabel length]);
    };

}

@end
