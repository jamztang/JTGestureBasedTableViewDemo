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

<img src=https://github.com/mystcolor/JTGestureBasedTableViewDemo/raw/master/demo1.png width=280 style="border: 1px solid white;"></img>
<img src=https://github.com/mystcolor/JTGestureBasedTableViewDemo/raw/master/demo2.png width=280 style="border: 1px solid white;"></img>
<img src=https://github.com/mystcolor/JTGestureBasedTableViewDemo/raw/master/demo3.png width=280 style="border: 1px solid white;"></img>


Features
--------

It only supports three features at the moment.

- Pull down to add cell
- Pinch to create cell
- Panning on cell gesture

How To Use It
-------------


### Installation

Include all header and implementation files in JTGestureBasedTabeView/ into your project, and also links the QuartzCore framework to your target.


### Setting up your UITableView for your viewController

    #import "JTTableViewGestureRecognizer.h"
    
    @interface ViewController () <JTTableViewGestureAddingRowDelegate, JTTableViewGestureEditingRowDelegate>
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
        
        // Setup your tableView.delegate and tableView.datasource,
        // then enable gesture recognition in one line.
        self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
    }


### Enabling adding cell gestures

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

    @end


### Enabling editing cell gestures

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


### You choose what to enable

You can pick what gestures to be enabled by conforming to the appropriate protocols.
Don't forget to look at JTGestureBasedTableViewDemo/ViewController.m for a complete working usage.


License
-------

This project is under MIT License, please feel free to contribute and use it.

James

