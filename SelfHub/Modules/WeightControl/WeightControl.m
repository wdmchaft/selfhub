//
//  WeightControl.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControl.h"

@implementation WeightControl

@synthesize delegate;
@synthesize viewControllers, segmentedControl, hostView;
@synthesize weightData, aimWeight, normalWeight;

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
    
    self.title = @"Weight";
    
    //weightData = [[NSMutableArray alloc] init];
    //[self fillTestData:20];
    
    aimWeight = [NSNumber numberWithFloat:NAN];
    normalWeight = [NSNumber numberWithFloat:NAN];
    [self generateNormalWeight];
    
    WeightControlChart *chartViewController = [[WeightControlChart alloc] initWithNibName:@"WeightControlChart" bundle:nil];
    chartViewController.delegate = self;
    WeightControlData *dataViewController = [[WeightControlData alloc] initWithNibName:@"WeightControlData" bundle:nil];
    dataViewController.delegate = self;
    WeightControlStatistics *statisticsViewController = [[WeightControlStatistics alloc] initWithNibName:@"WeightControlStatistics" bundle:nil];
    statisticsViewController.delegate = self;
    WeightControlSettings *settingsViewController = [[WeightControlSettings alloc] initWithNibName:@"WeightControlSettings" bundle:nil];
    settingsViewController.delegate = self;
    
    viewControllers = [[NSArray alloc] initWithObjects:chartViewController, dataViewController, statisticsViewController, settingsViewController, nil];
    
    [settingsViewController release];
    [statisticsViewController release];
    [dataViewController release];
    [chartViewController release];
    
    [hostView addSubview:((UIViewController *)[viewControllers objectAtIndex:0]).view];
    segmentedControl.selectedSegmentIndex = 0;
    currentlySelectedViewController = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    weightData = nil;
    segmentedControl = nil;
}

- (void)dealloc{
    [weightData release];
    [viewControllers release];
    
    [super dealloc];
};

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [[viewControllers objectAtIndex:currentlySelectedViewController] viewWillAppear:animated];
    
    UIBarButtonItem *rightBtn;
    if(currentlySelectedViewController==0){
        rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Test-fill" style:UIBarButtonSystemItemAction target:[viewControllers objectAtIndex:0] action:@selector(pressDefault)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [rightBtn release];
    }else if(currentlySelectedViewController==1){
        rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonSystemItemEdit target:[viewControllers objectAtIndex:1] action:@selector(pressEdit)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [rightBtn release];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    };

    
    [self generateNormalWeight];
};

- (void)viewWillDisappear:(BOOL)animated{
    [self saveModuleData];
}

- (IBAction)segmentedControlChanged:(id)sender{
    [((UIViewController *)[viewControllers objectAtIndex:currentlySelectedViewController]).view removeFromSuperview];
    if(segmentedControl.selectedSegmentIndex >= [viewControllers count]){
        [hostView addSubview:((UIViewController *)[viewControllers objectAtIndex:0]).view];
        segmentedControl.selectedSegmentIndex = 0;
        currentlySelectedViewController = 0;
        return;
    };
    
    [hostView addSubview:((UIViewController *)[viewControllers objectAtIndex:segmentedControl.selectedSegmentIndex]).view];
    currentlySelectedViewController = segmentedControl.selectedSegmentIndex;
    
    UIBarButtonItem *rightBtn;
    if(currentlySelectedViewController==0){
        rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Test-fill" style:UIBarButtonSystemItemAction target:[viewControllers objectAtIndex:0] action:@selector(pressDefault)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [rightBtn release];
        //self.navigationItem.rightBarButtonItem = nil;
    }else if(currentlySelectedViewController==1){
        rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonSystemItemEdit target:[viewControllers objectAtIndex:1] action:@selector(pressEdit)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [rightBtn release];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    };

};


#pragma mark - Module protocol functions

- (id)initModuleWithDelegate:(id<ServerProtocol>)serverDelegate{
    NSString *nibName;
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone){
        nibName = @"WeightControl";
    }else{
        return nil;
    };
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        delegate = serverDelegate;
        if(serverDelegate==nil){
            NSLog(@"WARNING: module \"%@\" initialized without server delegate!", [self getModuleName]);
        };
    }
    return self;
};

- (NSString *)getModuleName{
    return NSLocalizedString(@"Weight Control", @"");
};

- (NSString *)getModuleDescription{
    return @"The module for those watching their weight. It allows you to make a prediction of weight, display the graph, etc.";
};

- (NSString *)getModuleMessage{
    return @"Enter your weight!";
};

- (float)getModuleVersion{
    return 1.0f;
};

- (UIImage *)getModuleIcon{
    return [UIImage imageNamed:@"weightModule_icon.png"];
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

- (NSString *)getBaseDir{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
};

- (void)loadModuleData{
    
    //weightData = [[NSMutableArray alloc] init];
    //[self fillTestData:20];
    //return;
    
    NSString *weightFilePath = [[self getBaseDir] stringByAppendingPathComponent:@"weightcontrol.dat"];
    //NSArray *importedWeightArray = [NSArray arrayWithContentsOfFile:weightFilePath];
    
    if(weightData){
        [weightData release];
        weightData = nil;
    };
    
    weightData = [[NSMutableArray alloc] initWithContentsOfFile:weightFilePath];
    if(!weightData){
        NSLog(@"Cannot load weight data from file weightcontrol.dat. Loading test data...");
        weightData = [[NSMutableArray alloc] init];
        [self fillTestData:33];
    }else{
        //[self sortWeightData];
    };
};
- (void)saveModuleData{
    NSString *weightFilePath = [[self getBaseDir] stringByAppendingPathComponent:@"weightcontrol.dat"];
    [weightData writeToFile:weightFilePath atomically:YES];
};

- (id)getModuleValueForKey:(NSString *)key{
    return nil;
};

- (void)setModuleValue:(id)object forKey:(NSString *)key{
    
};

#pragma mark - module functions
- (void)fillTestData:(NSUInteger)numOfElements{
    if(weightData){
        [weightData release];
        weightData = nil;
    };
    weightData = [[NSMutableArray alloc] init];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setMonth:03];
	[dateComponents setDay:25];
	[dateComponents setYear:2012];
	[dateComponents setHour:0];
	[dateComponents setMinute:0];
	[dateComponents setSecond:0];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *refDate = [gregorian dateFromComponents:dateComponents];
    [dateComponents release];
	[gregorian release];
    
    int i;
    NSDictionary *dict;
    NSNumber *weight;
    NSDate *date;
    [weightData removeAllObjects];
    for(i=0;i<numOfElements;i++){
        if(i==7||i==8) continue;
        weight = [NSNumber numberWithDouble:(((double)rand()/RAND_MAX) * 70) + 50];
        date = [NSDate dateWithTimeInterval:(60*60*24*i) sinceDate:refDate];
        dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:weight, date, nil] forKeys:[NSArray arrayWithObjects:@"weight", @"date", nil]];
        //NSLog(@"Weight for date %@: %.2f", [date description], [weight doubleValue]);
        [weightData addObject:dict];
    };
};

- (void)generateNormalWeight{
    NSNumber *length = [delegate getValueForName:@"length" fromModuleWithID:@"selfhub.antropometry"];
    NSDate *birthday = [delegate getValueForName:@"birthday" fromModuleWithID:@"selfhub.antropometry"];
    if(length==nil){
        normalWeight = [NSNumber numberWithFloat:NAN];
        return;
    };
    
    NSUInteger years = 18;
    if(birthday!=nil){
        years = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:birthday toDate:[NSDate date] options:0] year];
    };
    float res = [length floatValue];
    
    if([length floatValue]<165.0f){
        res -= 100.0f;
    };
    if([length floatValue]>=165.0f && [length floatValue]<=175.0f){
        res -= 105.0f;
    };
    if([length floatValue]>175.0f){
        res -= 110.0f;
    };
    
    if(years>40){
        res += 5.0f;
    }
    
    normalWeight = [[NSNumber numberWithFloat:res] retain];
    
    
    //NSLog(@"Normal weight is: %.2f", res);
};

- (NSDate *)getDateWithoutTime:(NSDate *)_myDate{
    NSDate *res;
    NSTimeInterval timeInt = [_myDate timeIntervalSince1970];
    NSTimeInterval oneDay = 60.0f * 60.0f * 24.0f;
    
    NSTimeInterval remainder = timeInt - floor(timeInt / oneDay) * oneDay;
    
    res = [NSDate dateWithTimeIntervalSince1970:timeInt - remainder];
    
    //NSLog(@"%@ -> %@", [_myDate description], [res description]);
    
    return res;
};

- (NSComparisonResult)compareDateByDays:(NSDate *)_firstDate WithDate:(NSDate *)_secondDate{
    double delta = [_firstDate timeIntervalSinceDate:_secondDate];
    if(fabs(delta) < 60*60*24){
        return NSOrderedSame;
    };
    
    if(delta>0){
        return NSOrderedDescending;
    };
    
    return NSOrderedAscending;
};

- (void)sortWeightData{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [weightData sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
};

@end