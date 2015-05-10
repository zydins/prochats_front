//
//  VKConnnectorProtocol.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_VKConnectorProtocol_h
#define ProChat_Header_h

#import <Foundation/Foundation.h>
#import "VKConnector.h"

@protocol VKConnnectorProtocol <NSObject>

@property VKConnector* Connector;

@end

#endif