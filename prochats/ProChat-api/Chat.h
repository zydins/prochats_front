//
//  Chat.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_Chat_h
#define ProChat_Chat_h

#import <Foundation/Foundation.h>
@class VKConnector;

@interface Chat : NSObject

@property VKConnector* connector;

@property int chatId;

@property BOOL isGroup;

@property NSString* name;
@property NSString* imageUrl;

@property NSMutableDictionary* messages;

- (id)init:(VKConnector*)conn chatId:(int)chat isGroup:(BOOL)group;
- (void)setData;
- (void)loadMessages:(int)count;

@end

#endif