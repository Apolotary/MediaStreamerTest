//
//  MSTRemoteService.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/22/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTRemoteService : NSObject

@property (nonatomic, readonly) NSNetService *service;
@property (nonatomic, readonly) NSString     *resolvedAddress;
@property (nonatomic, readonly) NSURL        *streamingLink;

@property BOOL isServer;
@property BOOL isStreaming;
@property BOOL isResolved;
@property BOOL isLocal;

- (id)initWithService: (NSNetService *) service
              isLocal: (BOOL) isLocal;

@end
