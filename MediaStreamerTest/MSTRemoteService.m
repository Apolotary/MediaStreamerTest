//
//  MSTRemoteService.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTRemoteService.h"
#import "MSTConstants.h"
#import "AFNetworking.h"

@interface MSTRemoteService () <NSNetServiceDelegate>

@end

@implementation MSTRemoteService

- (id)initWithService: (NSNetService *) service
              isLocal: (BOOL) isLocal
{
    self = [super init];
    if (self) {
        _service = service;
        [_service setDelegate:self];
        [_service resolveWithTimeout:0.0];
        _isServer = NO;
        _isStreaming = NO;
        _isResolved = NO;
        _isLocal = isLocal;
    }
    return self;
}

- (void) parseServiceJSON: (NSDictionary *) jsonDictionary
{
    _isServer = [[jsonDictionary objectForKey:kAPIResponseKeyIsServer] boolValue];
    _isStreaming = [[jsonDictionary objectForKey:kAPIResponseKeyIsStreaming] boolValue];
    _streamingLink = [NSURL URLWithString:[jsonDictionary objectForKey:kAPIResponseKeyStreamingLink]];
    _volumeLevel = [[jsonDictionary objectForKey:kAPIResponseKeyVolumeLevel] floatValue];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"resolved DNS: %@", sender.hostName);
    
    _isResolved = YES;
    _resolvedAddress = sender.hostName;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *getString = [NSString stringWithFormat:@"http://%@:%d", sender.hostName, kServicePortNumber];
    
    [manager GET:getString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [self parseServiceJSON:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    if (_isLocal)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kServiceReadyForStreamingNotification object:nil];
    }
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    //TODO: add error handling
    NSLog(@"Resolving error: %@", errorDict);
    _isResolved = NO;
}

@end
