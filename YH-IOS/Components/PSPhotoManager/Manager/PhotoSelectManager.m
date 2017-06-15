//
//  PhotoSelectManager.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoSelectManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define PhotoSelecter [PhotoSelectManager shareInstance]

@interface PhotoSelectManager ()

@property (nonatomic, strong) NSMutableArray <ALAsset *>*dataArray;
@property (nonatomic, assign) NSInteger maxSelectedCount;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation PhotoSelectManager

+ (instancetype)shareInstance {
    static PhotoSelectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PhotoSelectManager alloc] init];
        manager.dataArray = [NSMutableArray array];
        manager.concurrentQueue = dispatch_queue_create("com.github.slipawayleaon", DISPATCH_QUEUE_CONCURRENT);
    });
    return manager;
}

#pragma mark -
#pragma mark - privite methods
- (NSArray *)selectedAssets {
    __block NSArray *assets;
    dispatch_sync(self.concurrentQueue, ^{
        assets = [NSArray arrayWithArray:_dataArray];
    });
    return assets;
}

- (void)addAsset:(ALAsset *)asset {
    if (!asset) {
        return;
    }
    dispatch_barrier_async(self.concurrentQueue, ^{
        [_dataArray addObject:asset];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postSelectAssetsUpdateNotification];
        });
    });
}

- (void)removeAsset:(ALAsset *)asset {
    if (!asset) {
        return;
    }
    if (![_dataArray containsObject:asset]) {
        return;
    }
    dispatch_barrier_async(self.concurrentQueue, ^{
        [_dataArray removeObject:asset];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postSelectAssetsUpdateNotification];
        });
    });
}

- (void)removeAllAssets {
    dispatch_barrier_async(self.concurrentQueue, ^{
        [_dataArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postSelectAssetsUpdateNotification];
        });
    });
}

- (void)postSelectAssetsUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectAssetsUpdateNotification object:nil];
}

#pragma mark -
#pragma mark - external methods
+ (NSArray *)selectedAssets {
    return [PhotoSelecter selectedAssets];
}

+ (void)addAsset:(ALAsset *)asset {
    [PhotoSelecter addAsset:asset];
}

+ (void)removeAsset:(ALAsset *)asset {
    [PhotoSelecter removeAsset:asset];
}

+ (void)removeAllAssets {
    [PhotoSelecter removeAllAssets];
}

+ (NSInteger)maxSelectedCount {
    return PhotoSelecter.maxSelectedCount;
}

+ (void)setMaxSelectedCount:(NSInteger)maxSelectedCount {
    PhotoSelecter.maxSelectedCount = maxSelectedCount;
}

@end
