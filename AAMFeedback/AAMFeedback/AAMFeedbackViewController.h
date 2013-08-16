//
//  AAMFeedbackViewController.h
//  AAMFeedbackViewController
//
//  Created by 深津 貴之 on 11/11/30.
//  Copyright (c) 2011年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AAMFeedbackViewController : UITableViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate>
{
    UITextView  *_descriptionTextView;
    UITextField *_descriptionPlaceHolder;
    BOOL _isFeedbackSent;
}

@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) NSArray *topicsToSend;
@property (strong, nonatomic) NSArray *toRecipients;
@property (strong, nonatomic) NSArray *ccRecipients;
@property (strong, nonatomic) NSArray *bccRecipients;
#pragma mark - customize
@property (strong, nonatomic) UIImage *backgroundImage;
@property (assign, nonatomic) NSInteger selectedTopicsIndex;

+ (BOOL)isAvailable;
- (id)initWithTopics:(NSArray*)theTopics;

@end
