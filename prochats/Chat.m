//
//  VKUser.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//


#import "Chat.h"
#import "VKConnector.h"
#import "MyHttpRequest.h"
#import "Message.h"
#import "VKUser.h"
#import "Tag.h"

@implementation Chat

@synthesize connector;

@synthesize chatId;
@synthesize isGroup;

@synthesize name;
@synthesize imageUrl;

@synthesize messages;
@synthesize tags;

- (id)init:(VKConnector*)conn chatId:(int)chat isGroup:(BOOL)group {
    self.connector = conn;
    self.chatId = chat;
    self.isGroup = group;
    
    self.messages = [[NSMutableDictionary alloc] init];
    self.tags = [[NSMutableDictionary alloc] init];
    
    
   // [connector.chats setValue:self forKey:[NSString stringWithFormat:@"%d", chat]];
    
    [self setData];
    
    connector.chats[@(chatId)] = self;
    return self;
}


- (NSMutableArray*)getSortedMessages {
    NSArray *keysArray;
    
    keysArray = [messages keysSortedByValueUsingComparator: ^(Message *obj1, Message *obj2) {
        
        if (obj1.date > obj2.date) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (obj1.date < obj2.date) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *valuesArray = [[NSMutableArray alloc] initWithCapacity:[keysArray count]];
    for (int i = 0; i < [keysArray count]; i++) {
        //long key = keysArray[i];
        Message* ms = messages[keysArray[i]];
        valuesArray[i] = ms;
    }
    
    return valuesArray;
}

- (void)setData {
    if (isGroup)
        [self setGroupData];
    else
        [self setUserData];
}

- (void)setGroupData {
    //-----------------title
    NSString* params = [NSString stringWithFormat:@"chat_id=%d&access_token=%@", chatId, connector.accessToken];
    Response *resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_GET_CHATS params:params] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [connector setConnectionError];
        resp.Message = @"";
    }
    else
    {
        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *allCourses = [NSJSONSerialization
                                           JSONObjectWithData:allCoursesData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
        
        NSArray* arr = [allCourses objectForKey:@"response"];
        NSDictionary *userDict = arr[1];
        name = [userDict valueForKey:@"title"];
    }
    //-----------------title
    
    [self loadMessages:1];
    
}

- (void)setUserData {
    
    name = [connector getUser:chatId].name;
    imageUrl = [connector getUser:chatId].imageUrl;
    
    [self loadMessages:1];
}

- (void)loadMessages:(int)count {
    NSString* params = @"";
    
    if (isGroup)
        params = [NSString stringWithFormat:@"chat_id=%d&count=%d&access_token=%@",
                  chatId, count, connector.accessToken];
    else
        params = [NSString stringWithFormat:@"user_id=%d&count=%d&access_token=%@",
                  chatId, count, connector.accessToken];
    
    if ([messages count] > 0)
        params = [NSString stringWithFormat:@"%@&offset=", params, [messages count]];
    
    Response *resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_GET_CHAT_MESSAGES params:params] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [connector setConnectionError];
        resp.Message = @"";
    }
    else
    {
        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *allCourses = [NSJSONSerialization
                                           JSONObjectWithData:allCoursesData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
        
        NSArray* arr = [allCourses objectForKey:@"response"];
        for (int i = 1; i < [arr count]; i++)
        {
            NSDictionary *dialogDict = arr[i];
            int us = [[dialogDict valueForKey:@"from_id"] integerValue];
            int mesid = [[dialogDict valueForKey:@"mid"] integerValue];
            NSString* body = [dialogDict valueForKey:@"body"];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[dialogDict objectForKey:@"date"] doubleValue]];
            Message* ms = [[Message alloc] init:connector sender:[connector getUser:us]
                                           chat:self messId:mesid date:date body:body];
        }
    }
}


- (void)loadTags {
    NSString* params = [NSString stringWithFormat:@"chat_id=%d&timestamp=%d", chatId, 1431105200];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:connector.serverToken forKey:@"Authentication"];
    Response *resp = [[[MyHttpRequest alloc] init:GET url:SERVER_GET_TAGS params:params headers:dict] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [connector setConnectionError];
        resp.Message = @"";
    }
    else
    {
        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *allCourses = [NSJSONSerialization
                                           JSONObjectWithData:allCoursesData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
        
        NSArray* arr = [allCourses objectForKey:@"tags"];
        
        for (int i = 0; i < [arr count]; i++)
        {
            NSDictionary *dialogDict = arr[i];
            NSString* mark = [dialogDict valueForKey:@"mark"];
            NSString* name = [dialogDict valueForKey:@"name"];
            int tgid = [[dialogDict valueForKey:@"tag_id"] integerValue];
            
            Tag* tg = [[Tag alloc] init:connector chat:self tId:tgid tgName:name mark:mark];
            
        }
    }
    
}

- (void)loadMessagesForTag {
    messages = [[NSMutableDictionary alloc] init];
    NSArray* arr = [tags allKeys];
    NSMutableDictionary* mesIds = [[NSMutableDictionary alloc] init];
    NSString* tgids = @"";
    if ([arr count] > 0)
    {
        Tag* tg = tags[arr[0]];
        tgids = [NSString stringWithFormat:@"%d", tg.tgId];
    }
    else
        return;
    
    for (int i = 1; i < [arr count]; i++)
    {
        Tag* tg = tags[arr[i]];
        tgids = [NSString stringWithFormat:@"%@,%d", tgids, tg.tgId];
    }
    
    NSString* messid = @"";
    
    
    NSString* params = [NSString stringWithFormat:@"chat_id=%d&tag_ids=%@", chatId, tgids];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:connector.serverToken forKey:@"Authentication"];
    Response *resp = [[[MyHttpRequest alloc] init:GET url:SERVER_GET_MES_BY_TAGS params:params headers:dict] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [connector setConnectionError];
        resp.Message = @"";
    }
    else
    {
        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *allCourses = [NSJSONSerialization
                                           JSONObjectWithData:allCoursesData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
        
        NSArray* arr = [allCourses objectForKey:@"messages"];
        
        if ([arr count] > 0)
        {
            NSDictionary *dialogDict = arr[0];
            messid = [NSString stringWithFormat:@"%@", [dialogDict valueForKey:@"message_id"]];
        }

        
        for (int i = 1; i < [arr count]; i++)
        {
            NSDictionary *dialogDict = arr[i];
            messid = [NSString stringWithFormat:@"%@,%@", messid,[dialogDict valueForKey:@"message_id"]];
        }
        
        
        params = [NSString stringWithFormat:@"message_ids=%@&access_token=%@", messid, connector.accessToken];
        Response *resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_GET_BY_ID params:params] DoRequest];
        if (resp.Status == CONNECTION_ERROR)
        {
            [connector setConnectionError];
            resp.Message = @"";
        }
        else
        {
            NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSMutableDictionary *allCourses = [NSJSONSerialization
                                               JSONObjectWithData:allCoursesData
                                               options:NSJSONReadingMutableContainers
                                               error:&error];
            
            NSArray* arr = [allCourses objectForKey:@"response"];
            for (int i = 1; i < [arr count]; i++)
            {
                NSDictionary *dialogDict = arr[i];
                int us = [[dialogDict valueForKey:@"from_id"] integerValue];
                int mesid = [[dialogDict valueForKey:@"mid"] integerValue];
                NSString* body = [dialogDict valueForKey:@"body"];
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[dialogDict objectForKey:@"date"] doubleValue]];
                Message* ms = [[Message alloc] init:connector sender:[connector getUser:us]
                                               chat:self messId:mesid date:date body:body];
            }
        }

        
    }
    
}


- (int)sendMessage:(NSString*)mess {
    NSString* params;
    if (isGroup)
        params = [NSString stringWithFormat:@"chat_id=%d&message=%@&access_token=%@", chatId, mess, connector.accessToken];
    else
        params = [NSString stringWithFormat:@"user_id=56067283&message=%@&access_token=%@", mess, connector.accessToken];
    
    Response *resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_SEND params:params] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [connector setConnectionError];
        resp.Message = @"";
    }
    else
    {
        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSMutableDictionary *allCourses = [NSJSONSerialization
                                           JSONObjectWithData:allCoursesData
                                           options:NSJSONReadingMutableContainers
                                           error:&error];
        
        int mesid = [allCourses valueForKey:@"response"];
        Message* mes = [[Message alloc] init:connector sender:connector.getMe chat:self messId:mesid date:[NSDate date] body:mess];
        
        return mesid;
    }
    return -1;
}

@end