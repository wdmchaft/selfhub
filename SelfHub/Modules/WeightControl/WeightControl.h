//
//  WeightControl.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"
#import "WeightControlGraphView.h"

@class WeightControlGraphView;

@interface WeightControl : UIViewController <ModuleProtocol>{
    NSMutableArray *weightData;
    NSNumber *aimWeight;
    NSNumber *normalWeight;
};

@property (nonatomic, assign) id <ServerProtocol> delegate;
@property (nonatomic, retain) IBOutlet WeightControlGraphView *weightGraph;

@property (nonatomic, retain) NSMutableArray *weightData;
@property (nonatomic, retain) NSNumber *aimWeight;
@property (nonatomic, retain) NSNumber *normalWeight;

- (void)fillTestData:(NSUInteger)numOfElements;

- (void)generateNormalWeight;

- (IBAction)fitAll:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)moveRight:(id)sender;
- (IBAction)moveLeft:(id)sender;

@end
