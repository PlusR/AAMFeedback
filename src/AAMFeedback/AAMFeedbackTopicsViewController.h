//
//  AAMFeedbackTopicsViewController.h
//  AAMFeedbackViewController
//
//  Created by 深津 貴之 on 11/11/30.
//  Copyright (c) 2011年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAMFeedbackTopicsViewController : UITableViewController {
}

@property(weak, nonatomic) id delegate;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic) NSArray *topics;

@end

@protocol AAMFeedbackTopicsViewControllerDelegate <NSObject>

- (void)feedbackTopicsViewController:(AAMFeedbackTopicsViewController *) feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger) selectedIndex;

@end
