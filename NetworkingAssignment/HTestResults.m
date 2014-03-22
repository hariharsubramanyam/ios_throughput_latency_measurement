//
//  HTestResults.m
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import "HTestResults.h"

@implementation HTestResults

- (instancetype) initWithFileSize: (int) fileSize andThroughputs: (NSMutableArray *)throughtputs andLatencies:(NSMutableArray *)latencies{
    self = [super init];
    
    if (self) {
        self.fileSize = fileSize;
        self.latencies = latencies;
        self.throughputs = throughtputs;
    }
    
    return self;
}


@end
