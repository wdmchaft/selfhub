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
@synthesize weightGraph, weightData, aimWeight, normalWeight;

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
    weightData = [[NSMutableArray alloc] init];
    weightGraph.delegate = self;
    [self fillTestData:20];
    [weightGraph createGraphLayer];
    
    aimWeight = [NSNumber numberWithFloat:NAN];
    normalWeight = [NSNumber numberWithFloat:NAN];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    weightGraph = nil;
    weightData = nil;
}

- (void)dealloc{
    [weightGraph release];
    [weightData release];
    
    [super dealloc];
};

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [self generateNormalWeight];
    
    [weightGraph showLastWeekGraph];
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

- (void)loadModuleData{
    /*NSString *listFilePath = [[self getBaseDir] stringByAppendingPathComponent:@"antropometry.dat"];
    NSDictionary *loadedParams = [NSDictionary dictionaryWithContentsOfFile:listFilePath];
    if(loadedParams){
        if(moduleData) [moduleData release];
        moduleData = [[NSMutableDictionary alloc] initWithDictionary:loadedParams];
    };
    
    if([self isViewLoaded]){
        [self convertSavedDataToViewFields];
    }*/
};
- (void)saveModuleData{    
    /*if([self isViewLoaded]){
        [self convertViewFieldsToSavedData];
    };
    
    if(moduleData==nil){
        return;
    };
    
    BOOL succ = [moduleData writeToFile:[[self getBaseDir] stringByAppendingPathComponent:@"antropometry.dat"] atomically:YES];
    if(succ==NO){
        NSLog(@"Anthropometry: Error during save data");
    };*/
};

- (id)getModuleValueForKey:(NSString *)key{
    return nil;
};

- (void)setModuleValue:(id)object forKey:(NSString *)key{
    
};

#pragma mark - module functions
- (void)fillTestData:(NSUInteger)numOfElements{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setMonth:03];
	[dateComponents setDay:25];
	[dateComponents setYear:2012];
	[dateComponents setHour:12];
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
    
    normalWeight = [[NSNumber numberWithFloat:130] retain];
    
    
    NSLog(@"Normal weight is: %.2f", res);
};


- (IBAction)fitAll:(id)sender{
    [weightGraph showFullGraph];
};

- (IBAction)zoomIn:(id)sender{
    NSTimeInterval currentGrahTimeInterval = [weightGraph.toDateGraph timeIntervalSinceDate:weightGraph.fromDateGraph];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.fromDateGraph timeIntervalSince1970] + currentGrahTimeInterval/4];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.toDateGraph timeIntervalSince1970] - currentGrahTimeInterval/4];
    [weightGraph showGraphFromDate:startDate toDate:finishDate];
};

- (IBAction)zoomOut:(id)sender{
    NSTimeInterval currentGrahTimeInterval = [weightGraph.toDateGraph timeIntervalSinceDate:weightGraph.fromDateGraph];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.fromDateGraph timeIntervalSince1970] - currentGrahTimeInterval/4];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.toDateGraph timeIntervalSince1970] + currentGrahTimeInterval/4];
    [weightGraph showGraphFromDate:startDate toDate:finishDate];
};

- (IBAction)moveRight:(id)sender{
    NSTimeInterval currentGrahTimeInterval = [weightGraph.toDateGraph timeIntervalSinceDate:weightGraph.fromDateGraph];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.fromDateGraph timeIntervalSince1970] + currentGrahTimeInterval/4];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.toDateGraph timeIntervalSince1970] + currentGrahTimeInterval/4];
    [weightGraph showGraphFromDate:startDate toDate:finishDate];
};

- (IBAction)moveLeft:(id)sender{
    NSTimeInterval currentGrahTimeInterval = [weightGraph.toDateGraph timeIntervalSinceDate:weightGraph.fromDateGraph];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.fromDateGraph timeIntervalSince1970] - currentGrahTimeInterval/4];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSince1970:[weightGraph.toDateGraph timeIntervalSince1970] - currentGrahTimeInterval/4];
    [weightGraph showGraphFromDate:startDate toDate:finishDate];
};

@end
