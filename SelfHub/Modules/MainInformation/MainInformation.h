//
//  MainInformation.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleHelper.h"

@protocol ModuleProtocol;


@interface MainInformation : UIViewController <ModuleProtocol,  UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>{
    
};

@property (nonatomic, assign) id <ServerProtocol> delegate;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *dateSelector;
@property (nonatomic, retain) IBOutlet UIDatePicker *birthday;
@property (nonatomic, retain) NSDate *realBirthday;

@property (nonatomic, retain) NSMutableDictionary *moduleData;

- (void)fillAllFieldsLocalized;
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
@property (nonatomic, retain) IBOutlet UIButton *birthdaySelectButton;
@property (nonatomic, retain) IBOutlet UILabel *birthdayBarLabel;
@property (nonatomic, retain) IBOutlet UIButton *birthdaySelectionOkButton;
@property (nonatomic, retain) IBOutlet UIButton *birthdaySelectionCancelButton;

@property (nonatomic, retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic, retain) IBOutlet UITextField *lengthTextField;
@property (nonatomic, retain) IBOutlet UIStepper *lengthStepper;
@property (nonatomic, retain) IBOutlet UILabel *lengthUnitLabel;

@property (nonatomic, retain) IBOutlet UILabel *weightLabel;
@property (nonatomic, retain) IBOutlet UITextField *weightTextField;
@property (nonatomic, retain) IBOutlet UIStepper *weightStepper;
@property (nonatomic, retain) IBOutlet UILabel *weightUnitLabel;

@property (nonatomic, retain) IBOutlet UILabel *spirometryLabel;
@property (nonatomic, retain) IBOutlet UITextField *spirometryTextField;
@property (nonatomic, retain) IBOutlet UILabel *spirometryUnitLabel;

@property (nonatomic, retain) IBOutlet UILabel *sizesLabel;

@property (nonatomic, retain) IBOutlet UILabel *thighLabel;
@property (nonatomic, retain) IBOutlet UITextField *thighTextField;
@property (nonatomic, retain) IBOutlet UIStepper *thighStepper;
@property (nonatomic, retain) IBOutlet UILabel *thighUnitLabel;

@property (nonatomic, retain) IBOutlet UILabel *waistLabel;
@property (nonatomic, retain) IBOutlet UITextField *waistTextField;
@property (nonatomic, retain) IBOutlet UIStepper *waistStepper;
@property (nonatomic, retain) IBOutlet UILabel *waistUnitLabel;

@property (nonatomic, retain) IBOutlet UILabel *chestLabel;
@property (nonatomic, retain) IBOutlet UITextField *chestTextField;
@property (nonatomic, retain) IBOutlet UIStepper *chestStepper;
@property (nonatomic, retain) IBOutlet UILabel *chestUnitLabel;

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



- (void)convertSavedDataToViewFields;
- (void)convertViewFieldsToSavedData;






@end
