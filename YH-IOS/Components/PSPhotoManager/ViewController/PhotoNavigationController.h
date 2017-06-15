//
//  PhotoNavigationController.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ALAsset;

typedef void (^GetPhotosBlock) (NSArray <ALAsset *>*selectedArray);

@interface PhotoNavigationController : UINavigationController

- (instancetype)init;

- (instancetype)initWithMaxSelectedCount:(NSInteger)maxSelectedCount;

- (void)getSelectedPhotosWithBlock:(GetPhotosBlock)block;

// 最大选择数量
@property (nonatomic, assign) NSInteger maxSelectedCount;

@property (nonatomic, copy, readonly) GetPhotosBlock block;

@end
