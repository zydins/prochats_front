//
//  AuthViewController.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import "AuthViewController.h"
//#import "ProChat-api/ConfFile.h"
//#import "ProChat-api/VKUser.h"
#import "ProChat-api/Header.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

@synthesize browser;
@synthesize UserId;
@synthesize Key;
@synthesize Connector;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    URLToAuth = @"https://oauth.vk.com/authorize?client_id=4911110&scope=messages,offline&display=page&response_type=token";
    
    [self Auth];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Auth
{
    NSURL *url = [NSURL URLWithString:URLToAuth];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [browser loadRequest:requestObj];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = [[request URL] absoluteString];
    
    //magic
    NSRange j =[URLString rangeOfString:@"access_token"];
    if (j.length > 0)
    {
        unsigned long i = ([URLString rangeOfString:@"access_token"].location) + @"access_token=".length;
        self.Key=@"";
        while (![[URLString substringWithRange:NSMakeRange(i, 1)] isEqualToString: @"&"])
        {
            self.Key = [NSString stringWithFormat:@"%@%@", self.Key, [URLString substringWithRange:NSMakeRange(i, 1)]];
            i++;
        }
        
        i = ([URLString rangeOfString:@"user_id="].location) + @"user_id=".length;
        
        self.UserId = @"";
        while (i < URLString.length)
        {
            self.UserId = [NSString stringWithFormat:@"%@%@", self.UserId, [URLString substringWithRange:NSMakeRange(i, 1)]];
            i++;
        }
        //Main user
        Connector.userId = self.UserId;
        Connector.accessToken = self.Key;
        
        //init user
        VKUser *user = [[VKUser alloc] init:Connector userId:[self.UserId intValue]];
        
        //write to config
        [Connector.config WriteData:@"AccessToken" data:self.Key];
        [Connector.config WriteData:@"UserId" data:self.UserId];
        [self performSegueWithIdentifier:@"AuthToStatusSegue" sender:self];
        
        
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController<VKConnnectorProtocol> *uiContr = (UIViewController<VKConnnectorProtocol> *)segue.destinationViewController;
    uiContr.Connector = Connector;
}

@end
