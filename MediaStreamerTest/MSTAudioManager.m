//
//  MSTAudioManager.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTAudioManager.h"
#import "MSTConstants.h"
#import <AVFoundation/AVFoundation.h>


@interface MSTAudioManager ()
{
    AVPlayer *_mainPlayer;
}

- (void) addNotificationHandlers;

@end

@implementation MSTAudioManager

#pragma mark - Initialization methods

+ (id)sharedInstance
{
    static MSTAudioManager *sharedInstance = nil;
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[MSTAudioManager alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self addNotificationHandlers];
    }
    return self;
}

#pragma mark - Notification methods

- (void) addNotificationHandlers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStreamingSource:) name:kPlaybackSetStreamingSource object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setVolume:) name:kPlaybackSetVolume object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStop) name:kPlaybackStopCurrentStream object:nil];
}

#pragma mark - Playback methods

- (void) setStreamingSource: (NSNotification *) notification
{
    NSString *urlString = [notification.userInfo objectForKey:kPlaybackSetStreamingSourceKey];
    [self playFileAtURL:[NSURL URLWithString:urlString]];
}

- (void) setVolume: (NSNotification *) notification
{
    NSNumber *volumeNumber = [notification.userInfo objectForKey:kPlaybackSetVolumeKey];
    [self changeVolumeLevel:volumeNumber.floatValue];
}

- (void) playFileAtURL: (NSURL *) fileURL
{
    NSString *urlString = [fileURL absoluteString];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"local." withString:@"local"];
    fileURL = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _mainPlayer = [[AVPlayer alloc] initWithURL:fileURL];
        [_mainPlayer play];
    });

}

- (void) playbackStart
{
    if (_mainPlayer)
    {
        [_mainPlayer play];
    }
}

- (void) playbackStop
{
    if (_mainPlayer)
    {
        [_mainPlayer pause];
    }
}

- (void) changeVolumeLevel: (float) newVolumeLevel
{
    if (_mainPlayer)
    {
        [_mainPlayer setVolume:newVolumeLevel];
        _volumeLevel = newVolumeLevel;
    }
}


@end
