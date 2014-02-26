//
//  MSTConnectionManager+ServerAPI.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTConnectionManager+ServerAPI.h"
#import "MSTConstants.h"
#import "MSTAudioManager.h"

#import "AFNetworking.h"

@implementation MSTConnectionManager (ServerAPI)

#pragma mark - API Handlers

- (GCDWebServerResponse *) defaultResponse
{
    NSDictionary *responseDictionary = @{kAPIResponseKeyServiceName:   self.webServer.bonjourName,
                                         kAPIResponseKeyIsServer:      [NSNumber numberWithBool:self.isServer],
                                         kAPIResponseKeyIsStreaming:   [NSNumber numberWithBool:self.isStreaming],
                                         kAPIResponseKeyVolumeLevel:   [NSNumber numberWithFloat:[MSTAudioManager sharedInstance].volumeLevel],
                                         kAPIResponseKeyStreamingLink: self.isStreaming ? self.streamingFilePath.absoluteString : @""};
    
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
        if (request.hasBody)
        {
            NSError *error;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[request data] options:NSJSONReadingAllowFragments error:&error];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlaybackSetVolume object:nil userInfo:@{kPlaybackSetVolumeKey : [jsonDict objectForKey:kAPIResponseKeyVolumeLevel]}];
            return [GCDWebServerResponse responseWithStatusCode:kResponseCodeSuccess];
        }
    }
    return [GCDWebServerResponse responseWithStatusCode:kResponseCodeBadRequest];
}

- (GCDWebServerDataResponse *) getCurrentVolumeLevelForRequest: (GCDWebServerDataRequest *) request
{
    if(self.isStreaming)
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{kAPIResponseKeyVolumeLevel: [NSNumber numberWithFloat:[MSTAudioManager sharedInstance].volumeLevel]} options:NSJSONWritingPrettyPrinted error:&error];
        return [GCDWebServerDataResponse responseWithData:jsonData contentType:CONTENT_TYPE_JSON];
    }
    return (GCDWebServerDataResponse *) [GCDWebServerResponse responseWithStatusCode:kResponseCodeBadRequest];
}

- (GCDWebServerResponse *) setStreamingSourceForRequest: (GCDWebServerDataRequest *) request
{
    if(!self.isStreaming)
    {
        if (request.hasBody)
        {
            NSError *error;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[request data] options:NSJSONReadingAllowFragments error:&error];
            
            self.streamingFilePath = [NSURL URLWithString:[jsonDict objectForKey:kAPIResponseKeyStreamingLink]];
            NSLog(@"New streaming URL: %@", self.streamingFilePath);
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlaybackSetStreamingSource object:nil userInfo:@{kPlaybackSetStreamingSourceKey: [jsonDict objectForKey:kAPIResponseKeyStreamingLink]}];
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
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:@{kAPIResponseKeyStreamingLink : self.streamingFilePath.absoluteString}
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    
    return [GCDWebServerDataResponse responseWithData:responseData contentType:CONTENT_TYPE_JSON];
}

- (GCDWebServerResponse *) stopReceivingStreamForRequest: (GCDWebServerDataRequest *) request
{
    if (request.hasBody)
    {
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[request data] options:NSJSONReadingAllowFragments error:&error];
        
        if ([self.streamingFilePath isEqual:[NSURL URLWithString:[jsonDict objectForKey:kAPIResponseKeyStreamingLink]]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlaybackStopCurrentStream object:nil];
            
            [self setStreamingFilePath:[NSURL URLWithString:@""]];
            
            return [GCDWebServerResponse responseWithStatusCode:kResponseCodeSuccess];
        }
    }
    return [GCDWebServerResponse responseWithStatusCode:kResponseCodeBadRequest];
}

#pragma mark - Server methods

- (void) addAPIHandlers
{
    NSString* websitePath = [[NSBundle mainBundle] bundlePath];
    
    // Add a default handler to serve static files (i.e. anything other than HTML files)
    [self.webServer addHandlerForBasePath:@"/" localPath:websitePath indexFilename:nil cacheAge:3600];
    
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request)
    {
        return [self defaultResponse];
    }];
    
    [self.webServer addHandlerForMethod:@"GET"
                              pathRegex:@"/.*\.mp3"
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [GCDWebServerFileResponse responseWithFile:[websitePath stringByAppendingPathComponent:request.path]];
                           }];
    
    [self.webServer addHandlerForMethod:@"GET"
                                   path:kAPIPathGetStream
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [self getStreamingSource];
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
    
    [self.webServer addHandlerForMethod:@"POST"
                                   path:kAPIPathStopReceivingStream
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [self stopReceivingStreamForRequest:(GCDWebServerDataRequest *) request];
                           }];
    
    NSLog(@"Server name: %@", [GCDWebServer serverName]);
}

- (void) startStreamingFile: (NSString *) fileName
              withExtension: (NSString *) fileExtension
{
    // setting link and streaming status for future requests
    self.isStreaming = YES;
    self.streamingFilePath = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/%@.%@", self.localService.resolvedAddress, kServicePortNumber, fileName, fileExtension]];
    
    
    // sending streaming link to other clients
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSError *error;
    NSData *resultData = [NSJSONSerialization dataWithJSONObject:@{kAPIResponseKeyStreamingLink: [NSString stringWithFormat:@"http://%@:%d/%@.%@", self.localService.resolvedAddress, kServicePortNumber, fileName, fileExtension]}
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
    
    for (MSTRemoteService *remoteService in self.availableServices)
    {
        if ([remoteService isResolved])
        {
            [manager POST:[NSString stringWithFormat:@"http://%@:%d%@", remoteService.resolvedAddress, kServicePortNumber, kAPIPathSetStream] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:resultData name:@"json" fileName:@"" mimeType:@"application/json"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Successfully sent stream %@", responseObject);
                [[NSNotificationCenter defaultCenter] postNotificationName:kServiceStreamingSuccessNotification object:nil userInfo:@{kServiceStreamingSuccessKey: remoteService.service.name}];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error, unable to send stream: %@", error.description);
            }];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kServiceStartedStreamingNotification object:nil];
}

- (void) stopStreaming
{
    //TODO: implement streaming options
    
    self.isServer = NO;
    self.isStreaming = NO;
    self.streamingFilePath = [NSURL URLWithString:@""];
    
    for (MSTRemoteService *streamingClient in self.availableServices)
    {
        [self disconnectClient:streamingClient];
    }
}

- (void) setVolumeLevel: (float) volumeLevel
              forClient: (MSTRemoteService *) streamingClient
{
    if (self.isStreaming)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:[NSString stringWithFormat:@"http://%@:%d%@", streamingClient.resolvedAddress, kServicePortNumber, kAPIPathSetVolume] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSError *error;
            NSData *resultData = [NSJSONSerialization dataWithJSONObject:@{kAPIResponseKeyVolumeLevel: [NSNumber numberWithFloat:volumeLevel]} options:NSJSONWritingPrettyPrinted error:&error];
            
            [formData appendPartWithFileData:resultData name:@"json" fileName:@"" mimeType:@"application/json"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully set volume %@", responseObject);
            // TODO: add a proper notification
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error, unable to set volume: %@", error.description);
        }];    }
}

- (void) disconnectClient: (MSTRemoteService *) streamingClient
{
    if (streamingClient.resolvedAddress)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:[NSString stringWithFormat:@"http://%@:%d%@", streamingClient.resolvedAddress, kServicePortNumber, kAPIPathStopReceivingStream]
         parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Streaming stopped! %@", streamingClient.service.name);
             [[NSNotificationCenter defaultCenter] postNotificationName:kServiceStreamingStopNotification object:nil userInfo:@{kServiceStreamingStopKey: streamingClient.service.name}];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Streaming failure: %@ %@", streamingClient.service.name, error.description);
         }];
    }
}

#pragma mark - Client methods

- (void) requestStreamFromSource: (MSTRemoteService *) streamingSource
{
    if (!self.isStreaming)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:[NSString stringWithFormat:@"http://%@:%d%@", streamingSource.resolvedAddress, kServicePortNumber, kAPIPathGetStream] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Got stream: %@", [responseObject objectForKey:kAPIResponseKeyStreamingLink]);
            
            self.streamingFilePath = [NSURL URLWithString:[responseObject objectForKey:kAPIResponseKeyStreamingLink]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlaybackSetStreamingSource object:nil userInfo:@{kPlaybackSetStreamingSourceKey: [responseObject objectForKey:kAPIResponseKeyStreamingLink]}];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get stream: %@", error.description);
        }];
    }
}

@end
