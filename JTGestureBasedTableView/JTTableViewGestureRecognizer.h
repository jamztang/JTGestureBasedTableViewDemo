//
//  JTTableViewGestureDelegate.h
//  JTGestureBasedTableViewDemo
//
//  Created by James Tang on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTableViewGestureDelegate;

@interface JTTableViewGestureRecognizer : NSObject <UITableViewDelegate>

@property (nonatomic, assign, readonly) UITableView *tableView;

+ (JTTableViewGestureRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id <JTTableViewGestureDelegate>)delegate;

@end


@protocol JTTableViewGestureDelegate <NSObject, UITableViewDelegate>

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath;
@optional

- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForCommittingRowForGestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer;

@end





@interface UITableView (JTTableViewGestureDelegate)

- (JTTableViewGestureRecognizer *)enableGestureTableViewWithDelegate:(id <JTTableViewGestureDelegate>)delegate;

@end