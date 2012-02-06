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
        
        [self addObserver:self forKeyPath:@"frame"
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                  context:nil];
        
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.f;
        [self.contentView.layer setSublayerTransform:transform];

        
        self.textLabel.layer.anchorPoint = CGPointMake(0.5, 0.0);
        self.textLabel.clipsToBounds = NO;

        self.detailTextLabel.layer.anchorPoint = CGPointMake(0.5, 1.0);
        self.detailTextLabel.clipsToBounds = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {

        CGFloat fraction = self.frame.size.height / self.finishedHeight;
        
        CATransform3D transform = CATransform3DMakeRotation((M_PI / 2) - asinf(fraction), -1, 0, 0);
        [self.textLabel.layer setTransform:transform];
        [self.detailTextLabel.layer setTransform:CATransform3DMakeRotation((M_PI / 2) - asinf(fraction), 1, 0, 0)];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat fraction = 1 / (self.frame.size.height / self.finishedHeight);
    
    self.textLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    self.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];

    CGFloat labelHeight = self.contentView.frame.size.height/2*fraction;
    self.textLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, labelHeight);
    self.detailTextLabel.frame = CGRectMake(0,self.contentView.frame.size.height - labelHeight, self.contentView.frame.size.width, labelHeight);
}

@end
