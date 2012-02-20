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
    
    MainInformation *antropometryModule = [[MainInformation alloc] initWithNibName:@"MainInformation" bundle:nil];
    [antropometryModule loadModuleData];
    [modulesArray addObject:antropometryModule];
    [antropometryModule release];
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
    
    [modulesTable reloadData];
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
    return [modulesArray count];
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
    
    
    UIViewController<ModuleProtocol> *curModuleController;
    curModuleController = [modulesArray objectAtIndex:[indexPath row]];
    cell.moduleName.text = [curModuleController getModuleName];
    cell.moduleDescription.text = [curModuleController getModuleDescription];
    cell.moduleMessage.text = [curModuleController getModuleMessage];
    cell.moduleIcon.image = [curModuleController getModuleIcon];
        
    return cell;

};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0f;
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController<ModuleProtocol> *curModuleController;
    curModuleController = [modulesArray objectAtIndex:[indexPath row]];
    
    [self.navigationController pushViewController:curModuleController animated:YES];
};


@end
