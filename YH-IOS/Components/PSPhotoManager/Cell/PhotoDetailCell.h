//
//  PhotoDetailCell.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

//static NSString *const kSingleTapNotification = @"kSingleTapNotification";

@interface PhotoDetailCell : UICollectionViewCell

- (void)reloadDataWithAsset:(ALAsset *)asset;

@end
