//
//  SelectListVc.h
//  SwiftCharts
//
//  Created by CJG on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "RTDragCellTableView.h"
#import "SuperChartModel.h"
#import "SuperChartMainModel.h"

@interface SelectListVc : YHBaseViewController <RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>
@property (weak, nonatomic) IBOutlet RTDragCellTableView *tableView;
@property (nonatomic, strong) NSMutableArray* dataList;
@property (nonatomic, strong) CommonBack usedBack; // 点击应用回调
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


- (IBAction)cancleAction:(id)sender;
- (IBAction)confirmAction:(id)sender;

- (void)setWithTableData:(TableDataBaseModel*)tableData;

@end
