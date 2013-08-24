//
//  AAMFeedbackViewController.m
//  AAMFeedbackViewController
//
//  Created by 深津 貴之 on 11/11/30.
//  Copyright (c) 2011年 Art & Mobile. All rights reserved.
//

#import "AAMFeedbackViewController.h"
#import "AAMFeedbackTopicsViewController.h"
#import "UIDeviceHardware.h"

@interface AAMFeedbackViewController ()

- (NSString *)_platformString;

- (NSString *)_feedbackSubject;

- (NSString *)_feedbackBody;

- (NSString *)_appName;

- (NSString *)_appVersion;

- (NSString *)_selectedTopic;

- (NSString *)_selectedTopicToSend;

- (void)_updatePlaceholder;
@end


@implementation AAMFeedbackViewController

+ (BOOL)isAvailable {
    return [MFMailComposeViewController canSendMail];
}

- (id)initWithStyle:(UITableViewStyle) style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self == nil) {
        return nil;
    }
    return self;
}

- (id)initWithTopics:(NSArray *) theIssues {
    self = [self init];
    if (self) {
        self.topics = theIssues;
        self.topicsToSend = theIssues;
    }
    return self;
}



#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];

    self.title = NSLocalizedStringFromTable(@"AAMFeedbackTitle", @"AAMLocalizable", nil);
    BOOL isModal = (self.presentingViewController != nil);
    if (isModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidPress:)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"AAMFeedbackButtonMail", @"AAMLocalizable", nil) style:UIBarButtonItemStyleDone target:self action:@selector(nextDidPress:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.topics == nil) {
        self.topics = @[
                        NSLocalizedStringFromTable(@"AAMFeedbackTopicsQuestion", @"AAMLocalizable", nil),
                        NSLocalizedStringFromTable(@"AAMFeedbackTopicsRequest", @"AAMLocalizable", nil),
                        NSLocalizedStringFromTable(@"AAMFeedbackTopicsBugReport", @"AAMLocalizable", nil),
                        NSLocalizedStringFromTable(@"AAMFeedbackTopicsMedia", @"AAMLocalizable", nil),
                        NSLocalizedStringFromTable(@"AAMFeedbackTopicsBusiness", @"AAMLocalizable", nil),
                        NSLocalizedStringFromTable(@"AAMFeedbackTopicsOther", @"AAMLocalizable", nil)
                        ];
    }

    self.topicsToSend = [self.topics copy];
    [self updateBackGroundImage];
}

- (void)setBackgroundImage:(UIImage *) backgroundImage {
    _backgroundImage = backgroundImage;
    if ([self isViewLoaded]) {
        [self updateBackGroundImage];
    }
}

- (void)updateBackGroundImage {
    if (self.backgroundImage != nil) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
        self.tableView.backgroundView = backgroundImageView;
    }
}


- (void)viewDidUnload {
    [super viewDidUnload];
    _descriptionPlaceHolder = nil;
    _descriptionTextView = nil;
}

- (void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self _updatePlaceholder];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    if (_isFeedbackSent) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        [self dismissViewControllerAnimated:YES completion:nil];
#else
        [self dismissModalViewControllerAnimated:YES];
#endif
    }
}

- (void)viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    }
    return 4;
}

- (float)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return MAX(88, _descriptionTextView.contentSize.height);
    }

    return 44;
}

- (NSString *)tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
    switch (section) {
        case 0:
            return NSLocalizedStringFromTable(@"AAMFeedbackTableHeaderTopics", @"AAMLocalizable", nil);
        case 1:
            return NSLocalizedStringFromTable(@"AAMFeedbackTableHeaderBasicInfo", @"AAMLocalizable", nil);
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section == 1) {
            //General Infos
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        } else {
            if (indexPath.row == 0) {
                //Topics
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                //Topics Description
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 300,
                    88)];
                _descriptionTextView.backgroundColor = [UIColor clearColor];
                _descriptionTextView.font = [UIFont systemFontOfSize:16];
                _descriptionTextView.delegate = self;
                _descriptionTextView.scrollEnabled = NO;
                _descriptionTextView.text = self.descriptionText;
                [cell.contentView addSubview:_descriptionTextView];

                _descriptionPlaceHolder = [[UITextField alloc] initWithFrame:CGRectMake(16, 8, 300,
                    20)];
                _descriptionPlaceHolder.font = [UIFont systemFontOfSize:16];
                _descriptionPlaceHolder.placeholder = NSLocalizedStringFromTable(@"AAMFeedbackDescriptionPlaceholder", @"AAMLocalizable", nil);
                _descriptionPlaceHolder.userInteractionEnabled = NO;
                [cell.contentView addSubview:_descriptionPlaceHolder];

                [self _updatePlaceholder];
            }
        }
    }

    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:

                    cell.textLabel.text = NSLocalizedStringFromTable(@"AAMFeedbackTopicsTitle", @"AAMLocalizable", nil);
                    cell.detailTextLabel.text = NSLocalizedStringFromTable([self _selectedTopic], @"AAMLocalizable", nil);
                    break;
                case 1:
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Device";
                    cell.detailTextLabel.text = [self _platformString];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 1:
                    cell.textLabel.text = @"iOS";
                    cell.detailTextLabel.text = [UIDevice currentDevice].systemVersion;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 2:
                    cell.textLabel.text = @"App Name";
                    cell.detailTextLabel.text = [self _appName];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 3:
                    cell.textLabel.text = @"App Version";
                    cell.detailTextLabel.text = [self _appVersion];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }

    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [_descriptionTextView resignFirstResponder];
        AAMFeedbackTopicsViewController *topicsViewController = [[AAMFeedbackTopicsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        if (self.backgroundImage != nil) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
            topicsViewController.tableView.backgroundView = backgroundImageView;
        }
        topicsViewController.topics = [self.topics copy];
        topicsViewController.delegate = self;
        topicsViewController.selectedIndex = _selectedTopicsIndex;
        [self.navigationController pushViewController:topicsViewController animated:YES];
    }
}


- (void)cancelDidPress:(id) sender {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        [self dismissViewControllerAnimated:YES completion:nil];
#else
        [self dismissModalViewControllerAnimated:YES];
#endif
}

- (void)nextDidPress:(id) sender {
    [_descriptionTextView resignFirstResponder];

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:self.toRecipients];
    [picker setCcRecipients:self.ccRecipients];
    [picker setBccRecipients:self.bccRecipients];

    [picker setSubject:[self _feedbackSubject]];
    [picker setMessageBody:[self _feedbackBody] isHTML:NO];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self presentViewController:picker animated:YES completion:nil];
#else
    [self presentModalViewController:picker animated:YES];
#endif

}


- (void)textViewDidChange:(UITextView *) textView {
    CGRect f = _descriptionTextView.frame;
    f.size.height = _descriptionTextView.contentSize.height;
    _descriptionTextView.frame = f;
    [self _updatePlaceholder];
    self.descriptionText = _descriptionTextView.text;

    //Magic for updating Cell height
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


- (void)mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult) result error:(NSError *) error {
    if (result == MFMailComposeResultCancelled) {
    } else if (result == MFMailComposeResultSent) {
        _isFeedbackSent = YES;
    } else if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"AAMFeedbackMailDidFinishWithError"
                                                                    delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [controller dismissViewControllerAnimated:YES completion:nil];
#else
    [controller dismissModalViewControllerAnimated:YES];
#endif
}


- (void)feedbackTopicsViewController:(AAMFeedbackTopicsViewController *) feedbackTopicsViewController
               didSelectTopicAtIndex:(NSInteger) selectedIndex {
    _selectedTopicsIndex = selectedIndex;
}

#pragma mark - Internal Info

- (void)_updatePlaceholder {
    if ([_descriptionTextView.text length] > 0) {
        _descriptionPlaceHolder.hidden = YES;
    } else {
        _descriptionPlaceHolder.hidden = NO;
    }
}

- (NSString *)_feedbackSubject {
    return [NSString stringWithFormat:@"%@: %@", [self _appName], [self _selectedTopicToSend]];
}

- (NSString *)_feedbackBody {
    NSString *body = [NSString stringWithFormat:@"%@\n\n\nDevice:\n%@\n\niOS:\n%@\n\nApp:\n%@ %@",
                                                _descriptionTextView.text,
                                                [self _platformString],
                                                [UIDevice currentDevice].systemVersion,
                                                [self _appName],
                                                [self _appVersion]];

    return body;
}

- (NSString *)_selectedTopic {
    return (self.topics)[(NSUInteger)_selectedTopicsIndex];
}

- (NSString *)_selectedTopicToSend {
    return (self.topicsToSend)[(NSUInteger)_selectedTopicsIndex];
}

- (NSString *)_appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

- (NSString *)_appVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}


- (NSString *)_platformString {
    return [UIDeviceHardware platformString];
}

@end
