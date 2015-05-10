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

@implementation Chat

@synthesize connector;

@synthesize chatId;
@synthesize isGroup;

@synthesize name;
@synthesize imageUrl;

@synthesize messages;

- (id)init:(VKConnector*)conn chatId:(int)chat isGroup:(BOOL)group {
    self.connector = conn;
    self.chatId = chat;
    self.isGroup = group;
    
    self.messages = [[NSMutableDictionary alloc] init];
    
    
   // [connector.chats setValue:self forKey:[NSString stringWithFormat:@"%d", chat]];
    
    [self setData];
    
    connector.chats[@(chatId)] = self;
    return self;
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
    
    //
//    //-----------------messages
//    params = [NSString stringWithFormat:@"chat_id=%d&count=%d&access_token=%@", chatId, 2, connector.accessToken];
//    resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_GET_CHAT_MESSAGES params:params] DoRequest];
//    if (resp.Status == CONNECTION_ERROR)
//    {
//        [connector setConnectionError];
//        resp.Message = @"";
//    }
//    else
//    {
//        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSMutableDictionary *allCourses = [NSJSONSerialization
//                                           JSONObjectWithData:allCoursesData
//                                           options:NSJSONReadingMutableContainers
//                                           error:&error];
//        
//        NSArray* arr = [allCourses objectForKey:@"response"];
//        for (int i = 1; i < [arr count]; i++)
//        {
//            NSDictionary *dialogDict = arr[i];
//            int us = [[dialogDict valueForKey:@"from_id"] integerValue];
//            int mesid = [[dialogDict valueForKey:@"mid"] integerValue];
//            NSString* body = [dialogDict valueForKey:@"body"];
//            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[dialogDict valueForKey:date] integerValue]];
//            Message* ms = [[Message alloc] init:connector sender:[connector getUser:us]
//                                           chat:self messId:mesid date:date body:body];
//            int s = 1;
//        }
//    }
//    //-----------------messages
    
}

- (void)setUserData {
    
    name = [connector getUser:chatId].name;
    imageUrl = [connector getUser:chatId].imageUrl;
    
    [self loadMessages:1];
//    
//    //-----------------messages
//    NSString *params = [NSString stringWithFormat:@"user_id=%d&count=%d&access_token=%@", chatId, 1, connector.accessToken];
//    Response *resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_GET_CHAT_MESSAGES params:params] DoRequest];
//    if (resp.Status == CONNECTION_ERROR)
//    {
//        [connector setConnectionError];
//        resp.Message = @"";
//    }
//    else
//    {
//        NSData *allCoursesData = [resp.Message dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSMutableDictionary *allCourses = [NSJSONSerialization
//                                           JSONObjectWithData:allCoursesData
//                                           options:NSJSONReadingMutableContainers
//                                           error:&error];
//        
//        NSArray* arr = [allCourses objectForKey:@"response"];
//        for (int i = 1; i < [arr count]; i++)
//        {
//            NSDictionary *dialogDict = arr[i];
//            int us = [[dialogDict valueForKey:@"from_id"] integerValue];
//            int mesid = [[dialogDict valueForKey:@"mid"] integerValue];
//            NSString* body = [dialogDict valueForKey:@"body"];
//            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[dialogDict valueForKey:date] integerValue]];
//            Message* ms = [[Message alloc] init:connector sender:[connector getUser:us]
//                                           chat:self messId:mesid date:date body:body];
//        }
//    }
//    //-----------------messages
}

- (void)loadMessages:(int)count {
    
    messages = [[NSMutableDictionary alloc] init];
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
    
- (NSArray*) getSortedMessages {
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