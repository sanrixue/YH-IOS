//
//  DoubleClickSuperChartVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "DoubleClickSuperChartVc.h"
#import "TableViewAndCollectionPackage.h"
#import "DoubleClickSuperChartCell.h"
#import "DoubleClickSuperChartHeaderCell.h"

@interface DoubleClickSuperChartVc ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  TableViewAndCollectionPackage* package;
@property (nonatomic, strong) NSArray* dataList;
@property (nonatomic, assign) NSInteger column;
//@property (nonatomic, strong) NSArray* heads;
@property (nonatomic, strong) TableDataItemModel* maxItem;
@property (nonatomic, strong) SuperChartModel* superModel;
@property (nonatomic, strong) UIButton* clearBackBtn;
@end

@implementation DoubleClickSuperChartVc


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPackage];
}

- (void)setWithSuperModel:(SuperChartModel*)superModel column:(NSInteger)column{
//    _heads = heades;
    _superModel = superModel;
    _dataList = [superModel.table showData];
    _column = column;
    NSMutableArray* array = [NSMutableArray array];
    for (TableDataItemModel* table in _dataList) {
        [array addObject:table.showData[column]];
    }
    array = [NSArray sortArray:array key:@"value" down:YES];
    if (array.count) {
        self.maxItem = array[0];
    }
    [self.tableView reloadData];
}

-(void)initPackage{
    __WEAKSELF;
    self.package = [TableViewAndCollectionPackage instanceWithScrollView:self.tableView delegate:nil cellBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        
        DoubleClickSuperChartCell* cell = [DoubleClickSuperChartCell cellWithTableView:weakSelf.tableView needXib:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TableDataItemModel* table = weakSelf.dataList[indexPath.row];
        TableDataItemModel* item = table.showData[weakSelf.column];
        CGFloat scale = 0.0;
        if (weakSelf.maxItem) {
            scale = item.value.doubleValue/weakSelf.maxItem.value.doubleValue;
            scale = scale<0? 0:scale;
        }
        [cell.titleBtn setTitle:table.name forState:UIControlStateNormal];
        cell.valueLab.text = item.value;
        cell.barView.scale = scale;
        NSString* color = weakSelf.superModel.config.color[table.color[weakSelf.column].integerValue];
        cell.barView.barColor = color.toColor;//[UIColor redColor];
        
        cell.doubleBack = ^(id item){
            [weakSelf popNeedAnimation:YES];
        };
        config.cell = cell;
        
    } sectionNumBack:^(PackageConfig *config) {
        config.sectionNum = 1;
        config.estimateHeight = 50;
        config.rowHeight = 55;
        config.cellNum = weakSelf.dataList.count;
    } cellSizeBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        
    } cellNumBack:^(NSInteger section, PackageConfig *config) {
        
    } selectedBack:^(NSIndexPath *indexPath) {
        
    }];
    [self.package addHeaderBack:^(NSInteger section, PackageConfig *config) {
        
        DoubleClickSuperChartHeaderCell* header = [DoubleClickSuperChartHeaderCell cellWithTableView:weakSelf.tableView needXib:YES];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        [header.titleBtn setTitle:weakSelf.superModel.name forState:UIControlStateNormal];
        [header.rightBtn setTitle:weakSelf.superModel.table.showhead[weakSelf.column].value forState:UIControlStateNormal];
        header.sortBack = weakSelf.sortBack;
        [header.rightBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
        config.header = header;
        
    } headerSizeBack:^(NSInteger section, PackageConfig *config) {
        config.headerHeight = 45;
    } orFooterBack:nil footerSizeBack:nil];
}

@end
