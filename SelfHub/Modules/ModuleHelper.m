//
//  ModuleHelper.m
//  SelfHub
//
//  Created by Eugine Korobovsky on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModuleHelper.h"

@implementation ModuleHelper

+ (ModuleHelper *)sharedHelper{
    return [[[self alloc] init] autorelease];
};

- (BOOL)testExchangeListForModuleWithID:(NSString *)moduleID{
    NSLog(@"******************* TESTING MODULE %@ *******************", moduleID);
    NSArray *modulesArray = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:@"AllModules" ofType:@"plist"]]){
        modulesArray = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AllModules" ofType:@"plist"]] objectForKey:@"modules"];
    };
    if(modulesArray==nil){
        NSLog(@"testExchangeListForModuleWithID ERROR: cannot read data from AllModules.plist");
        return NO;
    };
    
    BOOL isModuleFinding = NO;
    NSDictionary *curModuleDescription = nil;
    for(curModuleDescription in modulesArray){
        if([[curModuleDescription objectForKey:@"ID"] isEqualToString:moduleID]){
            isModuleFinding = YES;
            break;
        };
    };
    if(isModuleFinding==NO){
        NSLog(@"testExchangeListForModuleWithID ERROR: cannot find module description");
        return NO;
    };
    
    
    NSString *moduleExchangeFileName = [curModuleDescription objectForKey:@"ExchangeFile"];
    if(moduleExchangeFileName==nil || 
       [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:[moduleExchangeFileName stringByDeletingPathExtension] ofType:nil]] ){
        NSLog(@"testExchangeListForModuleWithID ERROR: cannot find module exchange file");
        return NO;
    };
    NSArray *moduleExchangeList = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:moduleExchangeFileName ofType:nil]] objectForKey:@"items"];
    if(moduleExchangeList == nil){
        NSLog(@"testExchangeListForModuleWithID ERROR: exchange list is empty. Check format of exchange file (plist, one item with name \"items\".");
        return NO;
    };
    
    //UIViewController *curModule = [curModuleDescription objectForKey:@"viewController"];
    //if(curModule == nil){
    //    NSLog(@"testExchangeListForModuleWithID ERROR: cannot find view controler");
    //    return NO;
    //};
    Class curModuleClass;
    id module;
    curModuleClass = NSClassFromString([curModuleDescription objectForKey:@"Interface"]);
    module = [[curModuleClass alloc] initModuleWithDelegate:nil];
    if(module == nil){
        NSLog(@"testExchangeListForModuleWithID ERROR: cannot create view controler");
        return NO;
    };
    [module loadModuleData];
    
    
    NSLog(@"Exchanging values:");
    NSDictionary *curExchangeValue = nil;
    
    NSString *name = nil;
    NSString *keyPath = nil;
    NSString *type = nil;
    NSNumber *readonlyNumber = nil;
    BOOL isReadOnly;
    NSString *description = nil;
    
    //Class valueType;
    id oneValue = nil;
    
    for(curExchangeValue in moduleExchangeList){
        name = [curExchangeValue objectForKey:@"name"];
        if(name==nil){
            NSLog(@"testExchangeListForModuleWithID ERROR: cannot retrieve name of exchange object");
            continue;
        };
        
        keyPath = [curExchangeValue objectForKey:@"keypath"];
        if(keyPath==nil){
            NSLog(@"%@: no keypath", name);
            continue;
        };
        
        type = [curExchangeValue objectForKey:@"type"];
        if(type==nil){
            NSLog(@"%@ (%@): no value type", name, keyPath);
            continue;
        };
        
        isReadOnly = NO;
        readonlyNumber = [curExchangeValue objectForKey:@"readonly"];
        if(readonlyNumber!=nil){
            isReadOnly = [readonlyNumber boolValue];
        };
        
        //valueType = NSClassFromString(type);
        //oneValue = [[valueType alloc] initWithString:[curModule valueForKeyPath:keyPath]];
        
        // READ TEST
        oneValue = [module valueForKeyPath:keyPath];
        if(oneValue==nil){
            NSLog(@"%@ (%@) of type %@: READ ERROR (nil object returned)", name, keyPath, type);
            continue;
        };
        
        if(isReadOnly==NO){ // WRITE TEST
            [module setValue:oneValue forKeyPath:keyPath];
        };
        
        description = [curExchangeValue objectForKey:@"description"];
        
        NSLog(@"%@ (%@) of type %@: %@ %@ (%@)", name, keyPath, type, [oneValue description], (isReadOnly ? @"<readonly>" : @""), (description==nil || [description length]==0 ? @"no description" : description));
        
    };

    [module release];
    
    return YES;
};

@end
