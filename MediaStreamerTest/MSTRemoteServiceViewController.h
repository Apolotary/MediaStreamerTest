//
//  MSTRemoteServiceViewController.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/26/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTRemoteService.h"

@protocol MSTRemoteServiceViewControllerProtocol <NSObject>

- (void) dismissViewController;

@end

@interface MSTRemoteServiceViewController : UIViewController
{
    IBOutlet UILabel *_labelName;
    IBOutlet UILabel *_labelDNS;
    IBOutlet UILabel *_labelStatus;
    
    IBOutlet UISlider *_volumeSlider;
}

@property (nonatomic, weak) id<MSTRemoteServiceViewControllerProtocol> delegate;
@property (nonatomic, strong) MSTRemoteService *remoteService;

- (IBAction)adjustVolumeLevel:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end
