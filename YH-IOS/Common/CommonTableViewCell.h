//
//  CommonTableViewCell.h
//  JinXiaoEr
//
//  Created by CJG on 17/3/28.
//
//

#import <UIKit/UIKit.h>

@interface CommonTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel* leftLab;
@property (nonatomic, strong) UILabel* rightLab;
@property (nonatomic, strong) UIImageView* rightImageV;
@property (nonatomic, strong) UIView* lineView;

- (void)setTitleStyle:(BOOL)set;

- (void)updateLeftPadding:(CGFloat)padding;
@end
