//
//  JYModuleTwoView.m
//  各种报表
//
//  Created by niko on 17/5/21.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoView.h"
#import "JYCursor.h"

#import "JYModuleTwoModel.h"
#import "JYStatementView.h"

@interface JYModuleTwoView ()

@property (nonatomic, strong) JYCursor *cursor;
@property (nonatomic, strong) JYModuleTwoModel *moduleTwoModel;
@property (nonatomic, strong) NSMutableArray <JYStatementView *> *statementView;

@end

@implementation JYModuleTwoView

- (JYCursor *)cursor {
    if (!_cursor) {
        _cursor = [[JYCursor alloc]init];
        _cursor.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        _cursor.titles = self.moduleTwoModel.statementTitleList;
        _cursor.pageViews = self.statementView;
        //设置根滚动视图的高度
        _cursor.rootScrollViewHeight = self.frame.size.height - (40 + 64);
        //默认值是白色
        _cursor.titleNormalColor = [UIColor blackColor];
        //默认值是白色
        _cursor.titleSelectedColor = [UIColor blackColor];
        _cursor.backgroudSelectedColor = [UIColor colorWithHexString:@"#00a4e9"];
        //是否显示排序按钮
        //_cursor.showSortbutton = YES;
        //默认的最小值是5，小于默认值的话按默认值设置
        _cursor.minFontSize = 15;
        //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
        _cursor.maxFontSize = 15;
        _cursor.backgroundColor = [UIColor whiteColor];
    }
    return _cursor;
}

- (JYModuleTwoModel *)moduleTwoModel {
    if (!_moduleTwoModel) {
        _moduleTwoModel = (JYModuleTwoModel *)self.moduleModel;
    }
    return _moduleTwoModel;
}

- (NSMutableArray<JYStatementView *> *)statementView {
    if (!_statementView) {
        _statementView = [NSMutableArray array];
        for (JYStatementModel *model in self.moduleTwoModel.statementModelList) {
            JYStatementView *statementView = [[JYStatementView alloc] init];
            statementView.moduleModel = model;
            [_statementView addObject:statementView];
        }
    }
    return _statementView;
}

- (void)layoutSubviews {
    [self addSubview:self.cursor];
}

@end
