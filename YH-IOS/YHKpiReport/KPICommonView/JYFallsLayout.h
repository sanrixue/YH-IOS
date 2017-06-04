//
//  JYFallsLayout.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYFallsLayoutDelegate <NSObject>

- (void)layoutComputeFinish:(CGFloat)maxHeight;


@end


typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath);

@interface JYFallsLayout : UICollectionViewLayout

@property (nonatomic, weak) id <JYFallsLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat rowSpacing;
@property (nonatomic, assign) NSInteger lineNumber;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

- (void)computeIndexCellHeightWithWidthBlock:(CGFloat(^)(NSIndexPath *indexPath))block;


@end
