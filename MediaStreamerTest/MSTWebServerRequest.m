//
//  MSTWebServerRequest.m
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/26/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "MSTWebServerRequest.h"

@implementation MSTWebServerRequest

- (BOOL)open
{
    return YES;
}

- (NSInteger)write:(const void*)buffer maxLength:(NSUInteger)length
{
    return 0;
}

- (BOOL)close
{
    return YES;
}

@end
