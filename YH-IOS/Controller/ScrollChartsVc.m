//
//  ScrollChartsVc.m
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "ScrollChartsVc.h"
#import "OneLableCell.h"
#import "YHLinechart1Vc.h"

@interface ScrollChartsVc () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ScrollChartsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售额";
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [AppColor oneColor];
    [self.collection reloadData];
    YHLinechart1Vc *line1 = [[YHLinechart1Vc alloc] init];
    [self.view addSubview: line1.view];
    self.view.backgroundColor = [AppColor grayBackgroudColor];
    [line1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.collection.mas_bottom).offset(10);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OneLableCell *cell = [OneLableCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    cell.contentBtn.userInteractionEnabled = NO;
    cell.contentBtn.selected = indexPath.row==_index?1:0;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _index = indexPath.row;
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [collectionView reloadData];
}

@end
