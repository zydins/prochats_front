//
//  MyHttpRequest.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#ifndef ProChat_MyHttpRequest_h
#define ProChat_MyHttpRequest_h

#import <Foundation/Foundation.h>
#import "Constants.h"
@class VKConnector;

typedef enum
{
    RQ1
    , RS1
    , RQ2
    , RS2_OK
    , RS2_ER
    , EX2
    , RQ3
    , RS3_OK
    , CONNECTIONERROR
} State;

typedef enum
{
    GET,
    PUT,
    POST,
} ReqTypeEnum;

typedef enum
{
    OK,
    CONNECTION_ERROR,
    ERROR
} ResponseStatusEnum;


@interface Response : NSObject

@property ResponseStatusEnum Status;
@property NSString *Message;

-(id)init:(ResponseStatusEnum)status message:(NSString *)message;

@end


@interface MyHttpRequest : NSObject {
    
@private ReqTypeEnum _type;
@private NSString* _url;
@private NSString* _params;
    
}

-(id)init:(ReqTypeEnum)type url:(NSString *)url params:(NSString *)params;


-(Response*) DoRequest;
//-(Response*) GET_Request;
//-(Response*) PUT_Request;
//-(Response*) POST_Request;

@end

#endif

