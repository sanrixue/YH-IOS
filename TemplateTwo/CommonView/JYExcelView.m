//
//  JYExcelView.m
//  各种报表
//
//  Created by niko on 17/5/19.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYExcelView.h"
#import "JYExcelModel.h"
#import "JYCursor.h"
#import "JYSheetView.h"

@interface JYExcelView () {
    CGFloat cursorScrollHeight;
}

@property (nonatomic, strong) JYCursor *cursor;
@property (nonatomic, strong) NSMutableArray <JYSheetView *> *sheetViewList;
@property (nonatomic, strong) NSArray <JYSheetModel *> *sheetModelList;
@property (nonatomic, strong) JYExcelModel *excelModel;

@end

@implementation JYExcelView


- (NSArray<JYSheetModel *> *)sheetModelList {
    if (!_sheetModelList) {
        _sheetModelList = ((JYExcelModel *)self.moduleModel).sheetList;
    }
    return _sheetModelList;
}

- (JYExcelModel *)excelModel {
    if (!_excelModel) {
        _excelModel = (JYExcelModel *)self.moduleModel;
    }
    return _excelModel;
}

- (JYCursor *)cursor {
    if (!_cursor) {
        
        cursorScrollHeight = 0;
        
        _cursor = [[JYCursor alloc]init];
        _cursor.frame = CGRectMake(-JYDefaultMargin * 2, 0, self.frame.size.width + JYDefaultMargin * 4, 45 + JYDefaultMargin);
        _cursor.titles = self.excelModel.sheetNames;
        _cursor.pageViews = self.sheetViewList;
        //设置根滚动视图的高度
        _cursor.rootScrollViewHeight = self.frame.size.height - (64);
        //默认值是白色
        _cursor.titleNormalColor = JYColor_TextColor_Chief;
        //默认值是白色
        _cursor.titleSelectedColor = JYColor_ThemeColor_LightGreen;
        //是否显示排序按钮
        //_cursor.showSortbutton = YES;
        //默认的最小值是5，小于默认值的话按默认值设置
        _cursor.minFontSize = _cursor.maxFontSize = 15;
        //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
        //cursor.maxFontSize = 30;
        //cursor.isGraduallyChangFont = NO;
        //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
        //cursor.isGraduallyChangColor = NO;
        [self addSubview:_cursor];
    }
    return _cursor;
}

- (NSMutableArray<JYSheetView *> *)sheetViewList {
    if (!_sheetViewList) {
        _sheetViewList = [NSMutableArray array];
        for (JYSheetModel *sheetModel in self.sheetModelList) {
            JYSheetView *sheetView = [[JYSheetView alloc] init];
            sheetView.moduleModel = sheetModel;
            [_sheetViewList addObject:sheetView];
        }
    }
    return _sheetViewList;
}

- (void)refreshSubViewData {
    [self addSubview:self.cursor];
    for (JYSheetModel *sheetModel in ((JYExcelModel *)self.excelModel).sheetList) {
        JYSheetView *tempSheetView = [[JYSheetView alloc] init];
        CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
        cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight);
    }
    //NSLog(@"cursorScrollHeight : %f", cursorScrollHeight);
    self.cursor.rootScrollViewHeight = cursorScrollHeight;
}

- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model {
    
    // 使用所有数据中的最高的高度
    if (cursorScrollHeight == 0) {
        for (JYSheetModel *sheetModel in ((JYExcelModel *)model).sheetList) {
            JYSheetView *tempSheetView = [[JYSheetView alloc] init];
            CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
            cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight) + 25;
        }
    }
    //NSLog(@"cursorScroll ---> Height : %f", cursorScrollHeight);
    return cursorScrollHeight;
}

@end
