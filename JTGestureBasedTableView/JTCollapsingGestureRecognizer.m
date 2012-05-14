/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTCollapsingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIGestureRecognizer+JTGestureRecognizerHelper.h"

@interface JTCollapsingGestureRecognizer ()
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGSize startLength;
@property (nonatomic, assign) CGPoint translation;
@property (nonatomic, assign) CGSize distanceDifference;
@end

@implementation JTCollapsingGestureRecognizer
@synthesize startPoint, startLength;
@synthesize translation, distanceDifference;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint topPoint    = self.topPoint;
    CGPoint bottomPoint = self.bottomPoint;
    self.startPoint  = topPoint;
    self.startLength = (CGSize){bottomPoint.x - topPoint.x, bottomPoint.y - topPoint.y};
    self.translation     = CGPointZero;
    self.distanceDifference     = CGSizeZero;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint topPoint = self.topPoint;
    CGPoint bottomPoint = self.bottomPoint;
    self.translation = (CGPoint){topPoint.x - self.startPoint.x, topPoint.y - self.startPoint.y};
    CGSize currentLength = (CGSize){bottomPoint.x - topPoint.x, bottomPoint.y - topPoint.y};
    self.distanceDifference = (CGSize){currentLength.width - self.startLength.width, currentLength.height - self.startLength.height};
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

@end
