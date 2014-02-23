//
//  MSTConstants.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/23/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger kServicePortNumber;
extern NSString * const kServiceDomain;
extern NSString * const kServiceType;

extern NSString * const kServiceErrorNotification;
extern NSString * const kServiceSearchFinishedNotification;
extern NSString * const kServiceRemovedNotification;

extern NSString * const kAPIResponseKeyServiceName;
extern NSString * const kAPIResponseKeyIsServer;
extern NSString * const kAPIResponseKeyIsStreaming;
extern NSString * const kAPIResponseKeyStreamingLink;

@interface MSTConstants : NSObject

@end
