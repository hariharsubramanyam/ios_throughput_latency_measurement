//
//  HViewController.h
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/20/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDownloadTestDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface HViewController : UIViewController<HDownloadTestDelegate, MFMailComposeViewControllerDelegate>
@end
