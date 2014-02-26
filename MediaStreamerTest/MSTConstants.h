//
//  MSTConstants.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/23/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONTENT_TYPE_JSON @"application/json"

extern const NSUInteger kServicePortNumber;
extern NSString * const kServiceDomain;
extern NSString * const kServiceType;

extern NSString * const kServiceErrorNotification;
extern NSString * const kServiceSearchFinishedNotification;
extern NSString * const kServiceRemovedNotification;
extern NSString * const kServiceReadyForStreamingNotification;
extern NSString * const kServiceStartedStreamingNotification;
extern NSString * const kServiceStartedReceivingStreamNotification;

extern NSString * const kServiceStreamingSuccessNotification;
extern NSString * const kServiceStreamingSuccessKey;
extern NSString * const kServiceStreamingStopNotification;
extern NSString * const kServiceStreamingStopKey;

extern NSString * const kAPIResponseKeyServiceName;
extern NSString * const kAPIResponseKeyIsServer;
extern NSString * const kAPIResponseKeyIsStreaming;
extern NSString * const kAPIResponseKeyStreamingLink;

extern NSString * const kAPIResponseKeyVolumeLevel;

extern NSString * const kAPIPathGetStream;
extern NSString * const kAPIPathSetVolume;
extern NSString * const kAPIPathSetStream;
extern NSString * const kAPIPathStopReceivingStream;

extern NSString * const kPlaybackSetStreamingSource;
extern NSString * const kPlaybackSetStreamingSourceKey;
extern NSString * const kPlaybackStopCurrentStream;
extern NSString * const kPlaybackSetVolume;
extern NSString * const kPlaybackSetVolumeKey;

// API Response codes
extern const NSUInteger kResponseCodeSuccess;
extern const NSUInteger kResponseCodeBadRequest;

@interface MSTConstants : NSObject

@end
