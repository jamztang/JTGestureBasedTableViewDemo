JTGestureBasedTableView
=======================

An iOS objective-c library template to recreate the gesture based interaction found from Clear for iPhone app.

While it's just in very early development stage, I don't think it's ready for and production usage.

It has been developed under iOS 4.3 and 5.0 devices, sample code has been built using ARC, please use -fobjc-arc per source file complier flag for compiling on non-ARC enviroment.


Abstract
--------

Clear for iPhone app has showed us so much we can do with a buttonless interface, and I am trying to reveal the technique behind the gesture based interaction, hopefully can heavy-lifted all of us whom trying to achieve the same.


Demo
----

<img src=https://github.com/mystcolor/JTGestureBasedTableViewDemo/raw/master/demo1.png width=320></img> 
<img src=https://github.com/mystcolor/JTGestureBasedTableViewDemo/raw/master/demo2.png width=320></img>


Features
--------

It only supports two features at the moment.

- Pull down to add cell
- Pinch to create cell

How To Use It
-------------


### Installation

Include all header and implementation files in JTGestureBasedTabeView/ into your project, and also links the QuartzCore framework to your target.


### Setting up your UITableView for your viewController

    #import "JTTableViewGestureRecognizer.h"
    
    @interface ViewController () <JTTableViewGestureDelegate>
    @property (nonatomic, strong) NSMutableArray *rows;
    @property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
    @end
    
    @implementation ViewController
    @synthesize tableViewRecognizer;
    
    - (void)viewDidload {
        /*
        :
        */
    
        // In our examples, we setup self.rows as datasource
        self.rows = ...;
        
        // Setup your tableView.delegate and tableView.datasource first, then enable gesture
        // recognition in one line.
        self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
    }


### Implement the JTTableViewGestureDelegate, and also those official UITableViewDatasource @required methods

    #pragma mark JTTableViewGestureRecognizer
    
    - (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
        [self.rows insertObject:ADDING_CELL atIndex:indexPath.row];
    }
    
    - (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
        [self.rows replaceObjectAtIndex:indexPath.row withObject:@"Added!"];
        UITableViewCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"Just Added!";
    }
    
    - (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
        [self.rows removeObjectAtIndex:indexPath.row];
    }


Don't forget to look at JTGestureBasedTableViewDemo/ViewController.m for a complete working usage.


License
-------

This project is under MIT License, please feel free to contribute and use it.

James

