//
//  UICollectionViewCell+Category.h
//  Haitao
//
//  Created by cjg on 16/10/27.
//  Copyright © 2016年 YongHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Category)
+ (CGSize)sizeForItem:(id)item;
+ (CGSize)sizeForIndex:(NSIndexPath *)index;
+ (CGSize)sizeForSelf;
/** 提供初始化方法，无需注册 */
+ (instancetype)cellWithCollctionView:(UICollectionView *)collectionView Identifier:(NSString *)ID IndexPath:(NSIndexPath *)indexPath;

+ (instancetype)cellWithCollctionView:(UICollectionView *)collectionView needXib:(BOOL)need IndexPath:(NSIndexPath *)indexPath;

- (void)setItem:(id)item;
@end
