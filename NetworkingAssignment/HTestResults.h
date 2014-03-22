//
//  HTestResults.h
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTestResults : NSObject
@property (strong, nonatomic) NSMutableArray *throughputs;
@property (strong, nonatomic) NSMutableArray *latencies;
@property (nonatomic) int fileSize;

- (instancetype) initWithFileSize: (int) fileSize andThroughputs: (NSMutableArray *)throughtputs andLatencies:(NSMutableArray *)latencies;
@end
