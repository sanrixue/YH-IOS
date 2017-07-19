//
//  JYRootScrollViewManager.m
//  JYRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYRootScrollViewManager.h"
#import "JYRootScrollViewCell.h"

@implementation JYRootScrollViewManager

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    [self.rootScrollView reloadPageViews];
}

- (id)initWithRootScrollView:(JYRootScrollView *)rootScrollView{
    self = [super init];
    if (self) {
        self.rootScrollView = rootScrollView;
    }
    return self;
}

- (NSUInteger)numberOfCellInRootScrollView:(JYRootScrollView *)rootScrollView{
    return self.pageViews.count;
}

- (CGFloat)rootScrollView:(JYRootScrollView *)rootScrollView marginForType:(JYRootScrollViewMarginType)type{
    return self.margin;
}

- (JYRootScrollViewCell *)rootScrollView:(JYRootScrollView *)rootScrollView AtIndex:(NSUInteger)index{
    JYRootScrollViewCell *cell = [JYRootScrollViewCell cellWithRootScrollView:rootScrollView];
    UIView *pageView = self.pageViews[index];
    [cell setpageViewInCell:pageView];
    return cell;
}
@end
