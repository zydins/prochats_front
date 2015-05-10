//
//  VKConnector.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import "VKConnector.h"
#import "ConfFile.h"
#import "VKUser.h"
#import "MyHttpRequest.h"
#import "Chat.h"

@implementation VKConnector

@synthesize accessToken;
@synthesize serverToken;
@synthesize userId;
@synthesize config;
@synthesize status;
@synthesize users;
@synthesize chats;

-(id)init
{
    users = [[NSMutableDictionary alloc] init];
    chats = [[NSMutableDictionary alloc] init];
    
    config = [[ConfFile alloc] init:self path:@"UserData"];
    accessToken = [config ReadData:@"AccessToken"];
    userId = [config ReadData:@"UserId"];
    serverToken = [config ReadData:@"ServerToken"];
//    serverToken = nil;
//    [self authServer];
    if (accessToken == nil || [accessToken isEqual:@""])
        status = NeedAuth;
    else
    {
        [self authServer];
        
        status = Ready;
        users[@([userId intValue])] = [[VKUser alloc] init:self userId:[userId intValue]];
    }
    
    return self;
}

- (void)setConnectionError
{
    status = ConnectionError;
}

- (void)authServer {
    if (serverToken != nil && ![serverToken isEqualToString:@""])
        return;
    
    Response *resp = [[[MyHttpRequest alloc] init:POST url:SERVER_AUTH params:[NSString stringWithFormat:@"vk_token=%@\n",accessToken]] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [self setConnectionError];
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
        
        NSString* str = [allCourses valueForKey:@"token"];
        serverToken = str;
        [config WriteData:@"ServerToken" data:str];
    }

}

- (VKUser*)getUser:(int)usId {
    VKUser* us = users[@(usId)];
    if (us == nil)
    {
        us = [[VKUser alloc] init:self userId:usId];
    }
    return us;
        
}

- (VKUser*)getMe {
    return [self getUser:[userId integerValue]];
}

- (void)loadChats {
    NSString* params = [NSString stringWithFormat:@"access_token=%@", accessToken];
    Response *resp = [[[MyHttpRequest alloc] init:GET url:MESSAGES_GET_CHATS params:params] DoRequest];
    if (resp.Status == CONNECTION_ERROR)
    {
        [self setConnectionError];
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
        for (int i = 1; i < 8; i++)
        {
            NSDictionary *dialogDict = arr[i];
            
            BOOL isGroup = YES;
            int chatId = [[dialogDict valueForKey:@"chat_id"] integerValue];
            if (chatId == 0)
            {
                chatId = [[dialogDict valueForKey:@"uid"] integerValue];
                isGroup = NO;
            }
            Chat* tc = [[Chat alloc] init:self chatId:chatId isGroup:isGroup];
        }
    }
}

@end
