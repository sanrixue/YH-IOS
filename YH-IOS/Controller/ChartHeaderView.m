//
//  ChartHeaderView.m
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "ChartHeaderView.h"
#import "ChartHeaderViewCell.h"

@implementation ChartHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.collection.delegate = self;
    self.collection.dataSource = self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChartHeaderViewCell* cell = [ChartHeaderViewCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120, 80);
}

@end
