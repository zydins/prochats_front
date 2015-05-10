//
//  Message.m
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//


#import "Message.h"
#import "VKConnector.h"
#import "MyHttpRequest.h"
#import "Chat.h"

@implementation Message

@synthesize connector;

@synthesize chat;
@synthesize sender;
@synthesize messId;
@synthesize date;
@synthesize body;

- (id)init:(VKConnector*)conn sender:(VKUser*)send
      chat:(Chat*)ch messId:(int)mess date:(NSDate*)messDate body:(NSString*)bd {
    self.connector = conn;
    self.chat = ch;
    self.sender = send;
    self.messId = mess;
    self.date = messDate;
    self.body = bd;
    
    self.chat.messages[@(messId)] = self;

    return self;
}

@end