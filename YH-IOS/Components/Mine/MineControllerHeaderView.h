//
//  MineControllerHeaderView.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineControllerHeaderView : UIView
@property (nonatomic, strong) UIButton* btn1;
@property (nonatomic, strong) UIButton* btn2;
@property (nonatomic, strong) UIButton* btn3;
@property (nonatomic, strong) UIView* lightView;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) CommonBack clickBack;
@property (nonatomic, strong) NSArray<UIButton*>* btns;

// 范围0-2
- (void)updateWithScale:(CGFloat)scale;

@end
