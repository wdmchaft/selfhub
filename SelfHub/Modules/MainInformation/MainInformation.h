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


@interface MainInformation : UIViewController <ModuleProtocol, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>{
    
};

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *dateSelector;
@property (nonatomic, retain) IBOutlet UIDatePicker *birthday;

- (NSString *)getBaseDir;
- (NSDate *)getDateFromString_ddMMyy:(NSString *)dateStr;
- (NSString *)getYearsWord:(NSUInteger)years padej:(BOOL)isRod;
- (NSUInteger)getAgeByBirthday:(NSDate *)brthdy;

//Данные вкладки
@property (nonatomic, retain) IBOutlet UIImageView *photo;

@property (nonatomic, retain) IBOutlet UITextField *surname;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *patronymic;

@property (nonatomic, retain) IBOutlet UISegmentedControl *sex;
@property (nonatomic, retain) IBOutlet UILabel *ageLabel;
@property (nonatomic, retain) IBOutlet UILabel *birthdayLabel;

@property (nonatomic, retain) IBOutlet UITextField *lengthLabel;
@property (nonatomic, retain) IBOutlet UIStepper *lengthStepper;

@property (nonatomic, retain) IBOutlet UITextField *weightLabel;
@property (nonatomic, retain) IBOutlet UIStepper *weightStepper;

@property (nonatomic, retain) IBOutlet UITextField *spirometry;

@property (nonatomic, retain) IBOutlet UITextField *thighLabel;
@property (nonatomic, retain) IBOutlet UIStepper *thighStepper;

@property (nonatomic, retain) IBOutlet UITextField *waistLabel;
@property (nonatomic, retain) IBOutlet UIStepper *waistStepper;

@property (nonatomic, retain) IBOutlet UITextField *chestLabel;
@property (nonatomic, retain) IBOutlet UIStepper *chestStepper;

- (IBAction)pressSelectPhoto:(id)sender;

- (IBAction)pressSelectBirthday:(id)sender;
- (IBAction)pressFinishSelectBirthday:(id)sender;

- (IBAction)valueLengthStepped:(id)sender;
- (IBAction)valueLengthFinishChanged:(id)sender;

- (IBAction)valueWeightStepped:(id)sender;
- (IBAction)valueWeightFinishChanged:(id)sender;

- (IBAction)valueThighStepped:(id)sender;
- (IBAction)valueThighFinishChanged:(id)sender;

- (IBAction)valueWaistStepped:(id)sender;
- (IBAction)valueWaistFinishChanged:(id)sender;

- (IBAction)valueChestStepped:(id)sender;
- (IBAction)valueChestFinishChanged:(id)sender;

- (IBAction)correctScrollBeforeEditing:(id)sender;
- (IBAction)hideKeyboard:(id)sender;










@end
