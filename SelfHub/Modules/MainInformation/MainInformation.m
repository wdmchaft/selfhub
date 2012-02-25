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
@synthesize sex, ageLabel, birthdayLabel;
@synthesize lengthLabel, lengthStepper, weightLabel, weightStepper, spirometry, thighLabel, thighStepper, waistLabel, waistStepper, chestLabel, chestStepper;

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
    self.title = @"Антропометрия";
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
    lengthLabel = nil;
    lengthStepper = nil;
    weightLabel = nil;
    weightStepper = nil;
    spirometry = nil;
    thighLabel = nil;
    thighStepper = nil;
    waistLabel = nil;
    waistStepper = nil;
    chestLabel = nil;
    chestStepper = nil;
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
    [lengthLabel release];
    [lengthStepper release];
    [weightLabel release];
    [weightStepper release];
    [spirometry release];
    [thighLabel release];
    [thighStepper release];
    [waistLabel release];
    [waistStepper release];
    [chestLabel release];
    [chestStepper release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    if(moduleData==nil){
        [self loadModuleData];
    }else{
        [self convertSavedDataToViewFields];
    };
    
    //NSLog(@"Getting value from module: %@", [delegate getValueForName:@"surname" fromModuleWithID:@"selfhub.antropometry"]);
    [[ModuleHelper sharedHelper] testExchangeListForModuleWithID:@"selfhub.antropometry"];
};

- (void)viewWillDisappear:(BOOL)animated{
    [self saveModuleData];
};


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSDate *)getDateFromString_ddMMyy:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    return [dateFormatter dateFromString:dateStr];
};

- (NSString *)getYearsWord:(NSUInteger)years padej:(BOOL)isRod{
    
    if(isRod){
        if(years>10&&years<19) return @"лет";
        if((years%10) == 1) return @"года";
        
        return @"лет";
    }else{
        if(years>10&&years<19) return @"лет";
        if((years%10) == 1) return @"год";
        if((years%10) >= 2 && (years%10) <=4) return @"года";
        
        return @"лет";
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Выберите фото:" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"С камеры", @"Из библиотеки", @"Из альбома", nil];
    [actionSheet showInView:self.view];

};


- (IBAction)pressSelectBirthday:(id)sender{
    [surname resignFirstResponder];
    [name resignFirstResponder];
    [patronymic resignFirstResponder];
    [lengthLabel resignFirstResponder];
    [weightLabel resignFirstResponder];
    [spirometry resignFirstResponder];
    [thighLabel resignFirstResponder];
    [waistLabel resignFirstResponder];
    [chestLabel resignFirstResponder];
    
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
        
        birthdayLabel.text = [NSString stringWithFormat:@"День Рождения: %@ г.", [dateFormatter stringFromDate:birthday.date]];
        [dateFormatter release];
        
        NSUInteger ageNum = [self getAgeByBirthday:birthday.date];
        ageLabel.text = [NSString stringWithFormat:@"Возраст: %d %@", ageNum, [self getYearsWord:ageNum padej:NO]];
        
        //if(realBirthday) [realBirthday release];
        realBirthday = birthday.date;
    };

};

- (IBAction)valueLengthStepped:(id)sender{
    lengthLabel.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueLengthFinishChanged:(id)sender{
    if([lengthLabel.text length]==0) return;
    int value = [lengthLabel.text intValue];
    if(value<lengthStepper.minimumValue){
        value = lengthStepper.minimumValue;
        lengthLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>lengthStepper.maximumValue){
        value = lengthStepper.maximumValue;
        lengthLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    lengthStepper.value = value;
};

- (IBAction)valueWeightStepped:(id)sender{
    weightLabel.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
}
- (IBAction)valueWeightFinishChanged:(id)sender{
    if([weightLabel.text length]==0) return;
    int value = [weightLabel.text intValue];
    if(value<weightStepper.minimumValue){
        value = lengthStepper.minimumValue;
        weightLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>weightStepper.maximumValue){
        value = weightStepper.maximumValue;
        weightLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    weightStepper.value = value;
};

- (IBAction)valueThighStepped:(id)sender{
    thighLabel.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueThighFinishChanged:(id)sender{
    if([thighLabel.text length]==0) return;
    int value = [thighLabel.text intValue];
    if(value<thighStepper.minimumValue){
        value = thighStepper.minimumValue;
        thighLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>thighStepper.maximumValue){
        value = thighStepper.maximumValue;
        thighLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    thighStepper.value = value;
};

- (IBAction)valueWaistStepped:(id)sender{
    waistLabel.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueWaistFinishChanged:(id)sender{
    if([waistLabel.text length]==0) return;
    int value = [waistLabel.text intValue];
    if(value<waistStepper.minimumValue){
        value = waistStepper.minimumValue;
        waistLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>waistStepper.maximumValue){
        value = waistStepper.maximumValue;
        waistLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    waistStepper.value = value;
};

- (IBAction)valueChestStepped:(id)sender{
    chestLabel.text = [NSString stringWithFormat:@"%.0f", [(UIStepper *)sender value]];
};
- (IBAction)valueChestFinishChanged:(id)sender{
    if([chestLabel.text length]==0) return;
    int value = [chestLabel.text intValue];
    if(value<chestStepper.minimumValue){
        value = chestStepper.minimumValue;
        chestLabel.text = [NSString stringWithFormat:@"%d", value];
    };
    if(value>chestStepper.maximumValue){
        value = chestStepper.maximumValue;
        chestLabel.text = [NSString stringWithFormat:@"%d", value];
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
    return @"Антропометрия";
};

- (NSString *)getModuleDescription{
    return @"Модуль позволяет отображать и редактировать общую информацию о пациенте (рост, вес, возраст и т.д.)";
};

- (NSString *)getModuleMessage{
    if(moduleData==nil) return @"Данные не загружены";
    
    //NSLog(@"getModuleMessage: %@, %@, %@", name.text, surname.text, patronymic.text);
    if([moduleData objectForKey:@"name"]==nil || [moduleData objectForKey:@"surname"]==nil || [moduleData objectForKey:@"patronymic"]==nil) return @"Укажите ФИО";
    if([moduleData objectForKey:@"birthday"]==nil) return @"Укажите дату рождения";
    if([moduleData objectForKey:@"length"]==nil) return @"Измерьте свой рост!";
    if([moduleData objectForKey:@"weight"]==nil) return @"Измерьте свой вес!";
    if([moduleData objectForKey:@"spirometry"]==nil) return @"Выполните спирометрию!";
    if([moduleData objectForKey:@"thigh"]==nil || [moduleData objectForKey:@"waist"]==nil || [moduleData objectForKey:@"chest"]==nil) return @"Измерьте параметры телосложения!";
    
    return @"Все поля заполнены";
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
        ageLabel.text = @"Возраст: неизвестно";
        birthdayLabel.text = @"День Рождения: неизвестно";
        lengthLabel.text = @"";
        weightLabel.text = @"";
        spirometry.text = @"";
        photo.image = [UIImage imageNamed:@"voidPhoto.png"];
        lengthLabel.text = @"";
        weightLabel.text = @"";
        spirometry.text = @"";
        thighLabel.text = @"";
        waistLabel.text = @"";
        chestLabel.text = @"";
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
        birthdayLabel.text = [NSString stringWithFormat:@"День Рождения: %@ г.", [dateFormatter stringFromDate:realBirthday]];
        [dateFormatter release];
        NSUInteger ageNum = [self getAgeByBirthday:birthday.date];
        ageLabel.text = [NSString stringWithFormat:@"Возраст: %d %@", ageNum, [self getYearsWord:ageNum padej:NO]];
    }else{
        ageLabel.text = @"Возраст: неизвестно";
        birthdayLabel.text = @"День Рождения: неизвестно";
    };
    if([moduleData objectForKey:@"length"]){
        lengthStepper.value = [[moduleData objectForKey:@"length"] floatValue];
        lengthLabel.text = [NSString stringWithFormat:@"%.0f", lengthStepper.value];
    }else{
        lengthLabel.text = @"";
    };
    if([moduleData objectForKey:@"weight"]){
        weightStepper.value = [[moduleData objectForKey:@"weight"] intValue];
        weightLabel.text = [NSString stringWithFormat:@"%.0f", weightStepper.value];
    }else{
        weightLabel.text = @"";
    };
    if([moduleData objectForKey:@"spirometry"]){
        spirometry.text = [NSString stringWithFormat:@"%d", [[moduleData objectForKey:@"spirometry"] intValue]];
    }else{
        spirometry.text = @"";
    };
    if([moduleData objectForKey:@"waist"]){
        waistStepper.value = [[moduleData objectForKey:@"waist"] intValue];
        waistLabel.text = [NSString stringWithFormat:@"%.0f", waistStepper.value];
    }else{
        waistLabel.text = @"";
    };
    if([moduleData objectForKey:@"thigh"]){
        thighStepper.value = [[moduleData objectForKey:@"thigh"] intValue];
        thighLabel.text = [NSString stringWithFormat:@"%.0f", thighStepper.value];
    }else{
        thighLabel.text = @"";
    };
    if([moduleData objectForKey:@"chest"]){
        chestStepper.value = [[moduleData objectForKey:@"chest"] intValue];
        chestLabel.text = [NSString stringWithFormat:@"%.0f", chestStepper.value];
    }else{
        chestLabel.text = @"";
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
    if(lengthLabel.text && [lengthLabel.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:lengthStepper.value] forKey:@"length"];
    if(weightLabel.text && [weightLabel.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:weightStepper.value] forKey:@"weight"];
    if(spirometry.text && [spirometry.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:[spirometry.text intValue]] forKey:@"spirometry"];
    if(thighLabel.text && [thighLabel.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:thighStepper.value] forKey:@"thigh"];
    if(waistLabel.text && [waistLabel.text length]>0)
        [exportDict setObject:[NSNumber numberWithInteger:waistStepper.value] forKey:@"waist"];
    if(chestLabel.text && [chestLabel.text length]>0)
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
        NSLog(@"Error during save data");
    };
};

- (id)getModuleValueForKey:(NSString *)key{
    return nil;
};

- (void)setModuleValue:(id)object forKey:(NSString *)key{
    
};


@end
