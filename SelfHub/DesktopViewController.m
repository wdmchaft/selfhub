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
    
    //NSMutableArray *tmpModulesArray = [[NSMutableArray alloc] init];
    
    NSArray *listFromPList = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:@"AllModules" ofType:@"plist"]]){
        listFromPList = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AllModules" ofType:@"plist"]] objectForKey:@"modules"];
    };
    if(listFromPList==nil){
        NSLog(@"Error: cannot read data from AllModules.plist");
    };
    
    NSMutableArray *totalArrayTmp = [[NSMutableArray alloc] init];
    NSMutableDictionary *tmpModuleInfo;
    
    Class curModuleClass;
    id module;
    for(NSDictionary *oneModuleInfo in listFromPList){
        tmpModuleInfo = [[NSMutableDictionary alloc] initWithDictionary:oneModuleInfo];
        
        curModuleClass = NSClassFromString([oneModuleInfo objectForKey:@"Interface"]);
        module = [[curModuleClass alloc] initModuleWithDelegate:self];
        [module loadModuleData];
        [tmpModuleInfo setValue:module forKey:@"viewController"];
        [module release];
        
        [totalArrayTmp addObject:tmpModuleInfo];
        [tmpModuleInfo release];
    };
    
    modulesArray = [[NSArray alloc] initWithArray:totalArrayTmp];
    [totalArrayTmp release];
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
    curModuleController = [[modulesArray objectAtIndex:[indexPath row]] objectForKey:@"viewController"];
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
    //NSLog(@"%@", [[modulesArray objectAtIndex:0] valueForKeyPath:@"moduleData.name"]);
    [self setValue:@"Hello, my darling!" forName:@"surname" forModuleWithID:@"selfhub.antropometry"];
    
    UIViewController<ModuleProtocol> *curModuleController;
    curModuleController = [[modulesArray objectAtIndex:[indexPath row]] objectForKey:@"viewController"];
    
    [self.navigationController pushViewController:curModuleController animated:YES];
};

#pragma mark - ServerProtocol functions

- (BOOL)isModuleAvailableWithID:(NSString *)moduleID{
    for(NSDictionary *oneModuleInfo in modulesArray){
        if([[oneModuleInfo objectForKey:@"ID"] isEqualToString:moduleID]){
            return YES;
        }
    };
    return NO;
};

- (id)getValueForName:(NSString *)name fromModuleWithID:(NSString *)moduleID{
    BOOL isModuleExist = NO;
    NSMutableDictionary *oneModuleInfo;
    for(oneModuleInfo in modulesArray){
        if([[oneModuleInfo objectForKey:@"ID"] isEqualToString:moduleID]){
            isModuleExist = YES;
            break;
        };
    };
    if(isModuleExist==NO){
        NSLog(@"WARNING: getValueForName:fromModuleWithID: cannot find module with ID \"%@\"", moduleID);
        return nil;
    };
    
    NSArray *moduleExchangeList = [oneModuleInfo objectForKey:@"ExchangeList"];
    if(moduleExchangeList==nil){
        NSString *moduleExchangeFileName = [oneModuleInfo objectForKey:@"ExchangeFile"];
        if(moduleExchangeFileName==nil || 
           [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:[moduleExchangeFileName stringByDeletingPathExtension] ofType:nil]] ){
            NSLog(@"WARNING: getValueForName:fromModuleWithID: cannot find module exchange file for module with ID \"%@\"", moduleID);
            return nil;
        };
        
        moduleExchangeList = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:moduleExchangeFileName ofType:nil]] objectForKey:@"items"];
        if(moduleExchangeList == nil){
            NSLog(@"WARNING: getValueForName:fromModuleWithID: exchange list is empty in module with ID \"%@\". Check format of exchange file (plist, one item with name \"items\".", moduleID);
            return nil;
        };
        [oneModuleInfo setObject:moduleExchangeList forKey:@"ExchangeList"];
    };
    
    BOOL isObjectExist = NO;
    NSDictionary *oneExchangeEntry;
    for(oneExchangeEntry in moduleExchangeList){
        if([[oneExchangeEntry objectForKey:@"name"] isEqualToString:name]){
            isObjectExist = YES;
            break;
        };
    };
    if(isObjectExist==NO){
        NSLog(@"WARNING: getValueForName:fromModuleWithID: cannot find exchange object \"%@\" in module with ID \"%@\"", name, moduleID);
        return nil;
    };
    
    UIViewController *curModule = [oneModuleInfo objectForKey:@"viewController"];
    if(curModule == nil){
        NSLog(@"WARNING: getValueForName:fromModuleWithID: cannot find view controler for module with ID \"%@\"", moduleID);
        return nil;
    };
    
    NSString *keyPath = [oneExchangeEntry objectForKey:@"keypath"];
    if(keyPath==nil){
        NSLog(@"WARNING: getValueForName:fromModuleWithID: cannot retrieve keypath for exchange object \"%@\" in module with ID \"%@\"", name, moduleID);
        return nil;
    };
    
    id resultValue = [curModule valueForKeyPath:keyPath];
    if(resultValue==nil){
        NSLog(@"WARNING: getValueForName:fromModuleWithID: retrieved empty exchange object \"%@\" in module with ID \"%@\"", name, moduleID);
        return nil;
    }
    
    return resultValue;
};

- (BOOL)setValue:(id)value forName:(NSString *)name forModuleWithID:(NSString *)moduleID{
    BOOL isModuleExist = NO;
    NSMutableDictionary *oneModuleInfo;
    for(oneModuleInfo in modulesArray){
        if([[oneModuleInfo objectForKey:@"ID"] isEqualToString:moduleID]){
            isModuleExist = YES;
            break;
        };
    };
    if(isModuleExist==NO){
        NSLog(@"WARNING: setValue:forName:fromModuleWithID: cannot find module with ID \"%@\"", moduleID);
        return NO;
    };
    
    NSArray *moduleExchangeList = [oneModuleInfo objectForKey:@"ExchangeList"];
    if(moduleExchangeList==nil){
        NSString *moduleExchangeFileName = [oneModuleInfo objectForKey:@"ExchangeFile"];
        if(moduleExchangeFileName==nil || 
           [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:[moduleExchangeFileName stringByDeletingPathExtension] ofType:nil]] ){
            NSLog(@"WARNING: setValue:forName:fromModuleWithID: cannot find module exchange file for module with ID \"%@\"", moduleID);
            return NO;
        };
        
        moduleExchangeList = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:moduleExchangeFileName ofType:nil]] objectForKey:@"items"];
        if(moduleExchangeList == nil){
            NSLog(@"WARNING: setValue:forName:fromModuleWithID: exchange list is empty in module with ID \"%@\". Check format of exchange file (plist, one item with name \"items\".", moduleID);
            return NO;
        };
        [oneModuleInfo setObject:moduleExchangeList forKey:@"ExchangeList"];
    };
    
    BOOL isObjectExist = NO;
    NSDictionary *oneExchangeEntry;
    for(oneExchangeEntry in moduleExchangeList){
        if([[oneExchangeEntry objectForKey:@"name"] isEqualToString:name]){
            isObjectExist = YES;
            break;
        };
    };
    if(isObjectExist==NO){
        NSLog(@"WARNING: setValue:forName:fromModuleWithID: cannot find exchange object \"%@\" in module with ID \"%@\"", name, moduleID);
        return NO;
    };
    
    UIViewController *curModule = [oneModuleInfo objectForKey:@"viewController"];
    if(curModule == nil){
        NSLog(@"WARNING: setValue:forName:fromModuleWithID: cannot find view controler for module with ID \"%@\"", moduleID);
        return NO;
    };
    
    NSString *keyPath = [oneExchangeEntry objectForKey:@"keypath"];
    if(keyPath==nil){
        NSLog(@"WARNING: setValue:forName:fromModuleWithID: cannot retrieve keypath for exchange object \"%@\" in module with ID \"%@\"", name, moduleID);
        return NO;
    };
    
    NSNumber *isValueReadonly = [oneExchangeEntry objectForKey:@"readonly"];
    if(isValueReadonly!=nil && [isValueReadonly boolValue]==YES){
        NSLog(@"WARNING: setValue:forName:fromModuleWithID: cannot set READ-ONLY exchange object \"%@\" in module with ID \"%@\"", name, moduleID);
        return NO;
    }
    
    [curModule setValue:value forKeyPath:keyPath];    
    
    return YES;
};

@end
