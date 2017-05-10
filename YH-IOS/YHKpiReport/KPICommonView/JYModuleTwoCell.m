//
//  JYModuleTwoCell.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoCell.h"

@interface JYModuleTwoCell () <JYModuleTwoBaseViewDelegate>

@end

@implementation JYModuleTwoCell


- (void)setViewModel:(JYModuleTwoBaseModel *)viewModel {
    if (![_viewModel isEqual:viewModel]) {
        _viewModel = viewModel;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        switch (self.viewModel.chartType) {
            case JYDetailChartTypeBanner:
                
                break;
            case JYDetailChartTypeLine:
                [self addSubview:self.clickableLineView];
                break;
            case JYDetailChartTypeTablesV3:
                [self addSubview:self.excelView];
                break;
            case JYDetailChartTypeInfo:
                
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

- (JYCompareSaleView *)compareSaleView {
    if (!_compareSaleView) {
        _compareSaleView = [[JYCompareSaleView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth - JYDefaultMargin * 2, JYViewHeight)];
        _compareSaleView.moduleModel = self.viewModel;
        _compareSaleView.delegate = self;
    }
    return _compareSaleView;
}

- (JYClickableLineView *)clickableLineView {
    if (!_clickableLineView) {
        _clickableLineView = [[JYClickableLineView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth - JYDefaultMargin * 2, JYViewHeight)];
        _clickableLineView.moduleModel = self.viewModel;
        _clickableLineView.delegate = self;
    }
    return _clickableLineView;
}

- (JYExcelView *)excelView {
    if (!_excelView) {
        _excelView = [[JYExcelView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth - JYDefaultMargin * 2, JYViewHeight)];
        _excelView.moduleModel = self.viewModel;
        _excelView.delegate = self;
    }
    return _excelView;
}

- (JYLandscapeBarView *)landscapeBarView {
    if (!_landscapeBarView) {
        _landscapeBarView = [[JYLandscapeBarView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth - JYDefaultMargin * 2, JYViewHeight)];
        _landscapeBarView.moduleModel = self.viewModel;
        _landscapeBarView.delegate = self;
    }
    return _landscapeBarView;
}

- (JYPortraitBarView *)portraitBarView {
    if (!_portraitBarView) {
        _portraitBarView = [[JYPortraitBarView alloc] initWithFrame:CGRectMake(JYDefaultMargin, 0, JYViewWidth - JYDefaultMargin * 2, JYViewHeight)];
        _portraitBarView.moduleModel = self.viewModel;
        _portraitBarView.delegate = self;
    }
    return _portraitBarView;
}



- (CGFloat)cellHeightWithModel:(JYModuleTwoBaseModel *)model {
    
    CGFloat height = 0.0;
    switch (model.chartType) {
        case JYDetailChartTypeBanner:
            height = 40;
            break;
        case JYDetailChartTypeLine:
            height = [self.clickableLineView estimateViewHeight:model];
            break;
        case JYDetailChartTypeTablesV3:
            height = [self.excelView estimateViewHeight:model];
            break;
        case JYDetailChartTypeInfo:
            
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
