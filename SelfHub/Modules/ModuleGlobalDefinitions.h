//
//  ModuleGlobalDefinitions.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef SelfHub_ModuleGlobalDefinitions_h
#define SelfHub_ModuleGlobalDefinitions_h

@protocol ModuleProtocol
- (NSString *)getModuleName;
- (NSString *)getModuleDescription;
- (NSString *)getModuleMessage;
- (float)getModuleVersion;
- (UIImage *)getModuleIcon;

- (void)loadModuleData;
- (void)saveModuleData;

@optional
- (void)didReceivedMemoryWarning;

@end



#endif
