//
//  VKUser.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_VKUser_h
#define ProChat_VKUser_h

#import <Foundation/Foundation.h>
@class VKConnector;

@interface VKUser : NSObject

@property int userId;
@property VKConnector* connector;

@property NSString* name;
@property NSString* imageUrl;

- (id)init:(VKConnector*)connector userId:(int)user;
- (void)setData;

@end

#endif

