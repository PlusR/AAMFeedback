//
//  AAMFeedbackTopicsViewController.m
//  AAMFeedbackViewController
//
//  Original Created by 深津 貴之 on 11/11/30.
//  Copyright (c) 2011年 Art & Mobile. All rights reserved.
//

#import "AAMFeedbackTopicsViewController.h"
#import "AAMFeedbackViewController.h"


@interface AAMFeedbackTopicsViewController ()

- (void)_updateCellSelection;

@end


@implementation AAMFeedbackTopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTableInBundle(@"AAMFeedbackTopicsTitle",  @"AAMLocalizable", [AAMFeedbackViewController bundle], nil);
}

- (void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self _updateCellSelection];
}

- (void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.topics count];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger row = (NSUInteger)indexPath.row;
    cell.textLabel.text = NSLocalizedStringFromTableInBundle((self.topics)[row],  @"AAMLocalizable", [AAMFeedbackViewController bundle], nil);

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    NSInteger row = indexPath.row;
    self.selectedIndex = row;
    [self _updateCellSelection];

    if ([self.delegate respondsToSelector:@selector(feedbackTopicsViewController:didSelectTopicAtIndex:)]) {
        [self.delegate feedbackTopicsViewController:self didSelectTopicAtIndex:row];
    }
}

#pragma mark - Internal
- (void)_updateCellSelection {
    NSArray *cells = [self.tableView visibleCells];
    NSUInteger n = [cells count];
    for (int i = 0; i < n; i++) {
        UITableViewCell *cell = cells[(NSUInteger)i];
        if (@available(iOS 13.0, *)) {
            cell.textLabel.textColor = [UIColor labelColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    NSIndexPath *path = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];

    UITableViewCell *cell;
    cell = [self.tableView cellForRowAtIndexPath:path];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.textColor = [UIColor systemBlueColor];
    [cell setSelected:NO animated:YES];
}

@end
