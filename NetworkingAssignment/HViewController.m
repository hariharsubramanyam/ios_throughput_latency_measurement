//
//  HViewController.m
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/20/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import "HViewController.h"
#import "HDownloader.h"
#import "HDownloadTestDelegate.h"

#define URL @"http://web.mit.edu/21w.789/www/papers/griswold2004.pdf"

@interface HViewController ()
@property (weak, nonatomic) IBOutlet UITextView *lblOutput;
@property (weak, nonatomic) IBOutlet UITextField *txtInterval;
@property (weak, nonatomic) IBOutlet UIButton *btnDownloadTest;
@property (weak, nonatomic) IBOutlet UITextField *txtTestTime;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (nonatomic, strong) HDownloader *downloadTest;
@end

@implementation HViewController

- (HDownloader *)downloadTest{
    if (!_downloadTest) {
        _downloadTest = [[HDownloader alloc] initWithDelegate:self];
    }
    return _downloadTest;
}


- (IBAction)on_button_click:(id)sender {
    [self.view endEditing:YES];
    double interval = [self.txtInterval.text doubleValue];
    double testTime = [self.txtTestTime.text doubleValue];
    if(ABS(interval*testTime) < 0.01){
        return;
    }
    BOOL testRunning = [self.downloadTest doDownloadTestForURLString:URL withTestTime:testTime andInterval:interval];
    if (testRunning) {
        self.progressBar.hidden = NO;
        self.progressBar.progress = 0.0f;
        NSLog(@"Test Started");
        self.btnDownloadTest.enabled = false;
        [self.btnDownloadTest setTitle:@"Running Test..." forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onProgressUpdate:(double)fractionComplete{
    self.lblOutput.text = [NSString stringWithFormat:@"%.2f%% Complete", fractionComplete*100];
    self.progressBar.progress = (fractionComplete);
    NSLog(@"%.2f%% Complete", fractionComplete*100);
}

- (void)onTestComplete:(HTestResults *)testResults{
    NSLog(@"Test Complete with filesize %d", testResults.fileSize);
    self.progressBar.hidden = YES;
    self.btnDownloadTest.enabled = YES;
    self.lblOutput.text = @"";
    for (int i = 0; i < [testResults.latencies count]; i++) {
        double throughput = [((NSNumber *)[testResults.throughputs objectAtIndex:i]) doubleValue];
        double latency = [((NSNumber *)[testResults.latencies objectAtIndex:i]) doubleValue];
        self.lblOutput.text = [self.lblOutput.text stringByAppendingString:[NSString stringWithFormat:@"%d: Throughput = %f Mbps, Latency = %f ms\n\n", i,throughput,latency]];
    }
    [self.btnDownloadTest setTitle:@"Run Download Test" forState:UIControlStateNormal];
}


@end
