//
//  ViewController.m
//  HealthCare
//
//  Created by Eugine Korobovsky on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DesktopViewController.h"
#import "ModuleTableCell.h"

@implementation DesktopViewController

@synthesize modulesTable;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Desktop";
    
    modulesArray = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    modulesTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
};

#pragma mark - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ModuleTableCellID";
    
    ModuleTableCell *cell = (ModuleTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ModuleTableCell" owner:self options:nil];
        for(id oneObject in nibs){
            if([oneObject isKindOfClass:[ModuleTableCell class]]){
                cell = (ModuleTableCell *)oneObject;
            };
        };
    };
    
    
    cell.moduleName.text = @"My module";
    cell.moduleDescription.text = @"this is the short description of this module";
    cell.moduleMessage.text = @"Hello from new module!";
        
    return cell;

};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0f;
};


@end
