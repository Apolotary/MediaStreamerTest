//
//  MSTConnectionManager+ServerAPI.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTConnectionManager+ServerAPI.h"
#import "MSTConstants.h"

#import "AFNetworking.h"

@implementation MSTConnectionManager (ServerAPI)

#pragma mark - API Handlers

- (GCDWebServerResponse *) defaultResponse
{
    NSDictionary *responseDictionary = @{kAPIResponseKeyServiceName:   self.webServer.bonjourName,
                                         kAPIResponseKeyIsServer:      [NSNumber numberWithBool:self.isServer],
                                         kAPIResponseKeyIsStreaming:   [NSNumber numberWithBool:self.isStreaming],
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
        //TODO: set Volume
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
            
            self.streamingFilePath = [NSURL URLWithString:[jsonDict objectForKey:kAPIResponseKeyStreamingLink]];
            NSLog(@"New streaming URL: %@", self.streamingFilePath);
            //TODO: set a notification
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
    NSString* websitePath = [[NSBundle mainBundle] pathForResource:@"/" ofType:nil];
    
    // Add a default handler to serve static files (i.e. anything other than HTML files)
    [self.webServer addHandlerForBasePath:@"/" localPath:websitePath indexFilename:nil cacheAge:3600];
    
    [self.webServer addDefaultHandlerForMethod:@"GET"
                                  requestClass:[GCDWebServerRequest class]
                                  processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request)
    {
        return [self defaultResponse];
    }];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bass" ofType:@"mp3"];
    
    [self.webServer addHandlerForMethod:@"GET"
                                   path:[NSString stringWithFormat:@"/bass.mp3"]
                           requestClass:[GCDWebServerRequest class]
                           processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                               return [GCDWebServerFileResponse responseWithFile:filePath];
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
                
                //TODO: send a notification
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error, unable to send stream: %@", error.description);
            }];
        }
    }
}

- (void) stopStreaming
{
    //TODO: implement streaming options
}

- (void) setVolumeLevelForClient: (MSTRemoteService *) streamingClient
{
    
}

- (void) disconnectClient: (MSTRemoteService *) streamingClient
{
//    if (streamingClient.resolvedAddress)
//    {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//
//        NSError *error;
//        NSData *resultData = [NSJSONSerialization dataWithJSONObject:[NSString stringWithFormat:@"http://%@:%d%@", self.localService.resolvedAddress, kServicePortNumber, filePath]
//                                                             options:NSJSONWritingPrettyPrinted
//                                                               error:&error];
//        
//        [manager POST:[NSString stringWithFormat:@"http://%@:%d%@", streamingClient.resolvedAddress, kServicePortNumber, kAPIPathStopReceivingStream] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileData:resultData name:@"json" fileName:@"" mimeType:@"application/json"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Successfully sent stream %@", responseObject);
//            
//            //TODO: send a notification
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error, unable to send stream: %@", error.description);
//        }];
//    }
}

#pragma mark - Client methods

- (void) requestStreamFromSource: (MSTRemoteService *) streamingSource
{
    
}

@end
