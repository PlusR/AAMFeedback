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


@property(strong, nonatomic) NSString *descriptionText;
@property(strong, nonatomic) NSArray *topics;
@property(strong, nonatomic) NSArray *topicsToSend;
@property(strong, nonatomic) NSArray *toRecipients;
@property(strong, nonatomic) NSArray *ccRecipients;
@property(strong, nonatomic) NSArray *bccRecipients;
#pragma mark - customize
@property(strong, nonatomic) UIImage *backgroundImage;
@property(nonatomic) NSInteger selectedTopicsIndex;
@property(nonatomic, copy) void (^beforeShowAction)(MFMailComposeViewController *);

@property(nonatomic, copy) NSString *descriptionPlaceHolder;
@property(nonatomic, copy) NSString *topicsTitle;
@property(nonatomic, copy) NSString *attention;
@property(nonatomic, copy) NSString *tableHeaderAttention;
@property(nonatomic, copy) NSString *tableHeaderTopics;
@property(nonatomic, copy) NSString *tableHeaderBasicInfo;
@property(nonatomic, copy) NSString *mailDidFinishWithError;
@property(nonatomic, copy) NSString *buttonMail;
@property(nonatomic, copy) NSString *note;

- (instancetype)initWithTopics:(NSArray *) theTopics;

+ (BOOL)isAvailable;

+ (void)setAlwaysUseMainBundle:(BOOL) alwaysUseMainBundle;
#pragma mark - internal
+ (NSBundle *)bundle;
@end
