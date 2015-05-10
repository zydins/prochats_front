//
//  StartViewController.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKConnector.h"
#import "VKConViewControllerProtocol.h"

@interface StartViewController : UIViewController<VKConnnectorProtocol>

@property VKConnector *Connector;


-(void)Start;

@end
