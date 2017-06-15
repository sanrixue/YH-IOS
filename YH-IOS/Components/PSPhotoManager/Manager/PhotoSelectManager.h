//
//  PhotoSelectManager.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;

// 选中图片更新通知
static NSString *const kSelectAssetsUpdateNotification = @"kSelectAssetsUpdateNotification";

@interface PhotoSelectManager : NSObject

// 读取已选中图片
+ (NSArray *)selectedAssets;

// 添加选中图片
+ (void)addAsset:(ALAsset *)asset;

// 移除选中图片
+ (void)removeAsset:(ALAsset *)asset;

// 移除全部选中图片
+ (void)removeAllAssets;

// 获取最大选择数
+ (NSInteger)maxSelectedCount;

// 设置最大选择数
+ (void)setMaxSelectedCount:(NSInteger)maxSelectedCount;

@end
