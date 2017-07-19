//
//  JYBannerView.m
//  各种报表
//
//  Created by niko on 17/5/10.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBannerView.h"
#import "JYBannerModel.h"
#import "JYHelpInfoView.h"

@interface JYBannerView () {
    UILabel *titleLB;
    UILabel *dateLB;
}

@end

@implementation JYBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    return self;
}

- (void)initializeSubVeiw {
    
    titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, JYViewHeight)];
    titleLB.text = @"销售额VS目标";
    [self addSubview:titleLB];
    
    dateLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLB.frame) + JYDefaultMargin, 0, 100, JYViewHeight)];
    dateLB.text = @"2017/05/10";
    [self addSubview:dateLB];
    
    UIButton *showInfoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    showInfoBtn.frame = CGRectMake(JYViewWidth - JYDefaultMargin - 20, (JYViewHeight - 20)/2, 20, 20);
    [showInfoBtn addTarget:self action:@selector(showHelpInfo:) forControlEvents:UIControlEventTouchUpInside];
    showInfoBtn .tintColor = [UIColor lightGrayColor];
    [self addSubview:showInfoBtn];
}

- (void)refreshSubViewData {
    
    titleLB.text = ((JYBannerModel *)self.moduleModel).title;
    dateLB.text = ((JYBannerModel *)self.moduleModel).date;
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    return 44;
}

- (void)showHelpInfo:(UIButton *)sender {
    NSLog(@"%@", ((JYBannerModel *)self.moduleModel).info);
    JYHelpInfoView *helpInfoView = [[JYHelpInfoView alloc] initWithFrame:CGRectMake(0, 0, JYScreenWidth, JYScreenHeight)];
    helpInfoView.helpInfo = ((JYBannerModel *)self.moduleModel).info;
    [helpInfoView show];
}

@end
