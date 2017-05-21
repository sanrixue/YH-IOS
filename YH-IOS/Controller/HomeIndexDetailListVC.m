//
//  HomeIndexDetailListVC.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexDetailListVC.h"
#import "TableViewAndCollectionPackage.h"
#import "HomeIndexDetailListCell.h"

@interface HomeIndexDetailListVC ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *topNameTipBtn;
@property (weak, nonatomic) IBOutlet UIButton *topDescripeBtn;
@property (weak, nonatomic) IBOutlet UIButton *topDescripeTipBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  TableViewAndCollectionPackage* package;
@property (nonatomic, strong) HomeIndexModel* data;
@property (nonatomic, strong) NSArray* dataList;
@property (nonatomic, assign) double maxValue;
@end

@implementation HomeIndexDetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _sortType = HomeIndexDetailListVCSortTypeDefault;
    self.tableView.backgroundColor = [AppColor app_8color];
    [self initPackage];
    [self.topDescripeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HomeIndexDetailListVCSortDown:model:vc:)]) {
            self.sortType = self.sortType==HomeIndexDetailListVCSortTypeDown?HomeIndexDetailListVCSortTypeUp:HomeIndexDetailListVCSortTypeDown;
            [self.delegate HomeIndexDetailListVCSortDown:YES model:_data vc:self];
        }
    }];
    if (![_data.head isEqualToString:@""]) {
         [self.topNamebtn setTitle:_data.head forState:UIControlStateNormal];
    //    [self.topNameTipBtn setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
        [self.topDescripeTipBtn  setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
    }
}
-(void)initPackage{
    __WEAKSELF;
    self.package = [TableViewAndCollectionPackage instanceWithScrollView:self.tableView delegate:nil cellBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        HomeIndexDetailListCell *cell = [HomeIndexDetailListCell cellWithTableView:weakSelf.tableView needXib:YES];
        HomeIndexItemModel *item = weakSelf.dataList[indexPath.row];
        cell.maxData = weakSelf.maxValue;
        [cell setItem:item];
        cell.nameBtn.userInteractionEnabled = NO;
        cell.valueBtn.userInteractionEnabled = NO;

//        cell.btnClickBack = ^(id item){
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(HomeIndexDetailListVCSelectIndex:model:vc:)]) {
//                NSInteger index =  [weakSelf.data.products indexOfObject:weakSelf.dataList[indexPath.row]];
//                [weakSelf.delegate HomeIndexDetailListVCSelectIndex:index model:weakSelf.data vc:weakSelf];
//            }
//        };
        config.cell = cell;
        
    } sectionNumBack:^(PackageConfig *config) {
        config.sectionNum = 1;
        config.cellNum = weakSelf.dataList.count;
        config.estimateHeight = 25;
        config.headerHeight = 10;
        config.rowHeight = 25;
    } cellSizeBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        
    } cellNumBack:^(NSInteger section, PackageConfig *config) {
        
    } selectedBack:^(NSIndexPath *indexPath) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(HomeIndexDetailListVCSelectIndex:model:vc:)]) {
            NSInteger index =  [weakSelf.data.products indexOfObject:weakSelf.dataList[indexPath.row]];
            [weakSelf.delegate HomeIndexDetailListVCSelectIndex:index model:weakSelf.data vc:weakSelf];
        }
    }];
}

- (void)setWithHomeIndexModel:(HomeIndexModel *)model{
    _data = model;
    HomeIndexItemModel* maxItem = [[NSArray sortArray:self.data.products key:@"selctItem.main_data.data" down:YES] firstObject];
    DLog(@"max data== %f",maxItem.selctItem.main_data.data);
    self.maxValue = maxItem.selctItem.main_data.data;
    if (model.products) {
        [self.topDescripeBtn setTitle:model.products[0].selctItem.name forState:UIControlStateNormal];
    }
    if (self.sortType==HomeIndexDetailListVCSortTypeDown) {
       // [self.topNameTipBtn setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
        [self.topDescripeTipBtn  setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
        _dataList = [NSArray sortArray:_data.products key:@"selctItem.main_data.data" down:YES];
    }
    if (self.sortType==HomeIndexDetailListVCSortTypeUp) {
       // [self.topNameTipBtn setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
        [self.topDescripeTipBtn  setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
        _dataList = [NSArray sortArray:_data.products key:@"selctItem.main_data.data" down:NO];
    }
    if (self.sortType==HomeIndexDetailListVCSortTypeDefault) {
        _dataList = _data.products;
       // [self.topNameTipBtn setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
        [self.topDescripeTipBtn  setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
    }
    [self.package reloadData];
}

@end
