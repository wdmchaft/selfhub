//
//  MainInformation.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleGlobalDefinitions.h"

@protocol ModuleProtocol;


@interface MainInformation : UIViewController <ModuleProtocol>{
    
};

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
