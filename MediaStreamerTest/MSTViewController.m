//
//  MSTViewController.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTViewController.h"
#import "MSTConnectionManager.h"

@interface MSTViewController ()
{
    MSTConnectionManager *_connectionManager;
}

@end

@implementation MSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_connectionManager = [MSTConnectionManager sharedInstance];
    [_connectionManager searchForAvailableServers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
