//
//  JYStatementView.m
//  各种报表
//
//  Created by niko on 17/5/20.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYStatementView.h"
#import "JYModuleTwoCell.h"
#import "JYExcelModel.h"

@interface JYStatementView () <UITableViewDelegate, UITableViewDataSource, JYModuleTwoCellDelegate> {
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JYModuleTwoCell *moduleTwoCell;
@property (nonatomic, strong) NSArray *viewModelList;


@end

@implementation JYStatementView

- (void)layoutSubviews {
    
    [self addSubview:self.tableView];
}

- (NSArray *)viewModelList {
    if (!_viewModelList) {
        _viewModelList = ((JYStatementModel *)self.moduleModel).viewModelList;
    }
    return _viewModelList;
}

- (JYModuleTwoCell *)moduleTwoCell {
    if (!_moduleTwoCell) {
        _moduleTwoCell = [[JYModuleTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYModuleTwoCell"];
    }
    return _moduleTwoCell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, JYViewWidth, JYViewHeight - 64) style:UITableViewStylePlain];
        [_tableView registerClass:[JYModuleTwoCell class] forCellReuseIdentifier:@"JYModuleTwoCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYModuleTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYModuleTwoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    JYModuleTwoBaseModel *model = self.viewModelList[indexPath.section];
    if (model.chartType == JYDetailChartTypeTables) {
        JYExcelModel *excelModel = (JYExcelModel *)model;
        cell.viewModel = excelModel;
    }
    else {
        cell.viewModel = self.viewModelList[indexPath.section];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    
    JYModuleTwoBaseModel *model = self.viewModelList[indexPath.section];
    if (model.chartType == JYDetailChartTypeTables) {
        JYExcelModel *excelModel = (JYExcelModel *)model;
        height = [self.moduleTwoCell cellHeightWithModel:excelModel];
    }
    else {
        height = [self.moduleTwoCell cellHeightWithModel:self.viewModelList[indexPath.section]];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JYDefaultMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUpOrDown" object:self userInfo:@{@"origin": @"{0,121}"}]; // 72 + 45 + 4
}

#pragma mark - <JYModuleTwoCellDelegate>
- (void)moduleTwoCell:(JYModuleTwoCell *)moduleTwoCell didSelectedAtBaseView:(JYModuleTwoBaseView *)baseView Index:(NSInteger)idx data:(id)data {
    //NSLog(@"self %@ = %p", [self class], self);
    //NSLog(@"view %@ data %@", baseView, data);
}



@end
