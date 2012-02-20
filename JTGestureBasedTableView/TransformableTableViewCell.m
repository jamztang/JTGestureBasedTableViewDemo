/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "TransformableTableViewCell.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransformableTableViewCell

@synthesize finishedHeight, tintColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.f;
        [self.contentView.layer setSublayerTransform:transform];
        
        self.textLabel.layer.anchorPoint = CGPointMake(0.5, 0.0);

        self.detailTextLabel.layer.anchorPoint = CGPointMake(0.5, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat fraction = (self.frame.size.height / self.finishedHeight);
    fraction = MAX(MIN(1, fraction), 0);
    
    CGFloat angle = (M_PI / 2) - asinf(fraction);
    CATransform3D transform = CATransform3DMakeRotation(angle, -1, 0, 0);
    [self.textLabel.layer setTransform:transform];
    [self.detailTextLabel.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - asinf(fraction), 1, 0, 0)];


    if (fraction == 1) {
        self.textLabel.backgroundColor       = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor     = self.tintColor;
    } else {
        self.textLabel.backgroundColor       = [self.tintColor colorWithBrightness:0.3 + 0.7*fraction];
        self.detailTextLabel.backgroundColor = [self.tintColor colorWithBrightness:0.5 + 0.5*fraction];
        self.contentView.backgroundColor     = [UIColor clearColor];
    }

    fraction = 1 / fraction;

    CGFloat labelHeight = ceilf(self.contentView.frame.size.height/2*fraction);
    labelHeight = MIN(MAX(1, labelHeight), 800);
    
    self.textLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, labelHeight);
    self.detailTextLabel.frame = CGRectMake(0,self.contentView.frame.size.height - labelHeight, self.contentView.frame.size.width, labelHeight);
}

@end
