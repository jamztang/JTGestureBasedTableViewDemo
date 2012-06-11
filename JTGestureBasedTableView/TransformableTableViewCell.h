/*
 * This file is part of the JTGestureBasedTableView package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

typedef enum {
    TransformableTableViewCellStyleUnfolding,
    TransformableTableViewCellStylePullDown,
} TransformableTableViewCellStyle;


@protocol TransformableTableViewCell <NSObject>

@property (nonatomic, assign) CGFloat  finishedHeight;
@property (nonatomic, strong) UIColor *tintColor;   // default is white color

@end


@interface TransformableTableViewCell : UITableViewCell <TransformableTableViewCell>

// Use this factory method instead of 
// - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+ (TransformableTableViewCell *)transformableTableViewCellWithStyle:(TransformableTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
