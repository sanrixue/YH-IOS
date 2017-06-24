//
//  JYWaterCollectionViewLayout.h
//  JYUICollectionView
//
//  Created by FM-13 on 16/6/23.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JYWaterLayout;
@protocol JYWaterLayoutDelegate <NSObject>

//代理取cell 的高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYWaterLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

- (void)layoutComputeFinish:(CGFloat)maxHeight;

// 获取行宽
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYWaterLayout *)layout withSection:(NSInteger )section;


- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

@end 

@interface JYWaterLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) NSInteger numberOfColumns;//瀑布流有列
@property (assign, nonatomic) CGFloat cellDistance;//cell之间的间距
@property (assign, nonatomic) CGFloat topAndBottomDustance;//cell 到顶部 底部的间距
@property (assign, nonatomic) CGFloat headerViewHeight;//头视图的高度
@property (assign, nonatomic) CGFloat footViewHeight;//尾视图的高度

@property(nonatomic, weak) id<JYWaterLayoutDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end
