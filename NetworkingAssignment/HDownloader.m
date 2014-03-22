//
//  HDownloader.m
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/22/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import "HDownloader.h"
#import "HTestResults.h"

@interface HDownloader()
@property (nonatomic, strong) id<HDownloadTestDelegate> delegate;
@property (nonatomic, strong) NSDate *intervalStartDate;
@property (nonatomic, strong) NSDate *iterationStartDate;

@property (nonatomic, strong) NSMutableArray *throughputs;
@property (nonatomic, strong) NSMutableArray *latencies;
@property (nonatomic, strong) NSMutableArray *tempLatencies;

@property (nonatomic) BOOL needsData;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic) int numInterval;
@property (nonatomic) int numIteration;
@property (nonatomic) BOOL testRunning;

@property (nonatomic) BOOL needsToEstimateFileSize;
@property (nonatomic) int fileSize;

@property (nonatomic) double testTime;
@property (nonatomic) double interval;
@end

@implementation HDownloader

- (instancetype) initWithDelegate:(id<HDownloadTestDelegate>)delegate{
    self = [super init];
    if (self) {
        self.testRunning = NO;
        self.delegate = delegate;
    }
    return self;
}

- (BOOL) doDownloadTestForURLString:(NSString *)urlString withTestTime:(double)testTime andInterval:(double)interval{
    if(self.testRunning){
        return NO;
    }
    self.testTime = testTime;
    self.interval = interval;
    self.testRunning = YES;
    self.needsToEstimateFileSize = YES;
    self.fileSize = 0;
    self.urlString = urlString;
    self.intervalStartDate = [NSDate date];
    self.needsData = YES;
    self.tempLatencies = [[NSMutableArray alloc] init];
    self.latencies = [[NSMutableArray alloc] init];
    self.throughputs = [[NSMutableArray alloc] init];
    self.numInterval = 0;
    self.numIteration = 0;
    [self makeRequest];
    return YES;
}

- (void) makeRequest{
    self.iterationStartDate = [NSDate date];
    NSURL *url = [[NSURL alloc] initWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(self.needsToEstimateFileSize) {
        self.fileSize += [data length];
    }
    if (self.needsData) {
        self.needsData = YES;
        [self.tempLatencies addObject:[self getElapsedTime:self.iterationStartDate]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.needsToEstimateFileSize = NO;
    self.numIteration++;
    double timeSinceIntervalStart = [[self getElapsedTime:self.intervalStartDate] doubleValue];
    if (timeSinceIntervalStart > self.interval) {
        double throughput = 1.0*(self.numIteration * self.fileSize)/timeSinceIntervalStart/1000000.0;
        [self.throughputs addObject:[[NSNumber alloc] initWithDouble:throughput]];
        double averageLatency = 0.0;
        for (NSNumber *number in self.tempLatencies) {
            averageLatency += [number doubleValue];
        }
        averageLatency /= [self.tempLatencies count];
        averageLatency *= 1000.0;
        [self.tempLatencies removeAllObjects];
        [self.latencies addObject:[[NSNumber alloc] initWithDouble:averageLatency]];
        self.numIteration = 0;
        self.intervalStartDate = [NSDate date];
        self.needsData = YES;
        self.numInterval++;
        double progress = (self.numInterval)*self.interval/self.testTime;
        [self.delegate onProgressUpdate:progress];
    }
    if(self.numInterval * self.interval < self.testTime){
        [self makeRequest];
    }else{
        self.testRunning = NO;
        HTestResults *testResults = [[HTestResults alloc] initWithFileSize:self.fileSize andThroughputs:self.throughputs andLatencies:self.latencies];
        [self.delegate onTestComplete:testResults];
    }
}

- (NSNumber *)getElapsedTime:(NSDate *)date{
    NSTimeInterval interval = ABS([date timeIntervalSinceNow]);
    return [[NSNumber alloc] initWithDouble:interval];
}

@end
