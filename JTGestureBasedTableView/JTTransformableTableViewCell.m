/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTTransformableTableViewCell.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark -

@implementation JTUnfoldingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.f;
        [self.contentView.layer setSublayerTransform:transform];
        
        self.transformable1HalfView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [self.transformable1HalfView.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
        [self.transformable1HalfView setClipsToBounds:YES];
        [self.contentView addSubview:self.transformable1HalfView];
        
        self.transformable2HalfView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [self.transformable2HalfView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
        [self.transformable2HalfView setClipsToBounds:YES];
        [self.contentView addSubview:self.transformable2HalfView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.autoresizingMask = UIViewAutoresizingNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.autoresizingMask = UIViewAutoresizingNone;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat fraction = (self.frame.size.height / self.finishedHeight);
    fraction = MAX(MIN(1, fraction), 0);
    
    CGFloat angle = (M_PI / 2) - asinf(fraction);
    CATransform3D transform = CATransform3DMakeRotation(angle, -1, 0, 0);
    [self.transformable1HalfView.layer setTransform:transform];
    [self.transformable2HalfView.layer setTransform:CATransform3DMakeRotation(angle, 1, 0, 0)];
    
    self.transformable1HalfView.backgroundColor = [self.tintColor colorWithBrightness:0.3 + 0.7*fraction];
    self.transformable2HalfView.backgroundColor = [self.tintColor colorWithBrightness:0.5 + 0.5*fraction];

    CGSize contentViewSize = self.contentView.frame.size;
    CGFloat contentViewMidY = contentViewSize.height / 2;
    CGFloat labelHeight = self.finishedHeight / 2;

    // OPTI: Always accomodate 1 px to the top label to ensure two labels 
    // won't display one px gap in between sometimes for certain angles 
    self.transformable1HalfView.frame = CGRectMake(0, contentViewMidY - (labelHeight * fraction),
                                                   contentViewSize.width, labelHeight + 1);
    self.transformable2HalfView.frame = CGRectMake(0, contentViewMidY - (labelHeight * (1 - fraction)),
                                                    contentViewSize.width, labelHeight);
    
    if ([self.textLabel.text length]) {
        self.detailTextLabel.text = self.textLabel.text;
        self.detailTextLabel.font = self.textLabel.font;
        self.detailTextLabel.textColor = self.textLabel.textColor;
        self.detailTextLabel.textAlignment = self.textLabel.textAlignment;
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.shadowColor = self.textLabel.shadowColor;
        self.detailTextLabel.shadowOffset = self.textLabel.shadowOffset;
    }
    self.textLabel.frame = CGRectMake(10.0, 0.0, contentViewSize.width - 20.0, self.finishedHeight);
    self.detailTextLabel.frame = CGRectMake(10.0, -self.finishedHeight / 2, contentViewSize.width - 20.0, self.finishedHeight);
}

- (UILabel *)textLabel
{
    UILabel *label = [super textLabel];
    if ([label superview] != [self transformable1HalfView])
        [self.transformable1HalfView addSubview:label];
    return label;
}

- (UILabel *)detailTextLabel
{
    UILabel *label = [super detailTextLabel];
    if ([label superview] != [self transformable2HalfView])
        [self.transformable2HalfView addSubview:label];
    return label;
}

- (UIImageView *)imageView
{
    UIImageView *imageView = [super imageView];
    if ([imageView superview] != [self transformable1HalfView])
        [self.transformable1HalfView addSubview:imageView];
    return imageView;
}

@end

@implementation JTPullDownTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1/500.f;
        [self.contentView.layer setSublayerTransform:transform];
        
        _transformableView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [_transformableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_transformableView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
        [self.contentView addSubview:_transformableView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.autoresizingMask = UIViewAutoresizingNone;
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)textLabel
{
    UILabel *label = [super textLabel];
    if ([label superview] != [self transformableView])
        [self.transformableView addSubview:label];
    return label;
}

- (UILabel *)detailTextLabel
{
    UILabel *label = [super detailTextLabel];
    if ([label superview] != [self transformableView])
        [self.transformableView addSubview:label];
    return label;
}

- (UIImageView *)imageView
{
    UIImageView *imageView = [super imageView];
    if ([imageView superview] != [self transformableView])
        [self.transformableView addSubview:imageView];
    return imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat fraction = (self.frame.size.height / self.finishedHeight);
    fraction = MAX(MIN(1, fraction), 0);
    
    CGFloat angle = (M_PI / 2) - asinf(fraction);
    CATransform3D transform = CATransform3DMakeRotation(angle, 1, 0, 0);
    [self.transformableView setFrame:self.contentView.bounds];
    [self.transformableView.layer setTransform:transform];
    self.transformableView.backgroundColor = [self.tintColor colorWithBrightness:0.3 + 0.7*fraction];
    
    CGSize contentViewSize = self.contentView.frame.size;
    
    // OPTI: Always accomodate 1 px to the top label to ensure two labels
    // won't display one px gap in between sometimes for certain angles
    self.transformableView.frame = CGRectMake(0.0, contentViewSize.height - self.finishedHeight,
                                              contentViewSize.width, self.finishedHeight);
    
    // 05/07/2012 : Added by SungDong Kim 
    CGSize requiredLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                               constrainedToSize:contentViewSize
                                                   lineBreakMode:UILineBreakModeClip];
    self.imageView.frame = CGRectMake(10.0 + requiredLabelSize.width + 10.0,
                                      (self.finishedHeight - self.imageView.frame.size.height)/2,
                                      self.imageView.frame.size.width,
                                      self.imageView.frame.size.height);
    
    self.textLabel.frame = CGRectMake(10.0, 0.0, contentViewSize.width - 20.0, self.finishedHeight);
}

@end



#pragma mark -

@implementation JTTransformableTableViewCell

@synthesize finishedHeight, tintColor;

+ (JTTransformableTableViewCell *)unfoldingTableViewCellWithReuseIdentifier:(NSString *)reuseIdentifier {
    JTUnfoldingTableViewCell *cell = (id)[[JTUnfoldingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                                           reuseIdentifier:reuseIdentifier];
    return cell;
}

+ (JTTransformableTableViewCell *)pullDownTableViewCellWithReuseIdentifier:(NSString *)reuseIdentifier {
    JTPullDownTableViewCell *cell = (id)[[JTPullDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                          reuseIdentifier:reuseIdentifier];
    return cell;
}

+ (JTTransformableTableViewCell *)transformableTableViewCellWithStyle:(JTTransformableTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    switch (style) {
        case JTTransformableTableViewCellStylePullDown:
            return [JTTransformableTableViewCell pullDownTableViewCellWithReuseIdentifier:reuseIdentifier];
            break;
        case JTTransformableTableViewCellStyleUnfolding:
        default:
            return [JTTransformableTableViewCell unfoldingTableViewCellWithReuseIdentifier:reuseIdentifier];
            break;
    }
}

@end
