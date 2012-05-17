//
//  WeightControlSettings.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlSettings.h"

@interface WeightControlSettings ()

@end

@implementation WeightControlSettings

@synthesize delegate;
@synthesize aimLabel, aimStepper, heightLabel, ageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    delegate = nil;
    aimLabel = nil;
    aimStepper = nil;
    heightLabel = nil;
    ageLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    aimLabel.text = [NSString stringWithFormat:@"Current aim: %.1f kg", [delegate.aimWeight floatValue]];
    
    NSNumber *length = [delegate.delegate getValueForName:@"length" fromModuleWithID:@"selfhub.antropometry"];
    if(length==nil){
        heightLabel.text = @"Your height: <unknown>";
    }else{
        heightLabel.text = [NSString stringWithFormat:@"Your height: %.0f cm", [length floatValue]];
    };
    
    NSUInteger years;
    NSDate *birthday = [delegate.delegate getValueForName:@"birthday" fromModuleWithID:@"selfhub.antropometry"];
    if(birthday==nil){
        ageLabel.text = @"Your age: <unknown>";
    }else{
        years = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:birthday toDate:[NSDate date] options:0] year];
        ageLabel.text = [NSString stringWithFormat:@"Your age: %d years", years];
    };

    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)dealloc{
    [aimLabel release];
    [aimLabel release];
    [heightLabel release];
    [ageLabel release];
    
    [super dealloc];
};


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changeAimStepper:(id)sender{
    delegate.aimWeight = [NSNumber numberWithFloat:aimStepper.value];
    aimLabel.text = [NSString stringWithFormat:@"Current aim: %.1f kg", [delegate.aimWeight floatValue]];
};

- (IBAction)pressChangeAntropometryValues:(id)sender{
    UIViewController *antropometryController = [delegate.delegate getViewControllerForModuleWithID:@"selfhub.antropometry"];
    
    [delegate.navigationController pushViewController:antropometryController animated:YES];
};

@end
