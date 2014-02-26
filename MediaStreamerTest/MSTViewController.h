//
//  MSTViewController.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UILabel *_labelLocalService;
    IBOutlet UILabel *_labelDNS;
    IBOutlet UILabel *_labelStatus;
    
    IBOutlet UITableView *_tableRemoteService;
    
    IBOutlet UIButton *_buttonStartStream;
    IBOutlet UIButton *_buttonStopStream;
    IBOutlet UIButton *_buttonStartPlayback;
    IBOutlet UIButton *_buttonStopPlayback;
}

- (IBAction)startStreamingButtonPressed:(id)sender;
- (IBAction)stopStreamingButtonPressed:(id)sender;

- (IBAction)startPlaybackButtonPressed:(id)sender;
- (IBAction)stopPlaybackButtonPressed:(id)sender;

@end
