//
//  MainInformation.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainInformation.h"

@implementation MainInformation

@synthesize delegate;
@synthesize scrollView, dateSelector, birthday, realBirthday, moduleData;
@synthesize photo, surname, name, patronymic;
@synthesize sex, ageLabel, birthdayLabel, birthdayBarLabel, birthdaySelectButton, birthdaySelectionOkButton, birthdaySelectionCancelButton;
@synthesize lengthLabel, lengthTextField, lengthStepper, lengthUnitLabel;
@synthesize weightLabel, weightTextField, weightStepper, weightUnitLabel;
@synthesize spirometryLabel, spirometryTextField, spirometryUnitLabel;
@synthesize sizesLabel, thighLabel, thighTextField, thighStepper, thighUnitLabel;
@synthesize waistLabel, waistTextField, waistStepper, waistUnitLabel;
@synthesize chestLabel, chestTextField, chestStepper, chestUnitLabel;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        realBirthday = nil;
        moduleData = nil;
    }
    return self;
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
    [self fillAllFieldsLocalized];
    
    [self.view addSubview:scrollView];
    [scrollView setScrollEnabled:YES];
    [scrollView setFrame:CGRectMake(0, 0, 320, 436)];
    [scrollView setContentSize:CGSizeMake(310, 567)];
    
    dateSelector.center = CGPointMake(160, 720);
    [self.view addSubview:dateSelector];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    delegate = nil;
    scrollView = nil;
    dateSelector = nil;
    birthday = nil;
    realBirthday = nil;
    moduleData = nil;
    photo = nil;
    surname = nil;
    name = nil;
    patronymic = nil;
    sex = nil;
    ageLabel = nil;
    birthdayLabel = nil;
    birthdayBarLabel = nil;
    birthdaySelectButton = nil;
    birthdaySelectionCancelButton = nil;
    birthdaySelectionOkButton = nil;
    lengthLabel = nil;
    lengthTextField = nil;
    lengthStepper = nil;
    lengthUnitLabel = nil;
    weightLabel = nil;
    weightTextField = nil;
    weightStepper = nil;
    weightUnitLabel = nil;
    spirometryLabel = nil;
    spirometryTextField = nil;
    spirometryUnitLabel = nil;
    sizesLabel = nil;
    thighLabel = nil;
    thighTextField = nil;
    thighStepper = nil;
    thighUnitLabel = nil;
    waistLabel = nil;
    waistTextField = nil;
    waistStepper = nil;
    waistUnitLabel = nil;
    chestLabel = nil;
    chestTextField = nil;
    chestStepper = nil;
    chestUnitLabel = nil;
}

- (void)dealloc
{
    delegate = nil;
    [scrollView release];
    [dateSelector release];
    [birthday release];
    if(realBirthday) [realBirthday release];
    if(moduleData) [moduleData release];
    [photo release];
    [surname release];
    [name release];
    [patronymic release];
    [sex release];
    [ageLabel release];
    [birthdayLabel release];
    [birthdayBarLabel release];
    [birthdaySelectButton release];
    [birthdaySelectionCancelButton release];
    [birthdaySelectionOkButton release];
    [lengthLabel release];
    [lengthTextField release];
    [lengthStepper release];
    [lengthUnitLabel release];
    [weightLabel release];
    [weightTextField release];
    [weightStepper release];
    [weightUnitLabel release];
    [spirometryLabel release];
    [spirometryTextField release];
    [spirometryUnitLabel release];
    [sizesLabel release];
    [thighLabel release];
    [thighTextField release];
    [thighStepper release];
    [thighUnitLabel release];
    [waistLabel release];
    [waistTextField release];
    [waistStepper release];
    [waistUnitLabel release];
    [chestLabel release];
    [chestTextField release];
    [chestStepper release];
    [chestUnitLabel release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    if(moduleData==nil){
        [self loadModuleData];
    }else{
        [self convertSavedDataToViewFields];
    };
    
    //NSLog(@"Getting value from module: %@", [delegate getValueForName:@"surname" fromModuleWithID:@"selfhub.antropometry"]);
    //[[ModuleHelper sharedHelper] testExchangeListForModuleWithID:@"selfhub.antropometry"];
};

- (void)viewWillDisappear:(BOOL)animated{
    [self saveModuleData];
};


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fillAllFieldsLocalized{
    self.title = NSLocalizedString(@"Anthropometry", @"");
    surname.placeholder = NSLocalizedString(@"Surname", @"");
    name.placeholder = NSLocalizedString(@"Name", @"");
    patronymic.placeholder = NSLocalizedString(@"Patronymic", @"");
    [sex setTitle:NSLocalizedString(@"Male", @"") forSegmentAtIndex:0];
    [sex setTitle:NSLocalizedString(@"Female", @"") forSegmentAtIndex:1];
    ageLabel.text = NSLocalizedString(@"Age: unknown", @"");
    birthdayLabel.text = NSLocalizedString(@"Birthday: unknown", @"");
    birthdayBarLabel.text = NSLocalizedString(@"Select birthday", @"");
    [birthdaySelectButton setTitle:NSLocalizedString(@"Select", @"") forState:UIControlStateNormal];
    [birthdaySelectionCancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [birthdaySelectionOkButton setTitle:NSLocalizedString(@"Ok", @"") forState:UIControlStateNormal];
    lengthLabel.text = NSLocalizedString(@"Height:", @"");
    lengthUnitLabel.text = NSLocalizedString(@"cm", @"");
    weightLabel.text = NSLocalizedString(@"Weight:", @"");
    weightUnitLabel.text = NSLocalizedString(@"kg", @"");
    spirometryLabel.text = NSLocalizedString(@"Spirometry:", @"");
    spirometryUnitLabel.text = NSLocalizedString(@"cc", @"");
    sizesLabel.text = NSLocalizedString(@"Parameters of body", @"");
    thighLabel.text = NSLocalizedString(@"Hip:", @"");
    thighUnitLabel.text = NSLocalizedString(@"cm", @"");
    waistLabel.text = NSLocalizedString(@"Waist:", @"");
    waistUnitLabel.text = NSLocalizedString(@"cm", @"");
    chestLabel.text = NSLocalizedString(@"Breast:", @"");
    chestUnitLabel.text = NSLocalizedString(@"cm", @"");
}

- (NSDate *)getDateFromString_ddMMyy:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    return [dateFormatter dateFromString:dateStr];
};

- (NSString *)getYearsWord:(NSUInteger)years padej:(BOOL)isRod{
    
    if(isRod){
        if(years>10&&years<19) return NSLocalizedString(@"years_let", @"");
        if((years%10) ==  1) return NSLocalizedString(@"years_goda", @"");
        
        return NSLocalizedString(@"years_let", @"");
    }else{
        if(years>10&&years<19) return NSLocalizedString(@"years_let", @"");
        if((years%10) == 1) return NSLocalizedString(@"year_god", @"");
        if((years%10) >= 2 && (years%10) <=4) return NSLocalizedString(@"years_goda", @"");
        
        return NSLocalizedString(@"years_let", @"");
    };
};

- (NSUInteger)getAgeByBirthday:(NSDate *)brthdy{
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:brthdy toDate:now options:0];
    
    return [ageComponents year];
};

- (NSString *)getBaseDir{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
};


#pragma mark - Working with views's fields

- (IBAction)pressSelectPhoto:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select photo:", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", @""), NSLocalizedString(@"Library", @""), NSLocalizedString(@"Album", @""), nil];
    [actionSheet showInView:self.view];

};


- (IBAction)pressSelectBirthday:(id)sender{
    [surname resignFirstResponder];
    [name resignFirstResponder];
    [patronymic resignFirstResponder];
    [lengthTextField resignFirstResponder];
    [weightTextField resignFirstResponder];
    [spirometryTextField resignFirstResponder];
    [thighTextField resignFirstResponder];
    [waistTextField resignFirstResponder];
    [chestTextField resignFirstResponder];
    
    dateSelector.center = CGPointMake(160, 720);
    dateSelector.hidden = NO;
    
    if(realBirthday){
        [birthday setDate:realBirthday];
    };
    
    [UIView animateWithDuration:0.4f animations:^{
        dateSelector.center = CGPointMake(160, 230);
    }];
};
- (IBAction)pressFinishSelectBirthday:(id)sender{
    dateSelector.center = CGPointMake(160, 230);
    [UIView animateWithDuration:0.4f animations:^{
        dateSelector.center = CGPointMake(160, 720);
    }];
    
    if([(UIButton *)sender tag]==1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        
        birthdayLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Birthday: %@", @""), [dateFormatter stringFromDate:birthday.date]];
        [dateFormatter release];
        
        NSUInteger ageNum = [self getAgeByBirthday:birthday.date];
        ageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Age: %d %@", @""), ageNum, [self getYearsWord:ageNum padej:NO]];
        
        //if(realBirthday) [realBirthday release];
        realBirthday = birthday.date;
    };

};

- (IBAction)valueLengthStepped:(id)sender{
    lengthTextField.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueLengthFinishChanged:(id)sender{
    if([lengthTextField.text length]==0) return;
    int value = [lengthTextField.text intValue];
    if(value<lengthStepper.minimumValue){
        value = lengthStepper.minimumValue;
        lengthTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>lengthStepper.maximumValue){
        value = lengthStepper.maximumValue;
        lengthTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    lengthStepper.value = value;
};

- (IBAction)valueWeightStepped:(id)sender{
    weightTextField.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
}
- (IBAction)valueWeightFinishChanged:(id)sender{
    if([weightTextField.text length]==0) return;
    int value = [weightTextField.text intValue];
    if(value<weightStepper.minimumValue){
        value = lengthStepper.minimumValue;
        weightTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>weightStepper.maximumValue){
        value = weightStepper.maximumValue;
        weightTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    weightStepper.value = value;
};

- (IBAction)valueThighStepped:(id)sender{
    thighTextField.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueThighFinishChanged:(id)sender{
    if([thighTextField.text length]==0) return;
    int value = [thighTextField.text intValue];
    if(value<thighStepper.minimumValue){
        value = thighStepper.minimumValue;
        thighTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>thighStepper.maximumValue){
        value = thighStepper.maximumValue;
        thighTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    thighStepper.value = value;
};

- (IBAction)valueWaistStepped:(id)sender{
    waistTextField.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueWaistFinishChanged:(id)sender{
    if([waistTextField.text length]==0) return;
    int value = [waistTextField.text intValue];
    if(value<waistStepper.minimumValue){
        value = waistStepper.minimumValue;
        waistTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>waistStepper.maximumValue){
        value = waistStepper.maximumValue;
        waistTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    waistStepper.value = value;
};

- (IBAction)valueChestStepped:(id)sender{
    chestTextField.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueChestFinishChanged:(id)sender{
    if([chestTextField.text length]==0) return;
    int value = [chestTextField.text intValue];
    if(value<chestStepper.minimumValue){
        value = chestStepper.minimumValue;
        chestTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>chestStepper.maximumValue){
        value = chestStepper.maximumValue;
        chestTextField.text = [NSString stringWithFormat:@"%d", value];
    };
    chestStepper.value = value;
};
- (IBAction)correctScrollBeforeEditing:(id)sender{
    [UIView animateWithDuration:0.4f animations:^(void){
        [scrollView setFrame:CGRectMake(0, 0, 320, 220)];
    }];
    CGRect fieldRect = [scrollView convertRect:[sender frame] toView:self.view];
    //NSLog(@"%.0f, %.0f, %.0f, %.0f", fieldRect.origin.x, fieldRect.origin.y, fieldRect.size.width, fieldRect.size.height);
    if(fieldRect.origin.y>200){
        [scrollView scrollRectToVisible:CGRectMake(0, [sender frame].origin.y, 320, 436) animated:YES];
    };
};
- (IBAction)hideKeyboard:(id)sender{
    [UIView animateWithDuration:0.4f animations:^(void){
        [scrollView setFrame:CGRectMake(0, 0, 320, 436)];
    }];
    [sender resignFirstResponder];
};

#pragma mark -
#pragma mark UIImagePickerController delegate functions

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
    
    photo.image = image;
};


#pragma mark -
#pragma mark UIActionSheet delegate functions

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [actionSheet release];
    
    if(buttonIndex==3) return;
    
    UIImagePickerController *imagePick;
    imagePick = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType imagePickType;
    
    switch(buttonIndex){
        case 0:
            imagePickType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            imagePickType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            imagePickType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        default:
            imagePickType = UIImagePickerControllerSourceTypeCamera;
            break;
    };
    
    if(![UIImagePickerController isSourceTypeAvailable:imagePickType]){
        [imagePick release];
        return;
    };
    
    imagePick.sourceType = imagePickType;
    imagePick.delegate = self;
    imagePick.allowsEditing = YES;
    
    [self presentModalViewController:imagePick animated:YES];
    
};



#pragma mark - Module protocol functions

- (id)initModuleWithDelegate:(id<ServerProtocol>)serverDelegate{
    NSString *nibName;
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone){
        nibName = @"MainInformation";
    }else{
        return nil;
    };
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        realBirthday = nil;
        moduleData = nil;
        delegate = serverDelegate;
        if(serverDelegate==nil){
            NSLog(@"WARNING: module \"%@\" initialized without server delegate!", [self getModuleName]);
        };
    }
    return self;
};

- (NSString *)getModuleName{
    return NSLocalizedString(@"Anthropometry", @"");
};

- (NSString *)getModuleDescription{
    return NSLocalizedString(@"The module allows you to display and edit general information about the patient (height, weight, age, etc)", @"");
};

- (NSString *)getModuleMessage{
    if(moduleData==nil) return NSLocalizedString(@"The data is not loaded", @"");
    
    //NSLog(@"getModuleMessage: %@, %@, %@", name.text, surname.text, patronymic.text);
    if([moduleData objectForKey:@"name"]==nil || [moduleData objectForKey:@"surname"]==nil || [moduleData objectForKey:@"patronymic"]==nil) return NSLocalizedString(@"Specify the name", @"");
    if([moduleData objectForKey:@"birthday"]==nil) return NSLocalizedString(@"Specify your birthday", @"");
    if([moduleData objectForKey:@"length"]==nil) return NSLocalizedString(@"Specify the height!", @"");
    if([moduleData objectForKey:@"weight"]==nil) return NSLocalizedString(@"Specify the weight", @"");
    if([moduleData objectForKey:@"spirometry"]==nil) return NSLocalizedString(@"Perform spirometry!", @"");
    if([moduleData objectForKey:@"thigh"]==nil || [moduleData objectForKey:@"waist"]==nil || [moduleData objectForKey:@"chest"]==nil) return NSLocalizedString(@"Measure the parameters of body!", @"");
    
    return NSLocalizedString(@"All fields are filled!", @"");
};

- (float)getModuleVersion{
    return 1.0f;
};

- (UIImage *)getModuleIcon{
    return [UIImage imageNamed:@"mainInfoModule_icon.png"];
};

- (BOOL)isInterfaceIdiomSupportedByModule:(UIUserInterfaceIdiom)idiom{
    BOOL res;
    switch (idiom) {
        case UIUserInterfaceIdiomPhone:
            res = YES;
            break;
            
        case UIUserInterfaceIdiomPad:
            res = NO;
            break;
            
        default:
            res = NO;
            break;
    };
    
    return res;
};

- (void)convertSavedDataToViewFields{
    if(moduleData==nil){
        name.text = @"";
        surname.text = @"";
        patronymic.text = @"";
        sex.selectedSegmentIndex = 0;
        ageLabel.text = NSLocalizedString(@"Age: unknown", @"");
        birthdayLabel.text = NSLocalizedString(@"Birthday: unknown", @"");
        lengthTextField.text = @"";
        weightTextField.text = @"";
        spirometryTextField.text = @"";
        photo.image = [UIImage imageNamed:@"voidPhoto.png"];
        lengthTextField.text = @"";
        weightTextField.text = @"";
        spirometryTextField.text = @"";
        thighTextField.text = @"";
        waistTextField.text = @"";
        chestTextField.text = @"";
        return;
    };
    
    
    if([moduleData objectForKey:@"photo"]){photo.image = [UIImage imageWithData:[moduleData objectForKey:@"photo"]];};
    if([moduleData objectForKey:@"name"]){
        name.text = [moduleData objectForKey:@"name"];
    }else{
        name.text = @"";
    };
    if([moduleData objectForKey:@"surname"]){surname.text = [moduleData objectForKey:@"surname"];}else{surname.text = @"";};
    if([moduleData objectForKey:@"patronymic"]){patronymic.text = [moduleData objectForKey:@"patronymic"];}else{patronymic.text = @"";};
    sex.selectedSegmentIndex = [[moduleData objectForKey:@"sex"] intValue];
    if([moduleData objectForKey:@"birthday"]){
        //if(realBirthday) [realBirthday release];
        realBirthday = [moduleData objectForKey:@"birthday"];
        [birthday setDate:realBirthday];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        birthdayLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Birthday: %@", @""), [dateFormatter stringFromDate:realBirthday]];
        [dateFormatter release];
        NSUInteger ageNum = [self getAgeByBirthday:birthday.date];
        ageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Age: %d %@", @""), ageNum, [self getYearsWord:ageNum padej:NO]];
    }else{
        ageLabel.text = NSLocalizedString(@"Age: unknown", @"");
        birthdayLabel.text = NSLocalizedString(@"Birthday: unknown", @"");
    };
    if([moduleData objectForKey:@"length"]){
        lengthStepper.value = [[moduleData objectForKey:@"length"] floatValue];
        lengthTextField.text = [NSString stringWithFormat:@"%.0f", lengthStepper.value];
    }else{
        lengthTextField.text = @"";
    };
    if([moduleData objectForKey:@"weight"]){
        weightStepper.value = [[moduleData objectForKey:@"weight"] intValue];
        weightTextField.text = [NSString stringWithFormat:@"%.0f", weightStepper.value];
    }else{
        weightTextField.text = @"";
    };
    if([moduleData objectForKey:@"spirometry"]){
        spirometryTextField.text = [NSString stringWithFormat:@"%d", [[moduleData objectForKey:@"spirometry"] intValue]];
    }else{
        spirometryTextField.text = @"";
    };
    if([moduleData objectForKey:@"waist"]){
        waistStepper.value = [[moduleData objectForKey:@"waist"] intValue];
        waistTextField.text = [NSString stringWithFormat:@"%.0f", waistStepper.value];
    }else{
        waistTextField.text = @"";
    };
    if([moduleData objectForKey:@"thigh"]){
        thighStepper.value = [[moduleData objectForKey:@"thigh"] intValue];
        thighTextField.text = [NSString stringWithFormat:@"%.0f", thighStepper.value];
    }else{
        thighTextField.text = @"";
    };
    if([moduleData objectForKey:@"chest"]){
        chestStepper.value = [[moduleData objectForKey:@"chest"] intValue];
        chestTextField.text = [NSString stringWithFormat:@"%.0f", chestStepper.value];
    }else{
        chestTextField.text = @"";
    };

};

- (void)convertViewFieldsToSavedData{
    NSMutableDictionary *exportDict;
    
    exportDict = [[NSMutableDictionary alloc] init];
    if(name.text && [name.text length]>0)
        [exportDict setObject:name.text forKey:@"name"];
    if(surname.text && [surname.text length]>0)
        [exportDict setObject:surname.text forKey:@"surname"];
    if(patronymic.text && [patronymic.text length]>0)
        [exportDict setObject:patronymic.text forKey:@"patronymic"];
    if(photo.image)
        [exportDict setObject:UIImagePNGRepresentation(photo.image) forKey:@"photo"];
    [exportDict setObject:[NSNumber numberWithInteger:sex.selectedSegmentIndex] forKey:@"sex"];
    if(realBirthday)
        [exportDict setObject:realBirthday forKey:@"birthday"];
    if(lengthTextField.text && [lengthTextField.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:lengthStepper.value] forKey:@"length"];
    if(weightTextField.text && [weightTextField.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:weightStepper.value] forKey:@"weight"];
    if(spirometryTextField.text && [spirometryTextField.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:[spirometryTextField.text intValue]] forKey:@"spirometry"];
    if(thighTextField.text && [thighTextField.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:thighStepper.value] forKey:@"thigh"];
    if(waistTextField.text && [waistTextField.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:waistStepper.value] forKey:@"waist"];
    if(chestTextField.text && [chestTextField.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:chestStepper.value] forKey:@"chest"];
    
    if(moduleData) [moduleData release];
    moduleData = [[NSMutableDictionary alloc] initWithDictionary:exportDict];
    
    [exportDict release];
};

- (void)loadModuleData{
    NSString *listFilePath = [[self getBaseDir] stringByAppendingPathComponent:@"antropometry.dat"];
    NSDictionary *loadedParams = [NSDictionary dictionaryWithContentsOfFile:listFilePath];
    if(loadedParams){
        if(moduleData) [moduleData release];
        moduleData = [[NSMutableDictionary alloc] initWithDictionary:loadedParams];
    };
    
    if([self isViewLoaded]){
        [self convertSavedDataToViewFields];
    }
};
- (void)saveModuleData{    
    if([self isViewLoaded]){
        [self convertViewFieldsToSavedData];
    };
    
    if(moduleData==nil){
        return;
    };
    
    BOOL succ = [moduleData writeToFile:[[self getBaseDir] stringByAppendingPathComponent:@"antropometry.dat"] atomically:YES];
    if(succ==NO){
        NSLog(@"Anthropometry: Error during save data");
    };
};

- (id)getModuleValueForKey:(NSString *)key{
    return nil;
};

- (void)setModuleValue:(id)object forKey:(NSString *)key{
    
};


@end
