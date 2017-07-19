//
//  JYRootScrollView.h
//  JYRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYRootScrollViewCell.h"

typedef enum{
    JYRootScrollViewMarginTypeTop,
    JYRootScrollViewMarginTypeBottom,
    JYRootScrollViewMarginTypeLeft,
    JYRootScrollViewMarginTypeRight
} JYRootScrollViewMarginType;

@class JYRootScrollView;

/**
 * rootScrollView的数据方法
 */
@protocol JYRootScrollViewDateSource <NSObject>
@required
- (NSUInteger)numberOfCellInRootScrollView:(JYRootScrollView *)rootScrollView;
- (JYRootScrollViewCell *)rootScrollView:(JYRootScrollView *)rootScrollView AtIndex:(NSUInteger)index;
@end

/**
 * rootScrollView的代理方法
 */
@protocol JYRootScrollViewDelegate <NSObject>
@optional
- (void)rootScrollView:(JYRootScrollView *)rootScrollView didSelectAtIndex:(NSUInteger)index;

- (CGFloat)rootScrollView:(JYRootScrollView *)rootScrollView marginForType:(JYRootScrollViewMarginType)type;
@end

@interface JYRootScrollView : UIScrollView

@property (nonatomic, weak) id <JYRootScrollViewDateSource>rootScrollViewDateSource;
@property (nonatomic, weak) id <JYRootScrollViewDelegate>rootScrollViewDelegate;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat rootScrollWidth;
@property (nonatomic, assign) CGFloat rootScrollHeight;

- (void)reloadPageViews;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
