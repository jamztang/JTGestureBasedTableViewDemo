/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIGestureRecognizer+JTGestureRecognizerHelper.h"


@implementation UIGestureRecognizer (JTGestureRecognizerHelper)

- (CGPoint)topPoint {
    if ([self numberOfTouches] < 2) {
        return [self locationInView:nil];
    } else {
        CGPoint upperPoint = CGPointMake(0, NSIntegerMax);
        for (int i = 0; i < [self numberOfTouches]; i++) {
            CGPoint location = [self locationOfTouch:i inView:self.view];
            if (location.y <= upperPoint.y) {
                upperPoint = location;
            }
        }
        return upperPoint;
    }
}

- (CGPoint)bottomPoint {
    if ([self numberOfTouches] < 2) {
        return [self locationInView:nil];
    } else {
        CGPoint bottomPoint = CGPointMake(0, 0);
        for (int i = 0; i < [self numberOfTouches]; i++) {
            CGPoint location = [self locationOfTouch:i inView:self.view];
            if (location.y >= bottomPoint.y) {
                bottomPoint = location;
            }
        }
        return bottomPoint;
    }
}

@end