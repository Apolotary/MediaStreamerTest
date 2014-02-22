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

@property BOOL isStreaming;
@property NSString *streamingFilePath;

// server methods
- (void) addAPIHandlers;

- (void) startStreamingFile: (NSString *) filePath;
- (void) stopStreaming;

- (void) setVolumeLevelForClient: (MSTRemoteService *) streamingClient;
- (void) disconnectClient:        (MSTRemoteService *) streamingClient;

// client methods
- (void) requestStreamFromSource: (MSTRemoteService *) streamingSource;

@end
