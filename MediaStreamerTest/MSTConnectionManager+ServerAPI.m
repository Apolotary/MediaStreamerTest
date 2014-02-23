//
//  MSTConnectionManager+ServerAPI.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTConnectionManager+ServerAPI.h"
#import "MSTConstants.h"

@implementation MSTConnectionManager (ServerAPI)

#pragma mark - API Handlers



#pragma mark - Server methods

- (void) addAPIHandlers
{
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request)
    {
        NSDictionary *responseDictionary = @{kAPIResponseKeyServiceName:   self.webServer.bonjourName,
                                             kAPIResponseKeyIsServer:      [NSNumber numberWithBool:self.isServer],
                                             kAPIResponseKeyIsStreaming:   [NSNumber numberWithBool:self.isStreaming],
                                             kAPIResponseKeyStreamingLink: self.isStreaming ? self.streamingFilePath : @""};
        
        NSError *error;
        NSData * responseData = [NSJSONSerialization dataWithJSONObject:responseDictionary
                                                                options:NSJSONWritingPrettyPrinted
                                                                  error:&error];
        return [GCDWebServerDataResponse responseWithData:responseData contentType:@"application/json"];
    }];
}

- (void) startStreamingFile: (NSString *) filePath
{
    
}

- (void) stopStreaming
{
    
}

- (void) setVolumeLevelForClient: (MSTRemoteService *) streamingClient
{
    
}

- (void) disconnectClient: (MSTRemoteService *) streamingClient
{
    
}

#pragma mark - Client methods

- (void) requestStreamFromSource: (MSTRemoteService *) streamingSource
{
    
}

@end
