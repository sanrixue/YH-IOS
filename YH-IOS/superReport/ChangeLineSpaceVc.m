//
//  ChangeLineSpaceVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/20.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "ChangeLineSpaceVc.h"
#import "CommonTableViewCell.h"

@interface ChangeLineSpaceVc ()

@end

@implementation ChangeLineSpaceVc

- (instancetype)init{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nil];
    return self; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"行距";
    self.tableView.isDrag = NO;
}

- (void)setCurLineNum:(NSInteger)curLineNum{
    _curLineNum = curLineNum;
    [self.dataList removeAllObjects];
    NSArray* arr = @[@"一行",@"两行",@"三行"];
    for (NSInteger i=1; i<=3;i++) {
        TableDataItemModel* line = [[TableDataItemModel alloc] init];
        line.name = arr[i-1];
        line.select = i==curLineNum;
        [self.dataList addObject:line];
    }
    [self.tableView reloadData];
}

- (void)confirmAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.usedBack) {
        self.usedBack(self);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTableViewCell* cell = [CommonTableViewCell cellWithTableView:tableView needXib:NO];
    TableDataItemModel* line = self.dataList[indexPath.row];
    cell.rightLab.hidden = YES;
    cell.rightImageV.hidden = YES;
    cell.leftLab.text = line.name;
    cell.leftLab.textColor = line.select? [AppColor app_1color]:UIColorHex(383838);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setCurLineNum:indexPath.row+1];
}



@end
