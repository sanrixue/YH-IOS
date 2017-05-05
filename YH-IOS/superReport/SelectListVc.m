//
//  SelectListVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "SelectListVc.h"
#import "CommonTableViewCell.h"
#import "SelectListCell.h"

@interface SelectListVc ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) TableDataBaseModel* tableData;
@end

@implementation SelectListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLab.text = @"选列";
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (IBAction)cancleAction:(id)sender {
    //恢复关键列
    NSInteger keyIndex = [_tableData.head indexOfObject:_tableData.keyHead];
    [NSArray setValue:@(YES) keyPath:@"isKey" deafaultValue:@(NO) index:keyIndex inArray:_tableData.head];
    //恢复选中列
    [NSArray setValue:@(NO) keyPath:@"select" deafaultValue:@(NO) index:0 inArray:_tableData.head];
    for (NSNumber* number in _tableData.selectSet) {
        _tableData.head[number.integerValue].select = YES;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)confirmAction:(id)sender {
    _tableData.keyHead = [NSArray getObjectInArray:_tableData.head keyPath:@"isKey" equalValue:@(YES)];
    [_tableData.selectSet removeAllObjects];
    [_tableData.selectRowSet removeAllObjects];
    for (TableDataBaseItemModel* item in _dataList) {
        if (item.select) {
            NSInteger index = [_tableData.head indexOfObject:item];
            [_tableData.selectSet addObject:@(index)];
        }
    }
    if (self.usedBack) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.usedBack(self);
    }
}

- (void)sortArray:(NSArray*)item{
    _dataList = [NSMutableArray arrayWithArray:item];
    id keyObjc = [NSArray getObjectInArray:_dataList keyPath:@"isKey" equalValue:@(YES)];
    if (keyObjc) {
        [_dataList removeObject:keyObjc];
        [_dataList insertObject:keyObjc atIndex:0];
    }
    [_tableView reloadData];
}

- (void)setWithTableData:(TableDataBaseModel*)tableData{
    _tableData = tableData;
   // _dataList = tableData.
    //_dataList = [NSMutableArray arrayWithArray:tableData.head];
    [self sortArray:tableData.head];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectListCell* cell = [SelectListCell cellWithTableView:tableView needXib:YES];
    TableDataItemModel* model = _dataList[indexPath.row];
    [cell setItem:model];
    cell.keyBack = ^(id item){
        model.select = YES;
        [NSArray setValue:@(YES) keyPath:@"isKey" deafaultValue:@(NO) index:indexPath.row inArray:_dataList];
        [self sortArray:_dataList];
    };
    cell.selectBack = ^(id item){
        model.select = !model.select;
        [tableView reloadData];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BOOL allSelected = [NSArray isAllObjcEqualValue:@(YES) array:_dataList keyPath:@"select"];
    SelectListCell* cell = [SelectListCell cellWithTableView:tableView needXib:YES];
    [cell.titleBtn setTitle:@"全选" forState:UIControlStateNormal];
    cell.keyBtn.hidden= YES;
    cell.desLab.hidden = YES;
   cell.titleBtn.selected = allSelected;
    cell.selectBack = ^(id item){
        if (_dataList.count) {
            [NSArray setValue:@(!allSelected) keyPath:@"select" deafaultValue:@(!allSelected) index:0 inArray:_dataList];
            [tableView reloadData];
        }
    };
    cell.frame = CGRectMake(0, 0, self.view.width, 50);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return _dataList;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    _dataList = [NSMutableArray arrayWithArray:newArray];
    [self sortArray:_dataList];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
