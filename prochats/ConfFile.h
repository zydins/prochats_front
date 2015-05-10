//
//  ConfFile.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_ConfFile_h
#define ProChat_ConfFile_h

#import <Foundation/Foundation.h>
#import "Constants.h"
@class VKConnector;

@interface ConfFile : NSObject

@property NSString *path;
@property NSMutableDictionary *plistDict;
@property VKConnector *connector;

-(id)init:(VKConnector *)sender path:(NSString *)name;

-(NSString *)ReadData:(NSString *)key;

-(void)WriteData:(NSString *)key data:(NSString *)data;

-(NSMutableDictionary*)GetDict;

@end

#endif