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

- (GCDWebServerResponse *) defaultResponse
{
    NSDictionary *responseDictionary = @{kAPIResponseKeyServiceName:   self.webServer.bonjourName,
                                         kAPIResponseKeyIsServer:      [NSNumber numberWithBool:self.isServer],
                                         kAPIResponseKeyIsStreaming:   [NSNumber numberWithBool:self.isStreaming],
                                         kAPIResponseKeyStreamingLink: self.isStreaming ? self.streamingFilePath : @""};
    
    NSError *error;
    NSData * responseData = [NSJSONSerialization dataWithJSONObject:responseDictionary
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
    return [GCDWebServerDataResponse responseWithData:responseData contentType:CONTENT_TYPE_JSON];
}

- (GCDWebServerResponse *) setPlaybackVolumeForRequest: (GCDWebServerDataRequest *) request
{
    if(!self.isStreaming)
    {
        // set Volume
        return [GCDWebServerResponse responseWithStatusCode:kResponseCodeSuccess];
    }
    return [GCDWebServerResponse responseWithStatusCode:kResponseCodeBadRequest];
}

- (GCDWebServerResponse *) setStreamingSourceForRequest: (GCDWebServerDataRequest *) request
{
    if(!self.isStreaming)
    {
        if (request.hasBody)
        {
            NSError *error;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[request data] options:NSJSONReadingAllowFragments error:&error];
            
            self.streamingFilePath = [jsonDict valueForKey:kAPIResponseKeyStreamingLink];
            NSLog(@"New streaming URL: %@", self.streamingFilePath);
            //TODO set a notification
        }
        
        return [GCDWebServerResponse responseWithStatusCode:kResponseCodeSuccess];
    }
    return [GCDWebServerResponse responseWithStatusCode:kResponseCodeBadRequest];
}

- (GCDWebServerResponse *) getStreamingSource
{
    if (!self.isStreaming)
    {
        return [GCDWebServerResponse responseWithStatusCode:kResponseCodeBadRequest];
    }
    
    NSError *error;
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:@{kAPIResponseKeyStreamingLink : self.streamingFilePath}
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    
    return [GCDWebServerDataResponse responseWithData:responseData contentType:CONTENT_TYPE_JSON];
}

#pragma mark - Server methods

- (void) addAPIHandlers
{
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request)
    {
        return [self defaultResponse];
    }];
    
    [self.webServer addHandlerForMethod:@"GET"
                                   path:kAPIPathGetStream
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [self getStreamingSource];
                           }];
    
    [self.webServer addHandlerForMethod:@"POST"
                                   path:kAPIPathSetStream
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [self setStreamingSourceForRequest:(GCDWebServerDataRequest *)request];
                           }];
    
    [self.webServer addHandlerForMethod:@"POST"
                                   path:kAPIPathSetVolume
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [self setPlaybackVolumeForRequest:(GCDWebServerDataRequest *)request];
                           }];
}

- (void) startStreamingFile: (NSURL *) filePath
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
