//
//  Tag.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_Tag_h
#define ProChat_Tag_h

#import <Foundation/Foundation.h>
@class VKConnector;
@class Chat;

@interface Tag : NSObject

@property VKConnector* connector;
@property Chat* chat;

@property int tgId;
@property NSString* name;
@property NSString* mark;

//@property NSMutableDictionary* messages;

- (id)init:(VKConnector*)conn chat:(Chat*)ch tId:(int)tId
    tgName:(NSString*)name mark:(NSString*)mrk;
//- (void)loadMessages:(NSMutableDictionary*)dest;

@end

#endif