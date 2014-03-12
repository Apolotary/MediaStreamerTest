//
//  MSTAudioManager.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTAudioManager : NSObject

@property float volumeLevel;


+ (MSTAudioManager *) sharedInstance;

- (void) playFileAtURL: (NSURL *) fileURL;
- (void) playbackStart;
- (void) playbackStop;
- (void) changeVolumeLevel: (float) newVolumeLevel;

@end
