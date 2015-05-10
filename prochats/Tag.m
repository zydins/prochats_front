//
//  Tag.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//


#import "Tag.h"
#import "VKConnector.h"
#import "MyHttpRequest.h"
#import "Message.h"
#import "VKUser.h"
#import "Chat.h"

@implementation Tag

@synthesize connector;

@synthesize chat;
@synthesize tgId;
@synthesize name;
@synthesize mark;

//@synthesize messages;

- (id)init:(VKConnector*)conn chat:(Chat*)ch tId:(int)tId
    tgName:(NSString*)tName mark:(NSString*)mrk {
    connector = conn;
    chat = ch;
    tgId = tId;
    name = tName;
    mark = mrk;
    
    chat.tags[@(tgId)] = self;
    
    return self;
}

//- (void)loadMessages:(NSMutableDictionary*)dest {
//    NSString* params = [NSString stringWithFormat:@"chat_id=%d&timestamp=%d", chatId, 1430784000];
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:connector.serverToken forKey:@"Authentication"];
//    Response *resp = [[[MyHttpRequest alloc] init:GET url:SERVER_GET_TAGS params:params headers:dict] DoRequest];
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
//        NSArray* arr = [allCourses objectForKey:@"tags"];
//        
//        for (int i = 0; i < [arr count]; i++)
//        {
//            NSDictionary *dialogDict = arr[i];
//            NSString* mark = [dialogDict valueForKey:@"mark"];
//            NSString* name = [dialogDict valueForKey:@"name"];
//            int tgid = [dialogDict valueForKey:@"tag_id"];
//            
//            Tag* tg = [[Tag alloc] init:connector chat:self tId:tgid tgName:name mark:mark];
//            
//        }
//    }
//}
@end
