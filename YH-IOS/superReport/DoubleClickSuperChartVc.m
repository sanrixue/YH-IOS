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
@property (nonatomic, strong) TableDataBaseItemModel* maxItem;
@property (nonatomic, strong) SuperChartMainModel* superModel;
@property (nonatomic, strong) UIButton* clearBackBtn;
@property (nonatomic, strong) NSMutableArray* array;
@property (nonatomic, strong) NSMutableArray* baseArray;

@end

@implementation DoubleClickSuperChartVc


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPackage];
}

- (void)setWithSuperModel:(SuperChartMainModel*)superModel column:(NSInteger)column{
//    _heads = heades;
    _superModel = superModel;
    _dataList = [superModel.table showData];
    _column = column;
    _array = [NSMutableArray array];
  //  NSMutableArray *demoArray = [NSMutableArray array];
    for (NSArray* array in _dataList) {
        TableDataBaseItemModel *item = array[column];
       // for (TableDataBaseItemModel* table in demoArray) {
            [_array addObject:item];
        //}
    }
    self.baseArray = [NSMutableArray arrayWithArray:_array];
   _array = [NSArray sortArray:_array key:@"value" down:YES];
  /*  [_superModel.table.dataSet removeAllObjects];
    for (TableDataBaseItemModel* item in _array) {
        int index = item.lineTag;
        [_superModel.table.dataSet addObject:@(index)];
    }*/
    if (_array.count) {
        self.maxItem = _array[0];
    }
   /* NSMutableArray *inModelArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 2; i++) {
        NSArray* modelArray = [_superModel.table showData][i];
        TableDataBaseItemModel* demo = modelArray[0];
        [inModelArray addObject:demo];
    }
    _keyArray = inModelArray;*/
    [self.tableView reloadData];
}


-(void)initPackage{
    __WEAKSELF;
    self.package = [TableViewAndCollectionPackage instanceWithScrollView:self.tableView delegate:nil cellBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        
        DoubleClickSuperChartCell* cell = [DoubleClickSuperChartCell cellWithTableView:weakSelf.tableView needXib:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TableDataBaseItemModel* table = weakSelf.array[indexPath.row];
    
      //  TableDataBaseItemModel* item = _baseArray[indexPath.row];
        TableDataBaseItemModel* item = _baseArray[indexPath.row];
        CGFloat scale = 0.0;
        if (weakSelf.maxItem && item.value.doubleValue) {
            scale = item.value.doubleValue/weakSelf.maxItem.value.doubleValue;
            scale = scale<0? 0:scale;
        }
        NSArray* modelArray = _dataList[indexPath.row];
        TableDataBaseItemModel* demo = modelArray[0];
        [cell.titleBtn setTitle:demo.value forState:UIControlStateNormal];
        cell.valueLab.text = item.value;
        cell.titleBtn.titleLabel.numberOfLines = 0;
        cell.barView.scale = scale;
       // NSString* color = item.color;
        NSString* color = weakSelf.superModel.config.color[table.color.integerValue];
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
        header.userInteractionEnabled=YES;
        [header.titleBtn setTitle:weakSelf.titleString forState:UIControlStateNormal];
       // [header.titleBtn setTitle:@"这个人" forState:UIControlStateNormal];
        [header.rightBtn setTitle:weakSelf.superModel.table.showhead[weakSelf.column].value forState:UIControlStateNormal];
        [header.rightBtn addTarget:weakSelf action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
      //  [header.rightBtn setTitle:weakSelf.keyArray[weakSelf.column].value forState:UIControlStateNormal];
        header.sortBack = weakSelf.sortBack;
        [header.rightBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
        config.header = header;
        if (!weakSelf.isSort) {
               [header.rightBtn setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
        }
        else{
            if (weakSelf.isdownImage) {
                [header.rightBtn setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
            }
            else if(!weakSelf.isdownImage){
                [header.rightBtn setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
            }
        }
    } headerSizeBack:^(NSInteger section, PackageConfig *config) {
        config.headerHeight = 45;
    } orFooterBack:nil footerSizeBack:nil];
}

-(void)changeImage:(UIButton*)sender{
    _isSort = YES;
    _isdownImage = !_isdownImage;
    if (_isdownImage) {
        [sender setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
    }
    else {
        [sender setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
    }
}

@end
