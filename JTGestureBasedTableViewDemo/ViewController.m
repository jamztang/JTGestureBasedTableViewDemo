//
//  ViewController.m
//  JTGestureBasedTableViewDemo
//
//  Created by James Tang on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TransformableTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSIndexPath    *addingIndexPath;
@property (nonatomic, assign) CGFloat         addingRowHeight;
@property (nonatomic, assign) CGPoint         startPinchingUpperPoint;
@end

@implementation ViewController
@synthesize rows;
@synthesize addingIndexPath, addingRowHeight, startPinchingUpperPoint;

#define ADDING_CELL @"Continue to pinch..."
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.rows = [NSMutableArray arrayWithObjects:@"Try to pinch between this cell", @"And this cell to create a new one", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    [self.tableView addGestureRecognizer:recognizer];
}

#pragma mark Action

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer {
//    NSLog(@"%d %f %f", [recognizer numberOfTouches], [recognizer velocity], [recognizer scale]);
    if (recognizer.state == UIGestureRecognizerStateEnded || [recognizer numberOfTouches] < 2) {
        if (self.addingIndexPath) {
            TransformableTableViewCell *cell = (TransformableTableViewCell *)[self.tableView cellForRowAtIndexPath:self.addingIndexPath];
            [self.tableView beginUpdates];

            if (cell.frame.size.height >= COMMITING_CREATE_CELL_HEIGHT) {
                [self.rows replaceObjectAtIndex:self.addingIndexPath.row withObject:@"Added!"];
                cell.textLabel.text = @"Added!";
                cell.finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
            } else {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                [self.rows removeObject:ADDING_CELL];
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
        self.addingIndexPath = midIndexPath;

        // Creating contentInset to fulfill the whole screen, so our tableview won't occasionaly
        // bounds back to the top while we don't have enough cells on the screen
        self.tableView.contentInset = UIEdgeInsetsMake(self.view.frame.size.height, 0, self.view.frame.size.height, 0);

        [self.tableView beginUpdates];
        [self.rows insertObject:ADDING_CELL atIndex:midIndex];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
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

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rows count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyCell";

    TransformableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TransformableTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSObject *object = [self.rows objectAtIndex:indexPath.row];
    if ([object isEqual:ADDING_CELL]) {
        cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
        if (cell.frame.size.height >= COMMITING_CREATE_CELL_HEIGHT) {
            cell.textLabel.text = @"Release to create cell...";
        } else {
            cell.textLabel.text = ADDING_CELL;
        }
        cell.detailTextLabel.text = @" ";
    } else {
        cell.finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@", indexPath.row, (NSString *)object];
        cell.detailTextLabel.text = @" ";
    }
    
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.addingIndexPath]) {
        return MAX(1, self.addingRowHeight);
    }
    return NORMAL_CELL_FINISHING_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
