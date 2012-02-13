//
//  JTTableViewGestureDelegate.m
//  JTGestureBasedTableViewDemo
//
//  Created by James Tang on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JTTableViewGestureRecognizer.h"

@interface JTTableViewGestureRecognizer ()
@property (nonatomic, assign) id <JTTableViewGestureDelegate> delegate;
@property (nonatomic, assign) id <UITableViewDelegate>        tableViewDelegate;
@property (nonatomic, assign) UITableView               *tableView;
@property (nonatomic, assign) CGFloat                    addingRowHeight;
@property (nonatomic, retain) NSIndexPath               *addingIndexPath;
@property (nonatomic, assign) CGPoint                    startPinchingUpperPoint;
@property (nonatomic, retain) UIPinchGestureRecognizer  *pinchRecognizer;
@end

@implementation JTTableViewGestureRecognizer
@synthesize delegate, tableView, tableViewDelegate;
@synthesize addingIndexPath, startPinchingUpperPoint, addingRowHeight;
@synthesize pinchRecognizer;

#pragma mark Action

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer {
    NSLog(@"%d %f %f", [recognizer numberOfTouches], [recognizer velocity], [recognizer scale]);
    if (recognizer.state == UIGestureRecognizerStateEnded || [recognizer numberOfTouches] < 2) {
        if (self.addingIndexPath) {
            UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.addingIndexPath];
            [self.tableView beginUpdates];
            
            
            CGFloat commitingCellHeight = self.tableView.rowHeight;
            if ([self.delegate respondsToSelector:@selector(heightForCommittingRowForGestureRecognizer:)]) {
                commitingCellHeight = [self.delegate heightForCommittingRowForGestureRecognizer:self];
            }

            if (cell.frame.size.height >= commitingCellHeight) {
                [self.delegate gestureRecognizer:self needsCommitRowAtIndexPath:self.addingIndexPath];
            } else {
                [self.delegate gestureRecognizer:self needsDiscardRowAtIndexPath:self.addingIndexPath];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            self.addingIndexPath = nil;
            [self.tableView endUpdates];
            
            // Restore contentInset while touch ends
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];  // Should not be less than the duration of row animation 
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [UIView commitAnimations];
        }
        return;
    }
    
    CGPoint location1 = [recognizer locationOfTouch:0 inView:self.tableView];
    CGPoint location2 = [recognizer locationOfTouch:1 inView:self.tableView];
    CGPoint upperPoint = location1.y < location2.y ? location1 : location2;
    
    CGRect  rect = (CGRect){location1, location2.x - location1.x, location2.y - location1.y};
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSArray *indexPaths = [self.tableView indexPathsForRowsInRect:rect];
        
        NSIndexPath *firstIndexPath = [indexPaths objectAtIndex:0];
        NSIndexPath *lastIndexPath  = [indexPaths lastObject];
        NSInteger    midIndex = ((float)(firstIndexPath.row + lastIndexPath.row) / 2) + 0.5;
        NSIndexPath *midIndexPath = [NSIndexPath indexPathForRow:midIndex inSection:firstIndexPath.section];
        
        // Setting up properties for referencing later when touches changes
        self.startPinchingUpperPoint = upperPoint;
        
        if ([self.delegate respondsToSelector:@selector(gestureRecognizer:willCreateCellAtIndexPath:)]) {
           self.addingIndexPath = [self.delegate gestureRecognizer:self willCreateCellAtIndexPath:midIndexPath];
        } else {
            self.addingIndexPath = midIndexPath;
        }
        
        // Creating contentInset to fulfill the whole screen, so our tableview won't occasionaly
        // bounds back to the top while we don't have enough cells on the screen
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height, 0, self.tableView.frame.size.height, 0);

        if (self.addingIndexPath) {
            [self.tableView beginUpdates];
            
            [self.delegate gestureRecognizer:self needsAddRowAtIndexPath:self.addingIndexPath];

            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat diffRowHeight = CGRectGetHeight(rect) - CGRectGetHeight(rect)/[recognizer scale];
        
        NSLog(@"%f %f %f", CGRectGetHeight(rect), CGRectGetHeight(rect)/[recognizer scale], [recognizer scale]);
        if (self.addingRowHeight - diffRowHeight >= 1 || self.addingRowHeight - diffRowHeight <= -1) {
            self.addingRowHeight = diffRowHeight;
            [self.tableView reloadData];
        }
        
        // Scrolls tableview according to the upper touch point to mimic a realistic
        // dragging gesture
        CGPoint newUpperPoint = upperPoint;
        CGFloat diffOffsetY = self.startPinchingUpperPoint.y - newUpperPoint.y;
        CGPoint newOffset   = (CGPoint){self.tableView.contentOffset.x, self.tableView.contentOffset.y+diffOffsetY};
        [self.tableView setContentOffset:newOffset animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.addingIndexPath]) {
        return MAX(1, self.addingRowHeight);
    }
    
    CGFloat normalCellHeight = aTableView.rowHeight;
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        normalCellHeight = [self.tableViewDelegate tableView:aTableView heightForRowAtIndexPath:indexPath];
    }
    return normalCellHeight;
}

#pragma mark NSProxy

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.tableViewDelegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [(NSObject *)self.tableViewDelegate methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    NSAssert(self.tableViewDelegate != nil, @"self.tableViewDelegate should not be nil, assign your tableView.delegate before enabling gestureRecognizer", nil);
    if ([self.tableViewDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [[self class] instancesRespondToSelector:aSelector];
}

#pragma mark Class method

+ (JTTableViewGestureRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id<JTTableViewGestureDelegate>)delegate {
    JTTableViewGestureRecognizer *recognizer = [[JTTableViewGestureRecognizer alloc] init];
    recognizer.delegate             = delegate;
    recognizer.tableView            = tableView;
    recognizer.tableViewDelegate    = tableView.delegate;     // Assign the delegate before chaning the tableView's delegate
    tableView.delegate              = recognizer;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:recognizer action:@selector(pinchGestureRecognizer:)];
    [tableView addGestureRecognizer:pinch];
    recognizer.pinchRecognizer = pinch;
    return recognizer;
}

@end


@implementation UITableView (JTTableViewGestureDelegate)

- (JTTableViewGestureRecognizer *)enableGestureTableViewWithDelegate:(id <JTTableViewGestureDelegate>)delegate {
    JTTableViewGestureRecognizer *recognizer = [JTTableViewGestureRecognizer gestureRecognizerWithTableView:self delegate:delegate];
    return recognizer;
}

@end