//
//  HDownloader.h
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDownloadTestDelegate.h"

@interface HDownloader : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (instancetype) initWithDelegate:(id<HDownloadTestDelegate>)delegate;
- (BOOL) doDownloadTestForURLString:(NSString *)urlString withTestTime:(double)testTime andInterval:(double)interval;

@end
