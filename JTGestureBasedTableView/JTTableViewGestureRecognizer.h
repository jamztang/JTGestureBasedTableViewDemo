/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

typedef enum {
    JTTableViewCellEnterStateMiddle,
    JTTableViewCellEnterStateLeft,
    JTTableViewCellEnterStateRight,
} JTTableViewCellEnterState;

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

// Panning
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didChangeContentViewTranslation:(CGPoint)translation forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterState:(JTTableViewCellEnterState)state forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEnterState)state forRowAtIndexPath:(NSIndexPath *)indexPath;

@end





@interface UITableView (JTTableViewGestureDelegate)

- (JTTableViewGestureRecognizer *)enableGestureTableViewWithDelegate:(id <JTTableViewGestureDelegate>)delegate;

@end