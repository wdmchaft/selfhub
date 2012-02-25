//
//  ModuleHelper.h
//  SelfHub
//
//  Created by Eugine Korobovsky on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerProtocol
@required
- (BOOL)isModuleAvailableWithID:(NSString *)moduleID;
- (id)getValueForName:(NSString *)name fromModuleWithID:(NSString *)moduleID;
- (BOOL)setValue:(id)value forName:(NSString *)name forModuleWithID:(NSString *)moduleID;
@end

@protocol ModuleProtocol
@required
- (id)initModuleWithDelegate:(id<ServerProtocol>)serverDelegate;
- (NSString *)getModuleName;
- (NSString *)getModuleDescription;
- (NSString *)getModuleMessage;
- (float)getModuleVersion;
- (UIImage *)getModuleIcon;
- (BOOL)isInterfaceIdiomSupportedByModule:(UIUserInterfaceIdiom)idiom;
- (void)loadModuleData;
- (void)saveModuleData;

- (id)getModuleValueForKey:(NSString *)key;
- (void)setModuleValue:(id)object forKey:(NSString *)key;
@optional
- (void)didReceivedMemoryWarning;

@end

@interface ModuleHelper : NSObject {

}

+ (ModuleHelper *)sharedHelper;

- (BOOL)testExchangeListForModuleWithID:(NSString *)moduleID;

@end
