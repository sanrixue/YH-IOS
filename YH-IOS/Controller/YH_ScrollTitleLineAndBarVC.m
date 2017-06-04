//
//  YH_ScrollTitleLineAndBarVC.m
//  SwiftCharts
//
//  Created by CJG on 17/4/10.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YH_ScrollTitleLineAndBarVC.h"
#import "ChartHeaderViewCell.h"
#import "YH_LineAndBarVc.h"
#import "ChartModel.h"

@interface YH_ScrollTitleLineAndBarVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) YH_LineAndBarVc* lineAndBarVc;
@property (nonatomic, strong) NSMutableArray* dataList;
@property (nonatomic, strong) HomeIndexModel* curModel;
@property (nonatomic, strong) NSArray* allData;
@property (nonatomic, strong) HomeIndexItemModel* topItem;
@end

@implementation YH_ScrollTitleLineAndBarVC

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection reloadData];
    [self setUI];
}

- (void)setWithData:(NSArray*)dataList curModel:(HomeIndexModel*)model animation:(BOOL)animation{
    NSInteger index1 = -1; // 一级下标
    NSInteger index2 = -1; // 二级下标
    _allData = dataList;
    _curModel = model;
    for (int i = 0;i<model.products.count;i++) {
        HomeIndexItemModel* item = model.products[i];
        if (item.select) {
            index1 = i;
            index2 = [item.items indexOfObject:item.selctItem];
            _topItem = item.selctItem;
        }
    }
    DLog(@"一级下标 %zd, 二级下标%zd",index1,index2);
    if (index1>=0) {
        NSMutableArray* lineData = [NSMutableArray array];
        NSMutableArray* BarData = [NSMutableArray array];
        [self.dataList removeAllObjects];
        int count = 0;
        for (HomeIndexModel* indexModel in dataList) {
            double i = (double)[dataList indexOfObject:indexModel];
            HomeIndexItemModel* model = indexModel.products[index1].items[index2];
            [self.dataList addObject:model];
            ChartModel* lineModel;
            ChartModel* BarModel;
            if (count == 0 || count == (dataList.count - 1)) {
                lineModel = [[ChartModel alloc] initWithX:i y:model.sub_data.data xString:indexModel.period];
                BarModel = [[ChartModel alloc] initWithX:i y:model.main_data.data xString:indexModel.period];
            }
            else {
                lineModel = [[ChartModel alloc] initWithX:i y:model.sub_data.data xString:nil];
                BarModel = [[ChartModel alloc] initWithX:i y:model.main_data.data xString:nil];
            }
            count ++;
            BarModel.selectColor = _topItem.state.color.toColor;//[UIColor colorWithHexString:model.state.color];
            [lineData addObject:lineModel];
            [BarData addObject:BarModel];
        }
        
        [self.lineAndBarVc setWithLineData:lineData barData:BarData animation:animation];
        [self.collection reloadData];
    }
}

- (void)setUI{
    [self.view addSubview:self.lineAndBarVc.view];
    [self.lineAndBarVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.collection.mas_bottom).offset(1);
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChartHeaderViewCell* cell = [ChartHeaderViewCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell setItem:_topItem];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _topItem?3:0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [ChartHeaderViewCell sizeItem:_topItem indexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
};

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (YH_LineAndBarVc *)lineAndBarVc{
    if (!_lineAndBarVc) {
        _lineAndBarVc = [[YH_LineAndBarVc alloc] init];
        __WEAKSELF;
        _lineAndBarVc.selectBack = ^(NSNumber* index){
            if (weakSelf.selectBack) {
                weakSelf.selectBack(index);
            }
        };
        [self addChildViewController:_lineAndBarVc];
    }
    return _lineAndBarVc;
}

@end
