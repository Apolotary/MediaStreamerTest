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
    IBOutlet UILabel *_labelSoundFile;
    
    IBOutlet UITableView *_tableRemoteService;
    
    IBOutlet UIButton *_buttonStartStream;
    IBOutlet UIButton *_buttonStopStream;
    IBOutlet UIButton *_buttonSetSoundFile;
}

- (IBAction)startStreamingButtonPressed:(id)sender;
- (IBAction)stopStreamingButtonPressed:(id)sender;
- (IBAction)setSoundFileButtonPressed:(id)sender;

@end
