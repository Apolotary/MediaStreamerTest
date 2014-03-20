//
//  MSTConnectionManager.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

// Connection singleton that contains Bonjour service scanning + GCDWebServer instance

#import <Foundation/Foundation.h>
#import "MSTRemoteService.h"
#import "GCDWebServer.h"

@interface MSTConnectionManager : NSObject

@property BOOL isServer;
@property BOOL isStreaming;
@property (nonatomic, readonly) GCDWebServer     *webServer;
@property (nonatomic, readonly) MSTRemoteService *localService;
@property (nonatomic, readonly) NSMutableArray   *availableServices;
@property (nonatomic, strong)   NSString         *serverName;
@property (nonatomic, strong)   NSURL            *streamingFilePath;

+ (MSTConnectionManager *) sharedInstance;
- (void) searchForAvailableServers;
- (BOOL) isRemoteStreamingServiceAvailable;
- (id)   getRemoteStreamingService;

@end
