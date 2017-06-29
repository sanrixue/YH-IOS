//
//  RightSwitchTableViewCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RightSwitchCellDelegate <NSObject>

-(void)SwitchTableViewCellButtonClick:(UIButton *)button with:(NSInteger)cellId withIsClick:(BOOL)click;

@end


@interface RightSwitchTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *SwitchButton;

@property (weak, nonatomic) id<RightSwitchCellDelegate> delegate;
@property (nonatomic,assign) NSInteger cellId;
@property (nonatomic, strong) UIImageView *switchButtonChangeImage;
@property (nonatomic, assign) BOOL isClick;


-(id)initWith:(BOOL)isclick;
@end
