//
//  Constants.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_Constants_h
#define ProChat_Constants_h

#import <Foundation/Foundation.h>

@interface Constants : NSObject

FOUNDATION_EXPORT NSString *const USER_GET;

FOUNDATION_EXPORT NSString *const MESSAGES_GET_CHATS;
FOUNDATION_EXPORT NSString *const MESSAGES_GET_CHAT_MESSAGES;
FOUNDATION_EXPORT NSString *const MESSAGES_GET_GROUP_CHAT;

FOUNDATION_EXPORT NSString *const SERVER_AUTH;
FOUNDATION_EXPORT NSString *const SERVER_GET_TAGS;
FOUNDATION_EXPORT NSString *const SERVER_GET_MES_BY_TAGS;

FOUNDATION_EXPORT NSString *const MESSAGES_SEND;
FOUNDATION_EXPORT NSString *const MESSAGES_GET_BY_ID;

@end

#endif