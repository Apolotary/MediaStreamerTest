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
@property (nonatomic, readonly) NSString     *streamingLink;

@property BOOL isServer;
@property BOOL isStreaming;

- (id)initWithService: (NSNetService *) service;

@end
