//
//  MSTConnectionManager.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTConnectionManager.h"

#import "MSTConnectionManager+ServerAPI.h"
#import "MSTConstants.h"

@interface MSTConnectionManager () <NSNetServiceBrowserDelegate>
{
    NSMutableArray      *_availableServices;
    NSNetServiceBrowser *_serviceBrowser;
}

@end

@implementation MSTConnectionManager

#pragma mark - Initialization methods

- (id)init
{
    self = [super init];
    if (self) {
        _webServer = [[GCDWebServer alloc] init];
        [self addAPIHandlers];
        [_webServer startWithPort:kServicePortNumber bonjourName:@""];
        
        _serviceBrowser = [[NSNetServiceBrowser alloc] init];
        [_serviceBrowser setDelegate:self];
        
        _availableServices = [[NSMutableArray alloc] init];
        
        self.isServer = NO;
        self.isStreaming = NO;
    }
    return self;
}

+ (id)sharedInstance
{
    static MSTConnectionManager *sharedInstance = nil;
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[MSTConnectionManager alloc] init];
        }
    }
    return sharedInstance;
}

#pragma mark - Connection Manager methods

- (void) searchForAvailableServers;
{
    [_serviceBrowser searchForServicesOfType:kServiceType inDomain:kServiceDomain];
}

#pragma mark - NSNetServiceBrowserDelegate methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kServiceErrorNotification object:nil userInfo:errorDict];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    if (![aNetService.name isEqualToString:_webServer.bonjourName])
    {
        MSTRemoteService *remoteService = [[MSTRemoteService alloc] initWithService:aNetService];
        [_availableServices addObject:remoteService];
        
        if (!moreComing)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kServiceSearchFinishedNotification object:nil];
        }
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    for (int i = [_availableServices count] - 1; i >= 0; i--)
    {
        MSTRemoteService *remoteService = [_availableServices objectAtIndex:i];
        if ([remoteService.service.name isEqualToString:aNetService.name])
        {
            [_availableServices removeObject:remoteService];
        }
    }
    
    if (!moreComing)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kServiceRemovedNotification object:nil];
    }
}


@end
