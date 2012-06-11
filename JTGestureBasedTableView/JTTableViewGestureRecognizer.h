/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

typedef enum {
    JTTableViewCellEditingStateMiddle,
    JTTableViewCellEditingStateLeft,
    JTTableViewCellEditingStateRight,
} JTTableViewCellEditingState;

extern CGFloat const JTTableViewCommitEditingRowDefaultLength;

// JTTableViewRowAnimationDuration is decided to be as close as the internal settings of UITableViewRowAnimation duration
extern CGFloat const JTTableViewRowAnimationDuration;

@protocol JTTableViewGestureAddingRowDelegate;
@protocol JTTableViewGestureEditingRowDelegate;
@protocol JTTableViewGestureMoveRowDelegate;


@interface JTTableViewGestureRecognizer : NSObject <UITableViewDelegate>

@property (nonatomic, weak, readonly) UITableView *tableView;

+ (JTTableViewGestureRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id)delegate;

@end


#pragma mark -

// Conform to JTTableViewGestureAddingRowDelegate to enable features
// - drag down to add cell
// - pinch to add cell
@protocol JTTableViewGestureAddingRowDelegate <NSObject>

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer heightForCommittingRowAtIndexPath:(NSIndexPath *)indexPath;


// Depreciated.
- (CGFloat)heightForCommittingRowForGestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer __deprecated;  // please use - [JTTableViewGestureAddingRowDelegate gestureRecognizer:heightForCommitRowAtIndexPath:]

@end


// Conform to JTTableViewGestureEditingRowDelegate to enable features
// - swipe to edit cell
@protocol JTTableViewGestureEditingRowDelegate <NSObject>

// Panning (required)
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer lengthForCommitEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didChangeContentViewTranslation:(CGPoint)translation forRowAtIndexPath:(NSIndexPath *)indexPath;

@end


// Conform to JTTableViewGestureMoveRowDelegate to enable features
// - long press to reorder cell
@protocol JTTableViewGestureMoveRowDelegate <NSObject>

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface UITableView (JTTableViewGestureDelegate)

- (JTTableViewGestureRecognizer *)enableGestureTableViewWithDelegate:(id)delegate;

// Helper methods for updating cell after datasource changes
- (void)reloadVisibleRowsExceptIndexPath:(NSIndexPath *)indexPath;

@end