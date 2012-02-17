//
//  MainInformation.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainInformation.h"

@implementation MainInformation

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [scrollView setContentSize:CGSizeMake(310, 874)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Module protocol functions

- (NSString *)getModuleName{
    return @"Антропометрия";
};

- (NSString *)getModuleDescription{
    return @"Модуль позволяет отображать и редактировать общую информацию о пациенте (рост, вес, возраст и т.д.)";
};

- (NSString *)getModuleMessage{
    return @"Заполните информацию о себе";
};

- (float)getModuleVersion{
    return 1.0f;
};

- (UIImage *)getModuleIcon{
    return [UIImage imageNamed:@"mainInfoModule_icon.png"];
};


@end
