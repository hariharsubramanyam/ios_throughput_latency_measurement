//
//  HDownloadTestDelegate.h
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTestResults.h"

@protocol HDownloadTestDelegate <NSObject>
- (void)onProgressUpdate:(double)fractionComplete;
- (void)onTestComplete:(HTestResults *)testResults;
@end
