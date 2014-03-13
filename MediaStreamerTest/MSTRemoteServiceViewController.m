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

@interface MSTRemoteServiceViewController () <UIActionSheetDelegate>
{
    UIActionSheet *_pickerSheet;
}

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
    [_labelDNS setText:[NSString stringWithFormat:@"%@:%d", _remoteService.resolvedAddress, kServicePortNumber]];
    [_labelSoundFile setText:[NSString stringWithFormat:@"%@", _remoteService.streamingLink.absoluteString]];
    
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

- (IBAction)setSoundFileButtonPressed:(id)sender
{
    _pickerSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a sound file:"
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"Bass", @"Drums", @"Guitar", nil];
    [_pickerSheet showInView:self.view];
}

#pragma mark - Actionsheet view delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index: %d", buttonIndex);
    
    if (buttonIndex == 0)
    {
        [[MSTConnectionManager sharedInstance] setStreamingFile:@"funk_bass"
                                                  withExtension:@"mp3"
                                                forRemoteClient:_remoteService];
        [_labelSoundFile setText:@"funk_bass.mp3"];
    }
    else if (buttonIndex == 1)
    {
        [[MSTConnectionManager sharedInstance] setStreamingFile:@"funk_drums"
                                                  withExtension:@"mp3"
                                                forRemoteClient:_remoteService];
        [_labelSoundFile setText:@"funk_drums.mp3"];
    }
    else if (buttonIndex == 2)
    {
        [[MSTConnectionManager sharedInstance] setStreamingFile:@"funk_guitar"
                                                  withExtension:@"mp3"
                                                forRemoteClient:_remoteService];
        [_labelSoundFile setText:@"funk_guitar.mp3"];
    }
}

@end
