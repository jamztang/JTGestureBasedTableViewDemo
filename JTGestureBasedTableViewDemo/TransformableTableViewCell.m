//
//  TransformableTableViewCell.m
//  JTGestureBasedTableViewDemo
//
//  Created by James Tang on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransformableTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransformableTableViewCell

@synthesize finishedHeight;

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

    self.textLabel.backgroundColor = [UIColor colorWithWhite:0.65 + 0.3*fraction alpha:1];
    self.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0.7 + 0.275*fraction alpha:1];

    fraction = 1 / fraction;

    CGFloat labelHeight = (int)(self.contentView.frame.size.height/2*fraction + 0.5);
    labelHeight = MIN(MAX(1, labelHeight), 800);
    
    self.textLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, labelHeight);
    self.detailTextLabel.frame = CGRectMake(0,self.contentView.frame.size.height - labelHeight, self.contentView.frame.size.width, labelHeight);
}

@end
