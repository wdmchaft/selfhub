//
//  BottomPanelViewController.h
//  WannaFun
//
//  Created by Mac on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LabelMyriad.h"
//#import "NetEngineClient.h"

//@class NetEngineClient;

@class BottomPanelViewController;

typedef enum{
    BottomPanelPositionHide = 0,
    BottomPanelPositionShort,
    BottomPanelPositionFull
}BottomPanelPosition;

@protocol BottomPanelDelegate
@optional
- (IBAction)pressTab1:(id)sender;
- (IBAction)pressTab2:(id)sender;
- (IBAction)pressTab3:(id)sender;
- (IBAction)pressTab4:(id)sender;
- (IBAction)pressTab5:(id)sender;
@end

@protocol SimpleBottomPanelSetter
@optional
- (BottomPanelViewController *)getBottomPanel;
- (IBAction)setStatusPanelText:(NSString *)text;
- (IBAction)setStatusPanelPosition:(BottomPanelPosition)position animated:(BOOL)anim;
- (IBAction)setStatusPanelPosition:(BottomPanelPosition)position andText:(NSString *)text animated:(BOOL)anim;
@end;


@interface BottomPanelViewController : UIViewController{
    UIViewController<BottomPanelDelegate> *currentViewControllerObject;
    BottomPanelPosition currentPosition;
    
    NSMutableArray *statusFIFO;
    NSString *lastStatusStr;
    NSUInteger bubbleNotificationCount;
    BOOL isForcingMsg;
}

@property (nonatomic, assign) UIViewController<BottomPanelDelegate> *currentViewControllerObject;
@property (nonatomic, retain) IBOutlet UIImageView *leftIcon;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *auxStatusLabel;

@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet UIButton *button3;
@property (nonatomic, retain) IBOutlet UIButton *button4;
@property (nonatomic, retain) IBOutlet UIButton *button5;

@property (nonatomic, retain) IBOutlet UIView *bubbleMessageNotificationView;
@property (nonatomic, retain) IBOutlet UILabel *bubbleMessageNotificationLabel;
@property (nonatomic, retain) IBOutlet UIImageView *messageIcon;

@property (nonatomic, retain) NSMutableArray *statusFIFO;
@property (nonatomic, retain) NSString *lastStatusStr;


- (IBAction)setPosition:(BottomPanelPosition)pos animated:(BOOL)isAnim;
- (BottomPanelPosition)getPosition;
- (IBAction)scrollStatus:(NSString *)status;
- (IBAction)setStatus:(NSString *)status;
- (IBAction)setStatus:(NSString *)status forceForTime:(float)sec;
- (IBAction)flushForceMsgFlag;
- (IBAction)setOnlineBall:(BOOL)isOnline;

- (void)printStatusLabelPos_test;
- (void)printEmptyLine;
- (void)setBubbleNotificationCount:(NSUInteger)messageCount;
- (NSUInteger)getBubbleNotificationCount;
- (void)bubbleNotificationCountIncrement;
- (void)bubbleNotificationCountDecrement;

- (IBAction)pressTab1Handler:(id)sender;
- (IBAction)pressTab2Handler:(id)sender;
- (IBAction)pressTab3Handler:(id)sender;
- (IBAction)pressTab4Handler:(id)sender;
- (IBAction)pressTab5Handler:(id)sender;

@end
