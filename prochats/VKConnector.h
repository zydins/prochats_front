//
//  VKConnector.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_VKConnector_h
#define ProChat_VKConnector_h

#import <Foundation/Foundation.h>

typedef enum
{
    Ready,
    NeedAuth,
    ConnectionError
} ConnectorReadyEnum;


@class ConfFile;
@class VKUser;

@interface VKConnector : NSObject

//users:access by id
@property NSMutableDictionary* users;
@property NSMutableDictionary* chats;

@property NSString *accessToken;
@property NSString *userId;
@property ConfFile *config; //file with accesstoken and userid
@property ConnectorReadyEnum status;

- (id)init;
- (void)setConnectionError;
- (void)loadChats;
- (VKUser*)getUser:(int)usId;

@end

#endif