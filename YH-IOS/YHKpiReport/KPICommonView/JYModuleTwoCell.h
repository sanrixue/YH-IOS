//
//  JYModuleTwoCell.h
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYModuleTwoBaseView.h"

/* 模块二元组件 */
#import "JYClickableLineView.h"
#import "JYCompareSaleView.h"
#import "JYExcelView.h"
#import "JYLandscapeBarView.h"
#import "JYPortraitBarView.h"


@class JYModuleTwoCell;
@protocol JYModuleTwoCellDelegate <NSObject>

- (void)moduleTwoCell:(JYModuleTwoCell *)moduleTwoCell didSelectedAtBaseView:(JYModuleTwoBaseView *)baseView Index:(NSInteger)idx data:(id)data;

@end

@interface JYModuleTwoCell : UITableViewCell



@property (nonatomic, strong) JYModuleTwoBaseModel *viewModel;

@property (nonatomic, strong) JYClickableLineView *clickableLineView;
@property (nonatomic, strong) JYCompareSaleView *compareSaleView;
@property (nonatomic, strong) JYExcelView *excelView;
@property (nonatomic, strong) JYLandscapeBarView *landscapeBarView;
@property (nonatomic, strong) JYPortraitBarView *portraitBarView;

@property (nonatomic, weak) id<JYModuleTwoCellDelegate>delegate;

- (CGFloat)cellHeightWithModel:(JYModuleTwoBaseModel *)model;


@end
