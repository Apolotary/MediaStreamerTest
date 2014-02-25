//
//  MSTConstants.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/23/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTConstants.h"

const NSUInteger kServicePortNumber = 1349;
NSString * const kServiceDomain     = @"local.";
NSString * const kServiceType       = @"_http._tcp";

NSString * const kServiceErrorNotification          = @"ServiceErrorNotification";
NSString * const kServiceSearchFinishedNotification = @"ServiceSearchFinishedNotification";
NSString * const kServiceRemovedNotification        = @"ServiceRemovedNotification";

NSString * const kAPIResponseKeyServiceName   = @"ServiceName";
NSString * const kAPIResponseKeyIsServer      = @"IsServer";
NSString * const kAPIResponseKeyIsStreaming   = @"IsStreaming";
NSString * const kAPIResponseKeyStreamingLink = @"StreamingLink";

NSString * const kAPIResponseKeyVolumeLevel   = @"VolumeLevel";

NSString * const kAPIPathGetStream = @"/api/getStream";
NSString * const kAPIPathSetVolume = @"/api/setVolume";
NSString * const kAPIPathSetStream = @"/api/setStream";
NSString * const kAPIPathStopReceivingStream = @"/api/stopReceivingStream";

NSString * const kPlaybackStopCurrentStream = @"PlaybackStopCurrentStream";

// API Response codes
const NSUInteger kResponseCodeSuccess    = 200;
const NSUInteger kResponseCodeBadRequest = 400;

@implementation MSTConstants

@end
