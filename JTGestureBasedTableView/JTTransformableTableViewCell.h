/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

typedef enum {
    JTTransformableTableViewCellStyleUnfolding,
    JTTransformableTableViewCellStylePullDown,
} JTTransformableTableViewCellStyle;


@protocol JTTransformableTableViewCell <NSObject>

@property (nonatomic, assign) CGFloat  finishedHeight;
@property (nonatomic, strong) UIColor *tintColor;   // default is white color

@end


@interface JTTransformableTableViewCell : UITableViewCell <JTTransformableTableViewCell>

// Use this factory method instead of 
// - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+ (JTTransformableTableViewCell *)transformableTableViewCellWithStyle:(JTTransformableTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end


@interface JTUnfoldingTableViewCell : JTTransformableTableViewCell

@property (nonatomic, strong) UIView *transformable1HalfView;
@property (nonatomic, strong) UIView *transformable2HalfView;

@end

@interface JTPullDownTableViewCell : JTTransformableTableViewCell

@property (nonatomic, strong) UIView *transformableView;

@end
