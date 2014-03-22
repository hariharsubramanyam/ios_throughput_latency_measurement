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
#import <MessageUI/MFMailComposeViewController.h>

// Download the file from this URL
#define URL @"http://web.mit.edu/21w.789/www/papers/griswold2004.pdf"


@interface HViewController ()

// Label for test result output
@property (weak, nonatomic) IBOutlet UITextView *lblOutput;

// Text field for the time between throughput calculations
@property (weak, nonatomic) IBOutlet UITextField *txtInterval;

// Button to start download
@property (weak, nonatomic) IBOutlet UIButton *btnDownloadTest;

// Text field for the duration of the test
@property (weak, nonatomic) IBOutlet UITextField *txtTestTime;

// Progress bar to indicate how far the test has gone
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

// Model for running the download test
@property (nonatomic, strong) HDownloader *downloadTest;

// Button to email results
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;

@end

@implementation HViewController

/*
 Get the download test
 */
- (HDownloader *)downloadTest{
    if (!_downloadTest) {
        _downloadTest = [[HDownloader alloc] initWithDelegate:self];
    }
    return _downloadTest;
}

- (IBAction)email_self_button_click:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Latency and Throughput Results"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@""]];
        [mailCont setMessageBody:self.lblOutput.text isHTML:NO];
        
        [self presentModalViewController:mailCont animated:YES];
    }

}

/*
 Run the download test when the button is clicked
 */
- (IBAction)run_test_button_click:(id)sender {
    
    // Remove the keyboard
    [self.view endEditing:YES];
    
    // Extract the download interval and test time from the text field
    double interval = [self.txtInterval.text doubleValue];
    double testTime = [self.txtTestTime.text doubleValue];
    
    // If either value is zero, return
    if(ABS(interval*testTime) < 0.01){
        return;
    }
    
    // Try to run the test
    BOOL testRunning = [self.downloadTest doDownloadTestForURLString:URL withTestTime:testTime andInterval:interval];
    
    // If the test is running
    if (testRunning) {
        
        // Make the progress bar visible and disable the button
        self.progressBar.hidden = NO;
        self.progressBar.progress = 0.0f;
        NSLog(@"Test Started");
        self.btnDownloadTest.enabled = false;
        [self.btnDownloadTest setTitle:@"Running Test..." forState:UIControlStateNormal];
    }
}

/*
 When the view loads
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

/*
 When a memory warning occurs
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 (Method from HDownloadTestDelegate protocol)
 Update the progress bar
 */
- (void) onProgressUpdate:(double)fractionComplete{
    self.progressBar.progress = (fractionComplete);
    NSLog(@"%.2f%% Complete", fractionComplete*100);
}

/*
 (Method from HDownloadTestDelegate protocol)
 When the test has finished, save the results
 */
- (void)onTestComplete:(HTestResults *)testResults{
    NSLog(@"Test Complete with filesize %d", testResults.fileSize);
    
    // Hide the progress bar and enable the button
    self.progressBar.hidden = YES;
    self.btnDownloadTest.enabled = YES;
    [self.btnDownloadTest setTitle:@"Run Download Test" forState:UIControlStateNormal];
    
    // Print all the output to the label
    self.lblOutput.text = @"Test Number, Throughput (Mbps), Latency (ms)\n";
    for (int i = 0; i < [testResults.latencies count]; i++) {
        double throughput = [((NSNumber *)[testResults.throughputs objectAtIndex:i]) doubleValue];
        double latency = [((NSNumber *)[testResults.latencies objectAtIndex:i]) doubleValue];
        self.lblOutput.text = [self.lblOutput.text stringByAppendingString:[NSString stringWithFormat:@"%d, %f, %f\n", (i+1),throughput,latency]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
