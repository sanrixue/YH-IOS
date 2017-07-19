//
//  JYModuleTwoCell.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoCell.h"

/* 模块二元组件 */
#import "JYClickableLineView.h"
#import "JYCompareSaleView.h"
#import "JYExcelView.h"
#import "JYLandscapeBarView.h"
#import "JYPortraitBarView.h"
#import "JYBannerView.h"
#import "JYInfoView.h"

#define ToLeftMargin (JYDefaultMargin * 2)

@interface JYModuleTwoCell () <JYModuleTwoBaseViewDelegate>

@property (nonatomic, strong) JYBannerView *bannerView; // 标题
@property (nonatomic, strong) JYClickableLineView *clickableLineView; // 双线
@property (nonatomic, strong) JYCompareSaleView *compareSaleView; // 单值
@property (nonatomic, strong) JYExcelView *excelView;
@property (nonatomic, strong) JYLandscapeBarView *landscapeBarView; // 条状横向
@property (nonatomic, strong) JYPortraitBarView *portraitBarView; // 柱状纵向
@property (nonatomic, strong) JYInfoView *infoView;

@end

@implementation JYModuleTwoCell


- (void)setViewModel:(JYModuleTwoBaseModel *)viewModel {
    if (![_viewModel isEqual:viewModel]) {
        _viewModel = viewModel;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        switch (self.viewModel.chartType) {
            case JYDetailChartTypeBanner:
                [self addSubview:self.bannerView];
                break;
            case JYDetailChartTypeLine:
                [self addSubview:self.clickableLineView];
                break;
            case JYDetailChartTypeTables:
                [self addSubview:self.excelView];
                break;
            case JYDetailChartTypeInfo:
                [self addSubview:self.infoView];
                break;
            case JYDetailChartTypeSingleValue:
                [self addSubview:self.compareSaleView];
                break;
            case JYDetailChartTypeBargraph:
                [self addSubview:self.landscapeBarView];
                break;
            case JYDetailChartTypeCartHistogram:
                [self addSubview:self.portraitBarView];
                break;
                
            default:
                break;
        }
    }
}

- (JYInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[JYInfoView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - ToLeftMargin * 2, JYViewHeight)];
        _infoView.moduleModel = self.viewModel;
    }
    return _infoView;
}

- (JYBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[JYBannerView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - ToLeftMargin * 2, JYViewHeight)];
        _bannerView.moduleModel = self.viewModel;
        
    }
    return _bannerView;
}

- (JYCompareSaleView *)compareSaleView {
    if (!_compareSaleView) {
        _compareSaleView = [[JYCompareSaleView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - ToLeftMargin * 2, JYViewHeight)];
        _compareSaleView.moduleModel = self.viewModel;
        _compareSaleView.delegate = self;
    }
    return _compareSaleView;
}

- (JYClickableLineView *)clickableLineView {
    if (!_clickableLineView) {
        _clickableLineView = [[JYClickableLineView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - ToLeftMargin * 2, JYViewHeight)];
        _clickableLineView.moduleModel = self.viewModel;
        _clickableLineView.delegate = self;
    }
    return _clickableLineView;
}

- (JYExcelView *)excelView {
    if (!_excelView) {
        _excelView = [[JYExcelView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - 2 * ToLeftMargin, JYViewHeight)];
        _excelView.moduleModel = self.viewModel;
        _excelView.delegate = self;
    }
    return _excelView;
}

- (JYLandscapeBarView *)landscapeBarView {
    if (!_landscapeBarView) {
        _landscapeBarView = [[JYLandscapeBarView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - ToLeftMargin * 2, JYViewHeight)];
        _landscapeBarView.moduleModel = self.viewModel;
        _landscapeBarView.delegate = self;
    }
    return _landscapeBarView;
}

- (JYPortraitBarView *)portraitBarView {
    if (!_portraitBarView) {
        _portraitBarView = [[JYPortraitBarView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, JYViewWidth - ToLeftMargin * 2, JYViewHeight)];
        _portraitBarView.moduleModel = self.viewModel;
        _portraitBarView.delegate = self;
    }
    return _portraitBarView;
}



- (CGFloat)cellHeightWithModel:(JYModuleTwoBaseModel *)model {
    
    CGFloat height = 0.0;
    switch (model.chartType) {
        case JYDetailChartTypeBanner:
            height = [self.bannerView estimateViewHeight:model];
            break;
        case JYDetailChartTypeLine:
            height = [self.clickableLineView estimateViewHeight:model];
            break;
        case JYDetailChartTypeTables:
            height = [self.excelView estimateViewHeight:model];
            break;
        case JYDetailChartTypeInfo:
            height = [self.infoView estimateViewHeight:model];
            break;
        case JYDetailChartTypeSingleValue:
            height = [self.compareSaleView estimateViewHeight:model];
            break;
        case JYDetailChartTypeBargraph:
            height = [self.landscapeBarView estimateViewHeight:model];
            break;
        case JYDetailChartTypeCartHistogram:
            height = [self.portraitBarView estimateViewHeight:model];
            break;
            
        default:
            break;
    }
    return height;
}

- (void)moduleTwoBaseView:(JYModuleTwoBaseView *)moduleTwoBaseView didSelectedAtIndex:(NSInteger)idx data:(id)data {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoCell:didSelectedAtBaseView:Index:data:)]) {
        [self.delegate moduleTwoCell:self didSelectedAtBaseView:moduleTwoBaseView Index:idx data:data];
    }
}

@end
