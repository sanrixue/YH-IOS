//
//  PagedFlowView.h
//  taobao4iphone
//
//  Created by Lu Kejin on 3/2/12.
//  Copyright (c) 2012 geeklu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagedFlowViewDataSource;
@protocol PagedFlowViewDelegate;

@interface JYPagedFlowView : UIView
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic, assign) CGFloat minimumPageAlpha;
@property(nonatomic, assign) CGFloat minimumPageScale;
@property(nonatomic, assign, readonly) NSInteger currentPageIndex;

@property(nonatomic,weak) id <PagedFlowViewDataSource> dataSource;
@property(nonatomic,weak) id <PagedFlowViewDelegate> delegate;

- (void)reloadData;
- (UIView *)dequeueReusableCell; // 获取可重复使用的Cell
- (void)scrollToPage:(NSUInteger)pageNumber;

@end


@protocol  PagedFlowViewDelegate<NSObject>

- (CGSize)sizeForPageInFlowView:(JYPagedFlowView *)flowView;

@optional
- (void)flowView:(JYPagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index;
- (void)flowView:(JYPagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index;

@end


@protocol PagedFlowViewDataSource <NSObject>

- (NSInteger)numberOfPagesInFlowView:(JYPagedFlowView *)flowView;
- (UIView *)flowView:(JYPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end
