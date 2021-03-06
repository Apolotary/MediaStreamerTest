//
//  MSTConnectionManager+ServerAPI.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

// API-related methods for connection manager, separate category because it's not exactly
// connection manager's job, but making a separate instance just for API would be redundant

#import "MSTConnectionManager.h"
#import "MSTRemoteService.h"

@interface MSTConnectionManager (ServerAPI)

// server methods
- (void) addAPIHandlers;

// streams one file to all clients around it
- (void) setStreamingFile: (NSString *) fileName
            withExtension: (NSString *) fileExtension
          forRemoteClient: (MSTRemoteService *) remoteService;

- (void) startStreaming;

- (void) stopStreaming;

- (void) setVolumeLevel: (float) volumeLevel
              forClient: (MSTRemoteService *) streamingClient;
- (void) disconnectClient:        (MSTRemoteService *) streamingClient;

// client methods
- (void) requestStreamFromSource: (MSTRemoteService *) streamingSource;

@end
