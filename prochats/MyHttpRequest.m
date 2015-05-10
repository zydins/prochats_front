//
//  MyHttpRequest.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import "MyHttpRequest.h"
#import "VKConnector.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation Response

@synthesize Status;
@synthesize Message;

-(id)init:(ResponseStatusEnum)status message:(NSString *)message
{
    Status = status;
    Message = message;
    return self;
}

@end


@implementation MyHttpRequest

-(id)init:(ReqTypeEnum)type url:(NSString *)url params:(NSString *)params
{
    _type = type;
    _url = url;
    _params = params;
    return self;
}

-(id)init:(ReqTypeEnum)type url:(NSString *)url params:(NSString *)params
  headers:(NSMutableDictionary*)head {
    _type = type;
    _url = url;
    _params = params;
    _headers = head;
    return self;
}

-(Response*) DoRequest
{
    if (_type == GET)
        return [self GET_Request];
    if (_type == PUT)
        return [self PUT_Request];
    
    return [self POST_Request];
}


-(void)resumeSession:(NSURLSessionDataTask*)dataTask
{
    [dataTask resume];
}

-(Response*) GET_Request
{
    NSString *url_str = [NSString stringWithFormat:@"%@?%@", _url, _params];
    url_str = [url_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    if (_headers != nil)
    {
        [request setAllHTTPHeaderFields:_headers];
    }
       // [request setHTTPBody:[_headers dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:url_str]];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if (error.code == -1009)
    {
        return [[Response alloc]init:CONNECTION_ERROR message:@""];
    }
    
    NSString *ans = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    if ([ans rangeOfString:@"error\":{\"error_code\":6"].location == 2)
    {
        [NSThread sleepForTimeInterval:1];
        return [self DoRequest];
    }
    
    if ([ans rangeOfString:@"error\":{\"error_code\":"].location == 2)
        return [[Response alloc]init:ERROR message:ans];
    
    
    return [[Response alloc]init:OK message:ans];
}

-(Response*) POST_Request
{
    NSString *urlString = _url;
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"%@", _params]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    // Get Response of Your Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *ans = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return [[Response alloc] init:OK message:ans];
}

-(Response*) PUT_Request
{
    return nil;
}

@end

