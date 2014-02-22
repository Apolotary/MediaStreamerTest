//
//  MSTRemoteService.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTRemoteService.h"

@interface MSTRemoteService () <NSNetServiceDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end

@implementation MSTRemoteService

- (id)initWithService: (NSNetService *) service
{
    self = [super init];
    if (self) {
        _service = service;
        [_service setDelegate:self];
        [_service resolveWithTimeout:0.0];
        _isServer = NO;
        _isStreaming = NO;
    }
    return self;
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"resolved DNS: %@", sender.hostName);
    
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    //TODO: fix here
}

#pragma mark - NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

@end
