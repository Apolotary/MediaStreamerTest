//
//  MSTConnectionManager.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

// Connection singleton that contains Bonjour service scanning + GCDWebServer instance

#import <Foundation/Foundation.h>
#import "GCDWebServer.h"

@interface MSTConnectionManager : NSObject

@property BOOL isServer;
@property (nonatomic, readonly) GCDWebServer *webServer;
@property (nonatomic, strong)   NSString     *serverName;

+ (MSTConnectionManager *) sharedInstance;
- (void) searchForAvailableServers;

@end
