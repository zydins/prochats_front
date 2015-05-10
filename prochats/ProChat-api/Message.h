//
//  Message.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_Message_h
#define ProChat_Message_h

#import <Foundation/Foundation.h>
@class VKConnector;
@class VKUser;
@class Chat;

@interface Message : NSObject

@property VKConnector* connector;

@property VKUser* sender;
@property Chat* chat;
@property int messId;
@property NSDate* date;
@property NSString* body;

- (id)init:(VKConnector*)conn sender:(VKUser*)sender
      chat:(Chat*)chat messId:(int)messId date:(NSDate*)messDate body:(NSString*)bd;


@end

#endif

