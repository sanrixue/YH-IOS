//
//  MineHeadView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "UserCountView.h"
#import "User.h"


@protocol MineHeadDelegate <NSObject>

-(void)ClickButton:(UIButton *)btn;

@end

@interface MineHeadView : UIView

@property (nonatomic, strong)Person *person;
@property (nonatomic, strong)UIButton *avaterImageView;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *lastLoginMessageLabel;
@property (nonatomic, strong)UserCountView *loginCountView;
@property (nonatomic, strong)UserCountView *reportScanCountView;
@property (nonatomic, strong)UserCountView *precentView;
@property (nonatomic, weak) id<MineHeadDelegate> delegate;


// 刷新视图

-(void)refreshViewWith:(NSDictionary *)person;
-(instancetype)initWithFrame:(CGRect)frame withPerson:(Person*)person;
-(void)addVaildData;
-(void)refeshAvaImgeView:(UIImage *)image;

@end
