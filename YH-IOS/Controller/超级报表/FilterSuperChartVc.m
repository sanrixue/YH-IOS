//
//  FilterSuperChartVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/24.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "FilterSuperChartVc.h"
#import "SelectListCell.h"
#import "FilterSuperChartHeaderCell.h"

@interface FilterSuperChartVc ()

@end

@implementation FilterSuperChartVc

- (instancetype)init{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nil];
    return self;
}

-   (void)setSuperModel:(SuperChartModel *)superModel{
    _superModel = superModel;
    self.dataList = [NSMutableArray arrayWithArray:superModel.config.filter];
    [self.tableView reloadData];
}

- (void)confirmAction:(id)sender{
    for (TableDataModel* data in self.dataList) {
        if (data.select) {
            [_superModel.table.dataSet removeAllObjects];
            for (TableDataItemModel* filter in data.items) {
                if (filter.select) {
                    for (TableDataItemModel* dataItem in self.superModel.table.main_data) {
                        if ([dataItem.district isEqualToString:filter.value]) {
                            NSInteger index = [self.superModel.table.main_data indexOfObject:dataItem];
                            [_superModel.table.dataSet addObject:@(index)];
                        }
                    }
                }
            }
        }else{
            [_superModel.table.dataSet removeAllObjects];
            for (TableDataItemModel* dataItem in self.superModel.table.main_data) {
                NSInteger index = [self.superModel.table.main_data indexOfObject:dataItem];
                [_superModel.table.dataSet addObject:@(index)];
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.usedBack) {
        self.usedBack(self);
    }
}

- (void)cancleAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.isDrag = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TableDataModel* model = self.dataList[section];
    return model.select? model.items.count+1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectListCell* cell = [SelectListCell cellWithTableView:tableView needXib:YES];
    TableDataModel* data = self.dataList[indexPath.section];
    BOOL allSelected = [NSArray isAllObjcEqualValue:@(YES) array:data.items keyPath:@"select"];
    if (indexPath.row==0) {
        cell.titleBtn.selected = allSelected;
        [cell.titleBtn setTitle:@"全选" forState:UIControlStateNormal];
    }else{
        TableDataItemModel* item  = data.items[indexPath.row-1];
        [cell setItem:item];
    }
    cell.keyBtn.hidden = YES;
    cell.desLab.hidden = YES;
    cell.titleBtn.userInteractionEnabled = NO;
    cell.contentView.backgroundColor = [AppColor app_8color];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableDataModel* data = self.dataList[indexPath.section];
    if (indexPath.row==0) {
        BOOL allSelected = [NSArray isAllObjcEqualValue:@(YES) array:data.items keyPath:@"select"];
        [NSArray setValue:@(!allSelected) keyPath:@"select" deafaultValue:@(!allSelected) index:0 inArray:data.items];
    }else{
        TableDataItemModel* item  = data.items[indexPath.row-1];
        item.select = !item.select;
    }
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FilterSuperChartHeaderCell* header = [FilterSuperChartHeaderCell cellWithTableView:tableView needXib:YES];
    header.backgroundColor = [UIColor whiteColor];
    TableDataModel* data = self.dataList[section];
    header.titleLab.text = data.filter_name;
    header.swichBtn.selected = data.select;
    header.swichBack = ^(id view){
        data.select = !data.select;
        [tableView reloadData];
    };
    return header;
}







@end
