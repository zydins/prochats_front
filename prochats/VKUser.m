//
//  VKUser.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//


#import "VKUser.h"
#import "VKConnector.h"
#import "MyHttpRequest.h"

@implementation VKUser

@synthesize userId;
@synthesize name;
@synthesize imageUrl;
@synthesize connector;

- (id)init:(VKConnector*)conn userId:(int)user {
    self.connector = conn;
    self.userId = user;
    
    [self setData];
    connector.users[@(userId)] = self;
    return self;
}

- (void)setData {
    
    NSString* params = [NSString stringWithFormat:@"user_ids=%d&fields=photo_200&access_token=%@", userId, connector.accessToken];
    
    Response *resp = [[[MyHttpRequest alloc] init:GET url:USER_GET params:params] DoRequest];
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
        NSDictionary *userDict = arr[0];
        name = [NSString stringWithFormat:@"%@ %@", [userDict valueForKey:@"first_name"], [userDict valueForKey:@"last_name"]];
        imageUrl = [userDict valueForKey:@"photo_200"];

    }
}

@end