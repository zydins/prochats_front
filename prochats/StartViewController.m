//
//  StartViewController.h
//  ProChat
//
//  Created by Vladislav Orlov on 09.05.15.
//  Copyright (c) 2015 Vladislav Orlov. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

@synthesize Connector;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self Start];
}

-(void)Start {
    Connector = [[VKConnector alloc] init];
    
    if (Connector.status == NeedAuth)
        [self performSegueWithIdentifier:@"StartToAuthSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"StartToStatusSegue" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController<VKConnnectorProtocol> *uiContr = (UIViewController<VKConnnectorProtocol> *)segue.destinationViewController;
    uiContr.Connector = Connector;

}

@end
