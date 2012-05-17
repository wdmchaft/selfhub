//
//  WeightControlData.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeightControlData.h"

@interface WeightControlData ()

@end

@implementation WeightControlData

@synthesize delegate;
@synthesize dataTableView;

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
    detailView = nil;
    deletedRow = nil;
    
    detailView = [[WeightControlDataEdit alloc] initWithNibName:@"WeightControlDataEdit" bundle:nil];
    detailView.delegate = self;
    [detailView loadView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    delegate = nil;
    dataTableView = nil;
}

-(void)dealloc{
    [dataTableView release];
    if(detailView) [detailView release];
    if(deletedRow) [deletedRow release];
    [detailView release];
   
    [super dealloc];
};

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [delegate.weightData count]+1;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier;
    if([indexPath row]==0){
        CellIdentifier = @"addCellID";
        
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (addCell == nil) {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            addCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIButton *addContactButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [addContactButton addTarget:self action:@selector(addDataRecord) forControlEvents:UIControlEventTouchUpInside];
            addCell.accessoryView = addContactButton;
            addCell.textLabel.textAlignment = UITextAlignmentCenter;
            addCell.textLabel.text = @"Add data";
        };
        
        return addCell;
    };
    
    CellIdentifier = @"dataRecordCellID";
    NSUInteger curRecIndex = [delegate.weightData count] - [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    };
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy (EEEE)"];
    NSString *dateString = [dateFormatter stringFromDate:[[delegate.weightData objectAtIndex:curRecIndex] objectForKey:@"date"]];
    [dateFormatter release];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", dateString];
    //NSString *deltaStr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f kg", [[[delegate.weightData objectAtIndex:curRecIndex] objectForKey:@"weight"] floatValue]];
    
    return cell;

};


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSUInteger curRecIndex = [delegate.weightData count] - [indexPath row];
    
    detailView.editingRecordIndex = curRecIndex;
    detailView.datePick.date = [[delegate.weightData objectAtIndex:curRecIndex] objectForKey:@"date"];
    detailView.weightStepper.value = [[[delegate.weightData objectAtIndex:curRecIndex] objectForKey:@"weight"] floatValue];
    
    [delegate.navigationController pushViewController:detailView animated:YES];
};

- (IBAction)addDataRecord{
    detailView.editingRecordIndex = -1;
    detailView.datePick.date = [NSDate date];
    
    NSNumber *weightFromAntropometry = [delegate.delegate getValueForName:@"weight" fromModuleWithID:@"selfhub.antropometry"];
    if(weightFromAntropometry==nil){
        weightFromAntropometry = [NSNumber numberWithFloat:75.0f];
    };
    detailView.weightStepper.value = [weightFromAntropometry floatValue];
    
    [delegate.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)finishEditingRecord{
    NSDate *newDate = [delegate getDateWithoutTime:detailView.datePick.date];
    NSNumber *newWeight = [NSNumber numberWithFloat:detailView.weightStepper.value];
    NSComparisonResult compRes;
    NSUInteger curIndex = 0;
    NSDictionary *newRec;
    
    if(detailView.editingRecordIndex==-1){ //Adding new record
        for(NSDictionary *oneRecord in delegate.weightData){
            compRes = [delegate compareDateByDays:newDate WithDate:[oneRecord objectForKey:@"date"]];
            if(compRes==NSOrderedSame){
                [delegate.weightData removeObject:oneRecord];
                break;
            };
            
            if(compRes==NSOrderedAscending){
                break;
            };
            
            curIndex++;
        };
        
        newRec = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:newDate, newWeight, nil] forKeys:[NSArray arrayWithObjects:@"date", @"weight", nil]];
        [delegate.weightData insertObject:newRec atIndex:curIndex];
    }else{      //Finish editing existing record
        compRes = [delegate compareDateByDays:newDate WithDate:[[delegate.weightData objectAtIndex:detailView.editingRecordIndex] objectForKey:@"date"]];
        [delegate.weightData removeObjectAtIndex:detailView.editingRecordIndex];
        for(NSDictionary *oneRecord in delegate.weightData){
            compRes = [delegate compareDateByDays:newDate WithDate:[oneRecord objectForKey:@"date"]];
            if(compRes==NSOrderedSame){
                [delegate.weightData removeObject:oneRecord];
                break;
            };
            if(compRes==NSOrderedAscending){
                break;
            };
            curIndex++;
        };
        newRec = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:newDate, newWeight, nil] forKeys:[NSArray arrayWithObjects:@"date", @"weight", nil]];
        [delegate.weightData insertObject:newRec atIndex:curIndex];
    };
    
    if([delegate compareDateByDays:newDate WithDate:[NSDate date]] == NSOrderedSame){   //Setting weight in antropometry module
        [delegate.delegate setValue:newWeight forName:@"weight" forModuleWithID:@"selfhub.antropometry"];
    }
    
    [dataTableView reloadData];
    [dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:([delegate.weightData count] - curIndex) inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
};

- (IBAction)pressEdit{
    [dataTableView setEditing:!(dataTableView.isEditing)];
};

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0) return NO;
    
    return YES;
};

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(deletedRow!=nil) [deletedRow release];
    deletedRow = nil;
	deletedRow = [indexPath retain];//[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]]; //indexPath;
    //NSLog(@"deleted row: %d, %d",[deletedRow section], [deletedRow row]);
    
	UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to erase this record?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Erase", @"") otherButtonTitles:nil];
	[actionSheet showInView:self.view];
	[actionSheet release];  
}


#pragma mark - UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
        NSUInteger curRecordIndex = [delegate.weightData count] - [deletedRow row];
		[delegate.weightData removeObjectAtIndex:curRecordIndex];
		[dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletedRow] withRowAnimation:UITableViewRowAnimationFade];
	};
};



@end
