//
//  WeightControlVerticalAxisView.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 15.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightControlVerticalAxisView : UIView {
    float startWeight;
    float finishWeight;
    float horizontalGridLinesInterval;
    NSUInteger numOfHorizontalLines;
}

@property (nonatomic) float startWeight;
@property (nonatomic) float finishWeight;
@property (nonatomic) float horizontalGridLinesInterval;
@property (nonatomic) NSUInteger numOfHorizontalLines;

@end
