//
//  BottomPanelViewController.m
//  WannaFun
//
//  Created by Mac on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BottomPanelViewController.h"

#define STATUS_SCROLL_SPEED 0.2f
#define STATUS_CHANGE_POS_SPEED 0.5f


@implementation BottomPanelViewController

@synthesize currentViewControllerObject;
@synthesize statusFIFO, lastStatusStr, leftIcon, statusLabel, auxStatusLabel;
@synthesize button1, button2, button3, button4, button5;
@synthesize bubbleMessageNotificationView, bubbleMessageNotificationLabel;
@synthesize messageIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.bounds = CGRectMake(0, 0, 320, 70);
    }
    return self;
}

- (void)dealloc
{
    //[currentViewControllerObject release];
    [statusFIFO release];
    [lastStatusStr release];
    [leftIcon release];
    [statusLabel release];
    [auxStatusLabel release];
    [button1 release];
    [button2 release];
    [button3 release];
    [button4 release];
    [button5 release];
    [bubbleMessageNotificationView release];
    [bubbleMessageNotificationLabel release];
    [messageIcon release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isForcingMsg = NO;
    
    statusFIFO = [[NSMutableArray alloc] init];
    leftIcon.image = nil;
    
    [self setBubbleNotificationCount:0];
    lastStatusStr = @"";
    
    [self setStatus:@""];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //currentViewControllerObject = nil;
    statusFIFO = nil;
    leftIcon = nil;
    statusLabel = nil;
    auxStatusLabel = nil;
    
    button1 = nil;
    button2 = nil;
    button3 = nil;
    button4 = nil;
    button5 = nil;
    
    bubbleMessageNotificationView = nil;
    bubbleMessageNotificationLabel = nil;
    messageIcon = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)setPosition:(BottomPanelPosition)pos animated:(BOOL)isAnim{
    if(isAnim){
        [UIView beginAnimations:@"positionAnimation" context:nil];
        [UIView setAnimationDuration:STATUS_CHANGE_POS_SPEED];
        [UIView setAnimationBeginsFromCurrentState:YES];
    };
    
    switch(pos){
        case BottomPanelPositionHide:
            self.view.center = CGPointMake(160, 445+70);
            break;
        case BottomPanelPositionShort:
            self.view.center = CGPointMake(160, 445+54);
            break;
        case BottomPanelPositionFull:
            self.view.center = CGPointMake(160, 445);
            break;
        default:
            self.view.center = CGPointMake(160, 445);
            break;
    }
    
    if(isAnim){
        [UIView commitAnimations];
    };
    
    currentPosition = pos;
};

- (BottomPanelPosition)getPosition{
    return currentPosition;
};

- (void)printStatusLabelPos_test{
    NSLog(@"(%3d, %3d) (main %@ aux) (%@, %@)", (int)statusLabel.center.y, (int)auxStatusLabel.center.y, (statusLabel.center.y < auxStatusLabel.center.y ? @"выше" : @"ниже"), statusLabel.text, auxStatusLabel.text);
}
- (void)printEmptyLine{
    NSLog(@"\n");
}

- (IBAction)scrollStatus:(NSString *)status{
    lastStatusStr = status;
    
    BOOL isStatusHide;// = (statusLabel.center.y < auxStatusLabel.center.y ? YES : NO);
    
    //[self printStatusLabelPos_test];
    
    if(statusLabel.center.y > auxStatusLabel.center.y){ //statusLabel ниже auxStatusLabel
        statusLabel.center = CGPointMake(auxStatusLabel.center.x, auxStatusLabel.center.y+17);//statusLabel.frame.size.height);
        auxStatusLabel.center = CGPointMake(auxStatusLabel.center.x, auxStatusLabel.center.y+17*2);//statusLabel.frame.size.height*2);
        auxStatusLabel.text = status;
        isStatusHide = YES;
    }else{
        auxStatusLabel.center = CGPointMake(statusLabel.center.x, statusLabel.center.y+17);//statusLabel.frame.size.height);
        statusLabel.center = CGPointMake(statusLabel.center.x, statusLabel.center.y+17*2);//statusLabel.frame.size.height*2);
        statusLabel.text = status;
        isStatusHide = NO;
    };
    
    [self.view setNeedsDisplay];
    
    
    [UIView beginAnimations:@"scrollStatusAnimation" context:nil];
    [UIView setAnimationDuration:STATUS_SCROLL_SPEED];
    [UIView setAnimationBeginsFromCurrentState:NO];
    
    statusLabel.center = CGPointMake(statusLabel.center.x, statusLabel.center.y-17);//statusLabel.frame.size.height);
    statusLabel.alpha = isStatusHide ?  0.0f : 1.0f;    
    auxStatusLabel.center = CGPointMake(auxStatusLabel.center.x, auxStatusLabel.center.y-17);//auxStatusLabel.frame.size.height);
    auxStatusLabel.alpha = isStatusHide ?  1.0f : 0.0f;
    
    [UIView commitAnimations];
};

- (IBAction)setStatus:(NSString *)status{
    if([status isEqualToString:lastStatusStr]){
        return;
    };
    
    if(isForcingMsg){
        [self performSelector:@selector(setStatus:) withObject:status afterDelay:0.2f];
        return;
    };
    
    [statusFIFO addObject:status];
    
    while ([statusFIFO count]>0) {
        [self scrollStatus:[statusFIFO objectAtIndex:0]];
        [statusFIFO removeObjectAtIndex:0];
    }
    
    [self scrollStatus:status];
};

- (IBAction)setStatus:(NSString *)status forceForTime:(float)sec{
    if([status isEqualToString:lastStatusStr]){
        return;
    };
    
    isForcingMsg = YES;
    
    [statusFIFO addObject:status];
    
    while ([statusFIFO count]>0) {
        [self scrollStatus:[statusFIFO objectAtIndex:0]];
        [statusFIFO removeObjectAtIndex:0];
    }
    
    [self scrollStatus:status];
    [self performSelector:@selector(flushForceMsgFlag) withObject:nil afterDelay:sec];
}

- (IBAction)flushForceMsgFlag{
    isForcingMsg = NO;
}

- (IBAction)setOnlineBall:(BOOL)isOnline{
    leftIcon.image = [UIImage imageNamed:(isOnline==YES ? @"bottomPanel_redball.png" : @"bottomPanel_greenball.png")];
};

- (void)setBubbleNotificationCount:(NSUInteger)messageCount{
    bubbleNotificationCount = messageCount;
    //[bubbleMessageNotificationLabel changeFontSize:(messageCount>99 ? 12.0f : 16.0f)];
    bubbleMessageNotificationLabel.text = [NSString stringWithFormat:@"%d", bubbleNotificationCount];
    [bubbleMessageNotificationView setHidden:(bubbleNotificationCount==0 ? YES : NO)];
    [messageIcon setHidden:(bubbleNotificationCount==0 ? YES : NO)];
};

- (NSUInteger)getBubbleNotificationCount{
    return bubbleNotificationCount;
};

- (void)bubbleNotificationCountIncrement{
    [self setBubbleNotificationCount:bubbleNotificationCount+1];
}

- (void)bubbleNotificationCountDecrement{
    [self setBubbleNotificationCount:bubbleNotificationCount-1];
};


- (IBAction)pressTab1Handler:(id)sender{
    [currentViewControllerObject pressTab1:sender];
};
- (IBAction)pressTab2Handler:(id)sender{
    [currentViewControllerObject pressTab2:sender];
};
- (IBAction)pressTab3Handler:(id)sender{
    [currentViewControllerObject pressTab3:sender];
};
- (IBAction)pressTab4Handler:(id)sender{
    [currentViewControllerObject pressTab4:sender];
};
- (IBAction)pressTab5Handler:(id)sender{
    [currentViewControllerObject pressTab5:sender];
};

@end
