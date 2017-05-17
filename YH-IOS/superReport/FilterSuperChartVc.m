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
@property(nonatomic,strong)NSMutableArray* filterArray;

@end

@implementation FilterSuperChartVc

- (instancetype)init{
    self.filterArray = [[NSMutableArray alloc]init];
    self.title = @"筛选";
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nil];
    return self;
}

-  (void)setSuperModel:(SuperChartMainModel *)superModel{
    _superModel = superModel;
    self.dataList = [NSMutableArray arrayWithArray:superModel.config.filter];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_filterArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)confirmAction:(id)sender{
   /* for (TableDataBaseModel* data in self.dataList) {
         [_superModel.table.dataSet removeAllObjects];
      / if (data.select) {
            for (TableDataBaseItemModel* filter in data.items) {
                if (filter.select) {
                    for (int i = 0;i<self.superModel.table.main_data.count;i++) {
                        NSMutableArray* demolArray = [NSMutableArray arrayWithArray:self.superModel.table.main_data[i]];
                        NSDictionary* dataItem = demolArray[0];
                        if (filter.index == dataItem[@"index"]) {
                             [_superModel.table.dataSet addObject:@(i)];
                        }
                    }
       
                    for (TableDataBaseItemModel* dataItem in self.superModel.table.main_data) {
                        if ([dataItem.index isEqualToString:filter.index]) {
                            NSInteger index = [self.superModel.table.main_data indexOfObject:dataItem];
                            [_superModel.table.dataSet addObject:@(index)];
                        }
                    }
                }
            }
        }else{
            [_superModel.table.dataSet removeAllObjects];
            for (TableDataBaseItemModel* dataItem in self.superModel.table.main_data) {
                NSInteger index = [self.superModel.table.main_data indexOfObject:dataItem];
                [_superModel.table.dataSet addObject:@(index)];
            }
        }
        
    }*/
    if (_filterArray.count>0) {
         [_superModel.table.dataSet removeAllObjects];
        for (int j = 0; j< _filterArray.count; j++) {
            for (int i = 0;i<self.superModel.table.main_data.count;i++) {
                NSMutableArray* demolArray = [NSMutableArray arrayWithArray:self.superModel.table.main_data[i]];
               // NSInteger *rowNum = [self.superModel.table.showhead indexOfObject:self.superModel.]
                for (TableDataBaseModel *item in self.superModel.config.filter) {
                    int rowNum = 0;
                    for (int k = 0;k<self.superModel.table.head.count; k++) {
                        TableDataBaseItemModel *demol = self.superModel.table.head[k];
                        if ([demol.value isEqualToString:item.name]) {
                            rowNum = k;
                        }
                    }
                    NSDictionary* dataItem = demolArray[rowNum];
                    if (_filterArray[j] == dataItem[@"index"]) {
                        [_superModel.table.dataSet addObject:@(i)];
                    }
                }
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
   TableDataBaseModel* model = self.dataList[section];
    return model.items.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectListCell* cell = [SelectListCell cellWithTableView:tableView needXib:YES];
    TableDataBaseModel* data = self.dataList[indexPath.section];
    BOOL allSelected = [NSArray isAllObjcEqualValue:@(YES) array:data.items keyPath:@"select"];
    if (indexPath.row==0) {
        cell.titleBtn.selected = allSelected;
        [cell.titleBtn setTitle:@"全选" forState:UIControlStateNormal];
    }else{
        TableDataBaseItemModel* item  = data.items[indexPath.row-1];
        [cell setItem:item];
        if (item.select && [_filterArray indexOfObject:item.index] == NSNotFound) {
             [_filterArray addObject:item.index];
        }
    }
    cell.keyBtn.hidden = YES;
    cell.desLab.hidden = YES;
    cell.titleBtn.userInteractionEnabled = NO;
    cell.contentView.backgroundColor = [AppColor app_8color];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableDataBaseModel* data = self.dataList[indexPath.section];
    if (indexPath.row==0) {
        BOOL allSelected = [NSArray isAllObjcEqualValue:@(YES) array:data.items keyPath:@"select"];
        [NSArray setValue:@(!allSelected) keyPath:@"select" deafaultValue:@(!allSelected) index:0 inArray:data.items];
    }
    else{
        TableDataBaseItemModel* item  = data.items[indexPath.row-1];
        item.select = !item.select;
    }
    // 在这边添加了预备选择的东西，应该是不对的
    data.select = YES;
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FilterSuperChartHeaderCell* header = [FilterSuperChartHeaderCell cellWithTableView:tableView needXib:YES];
    header.backgroundColor = [UIColor whiteColor];
    TableDataBaseModel* data = self.dataList[section];
    header.titleLab.text = data.filter_name;
    header.swichBtn.selected = data.select;
    header.swichBack = ^(id view){
        data.select = !data.select;
         [_filterArray removeAllObjects];
        [tableView reloadData];
    };
    return header;
}







@end
