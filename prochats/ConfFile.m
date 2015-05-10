//
//  ConfFile.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import "ConfFile.h"

@implementation ConfFile


@synthesize path;
@synthesize plistDict;
@synthesize connector;

-(id)init:(VKConnector *)sender path:(NSString *)name
{
    connector = sender;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tpath =[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",name,@".plist"]];
    if (![fileManager fileExistsAtPath:tpath])
    {
        
        NSString *bundle = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:tpath error:&error];
        
    }
    self.path = tpath;
    plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    return self;
}

-(NSString *)ReadData:(NSString *)key
{
    NSString *data;
    data = [plistDict valueForKey:key];
    return data;
}

-(void)WriteData:(NSString *)key data:(NSString *)data
{
    if ([data isEqualToString:@"_num"])
        data = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [plistDict setValue:data forKey:key];
    [plistDict writeToFile:path atomically:YES];
}

-(NSMutableDictionary*)GetDict
{
    plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    return plistDict;
}

@end
