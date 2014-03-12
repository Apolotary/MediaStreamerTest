//
//  MSTRemoteServiceViewController.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/26/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTRemoteServiceViewController.h"
#import "MSTConstants.h"
#import "MSTConnectionManager.h"
#import "MSTConnectionManager+ServerAPI.h"

@interface MSTRemoteServiceViewController ()

@end

@implementation MSTRemoteServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [_labelName setText:_remoteService.service.name];
    [_labelDNS setText:[NSString stringWithFormat:@"%@:%lu", _remoteService.resolvedAddress, kServicePortNumber]];
    
    if (_remoteService.isStreaming)
    {
        [_labelStatus setText:@"Currently streaming"];
    }
    else{
        [_labelStatus setText:@"Ready for streaming"];
    }
    
    [_volumeSlider setValue:_remoteService.volumeLevel animated:YES];
}

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

#pragma mark - Button methods

- (IBAction)adjustVolumeLevel:(id)sender
{
    [[MSTConnectionManager sharedInstance] setVolumeLevel:_volumeSlider.value forClient:_remoteService];
}

- (IBAction)doneButtonPressed:(id)sender
{
//    [_delegate dismissViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
