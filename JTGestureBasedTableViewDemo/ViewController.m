//
//  ViewController.m
//  JTGestureBasedTableViewDemo
//
//  Created by James Tang on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TransformableTableViewCell.h"
#import "JTTableViewGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <JTTableViewGestureDelegate>
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
@end

@implementation ViewController
@synthesize rows;
@synthesize tableViewRecognizer;

#define ADDING_CELL @"Continue to pinch..."
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.rows = [NSMutableArray arrayWithObjects:
                     @"Try to pinch between any cell to create a new one",
                     @"example cell 1",
                     @"example cell 2",
                     @"example cell 3",
                     @"example cell 4",
                     @"example cell 5",
                     @"example cell 6",
                     nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@", (NSString *)object];
        cell.detailTextLabel.text = @" ";
    }

    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NORMAL_CELL_FINISHING_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

#pragma mark JTTableViewGestureRecognizer

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rows insertObject:ADDING_CELL atIndex:indexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rows replaceObjectAtIndex:indexPath.row withObject:@"Added!"];
    TransformableTableViewCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];
    cell.finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
    cell.textLabel.text = @"Just Added!";
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rows removeObjectAtIndex:indexPath.row];
}

@end
