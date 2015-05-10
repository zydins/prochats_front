//
//  AuthViewController.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProChat-api/VKUser.h"
//#import "ProChat-api/VKConViewControllerProtocol.h"
#include "ProChat-api/Header.h"

@interface AuthViewController : UIViewController<VKConnnectorProtocol>
{
    @private NSString *URLToAuth;
}

@property IBOutlet UIWebView *browser;
@property NSString *Key;
@property NSString *UserId;
@property VKConnector *Connector;


-(void)Auth;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
