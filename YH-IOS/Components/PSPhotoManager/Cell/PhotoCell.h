//
//  PhotoCell.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

typedef void (^PhotoSelectedIndexBlock) (NSInteger selectedIndex);

@interface PhotoCell : UICollectionViewCell

- (void)reloadDataWithAsset:(ALAsset *)asset index:(NSInteger)index;

- (void)getPhotoSelectedIndexWithBlock:(PhotoSelectedIndexBlock)block;

- (void)resetSelected:(BOOL)selected;

@end
