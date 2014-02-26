//
//  MSTWebServerRequest.h
//  MediaStreamerTest
//
//  Created by Bektur Ryskeldiev on 2/26/14.
//  Copyright (c) 2014 Bektur Ryskeldiev. All rights reserved.
//

#import "GCDWebServerRequest.h"

@interface MSTWebServerRequest : GCDWebServerRequest

- (BOOL)open;  // Implementation required
- (NSInteger)write:(const void*)buffer maxLength:(NSUInteger)length;  // Implementation required
- (BOOL)close;  // Implementation required

@end
