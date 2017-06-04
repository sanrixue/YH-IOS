//
//  UICollectionViewCell+Category.m
//  Haitao
//
//  Created by cjg on 16/10/27.
//  Copyright © 2016年 YongHui. All rights reserved.
//

#import "UICollectionViewCell+Category.h"

@implementation UICollectionViewCell (Category)
+ (CGSize)sizeForItem:(id)item {
    return CGSizeZero;
}

+ (CGSize)sizeForIndex:(NSIndexPath *)index {
    return CGSizeZero;
}

+ (CGSize)sizeForSelf{
    return CGSizeZero;
}

- (void)setItem:(id)item {
    
}

+ (instancetype)cellWithCollctionView:(UICollectionView *)collectionView Identifier:(NSString *)ID IndexPath:(NSIndexPath *)indexPath{
    if (!ID) {
        ID = NSStringFromClass(self);
    }
    [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    return [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
}

+ (instancetype)cellWithCollctionView:(UICollectionView *)collectionView needXib:(BOOL)need IndexPath:(NSIndexPath *)indexPath{
    if (need) {
        return [self cellWithCollctionView:collectionView Identifier:nil IndexPath:indexPath];
    }else{
        [collectionView registerClass:self forCellWithReuseIdentifier:NSStringFromClass(self)];
        return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self) forIndexPath:indexPath];
    }
}

@end
