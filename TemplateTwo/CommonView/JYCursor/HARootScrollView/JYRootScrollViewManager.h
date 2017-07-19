//
//  JYRootScrollViewManager.h
//  JYRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYRootScrollView.h"

@interface JYRootScrollViewManager : NSObject <JYRootScrollViewDateSource, JYRootScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, weak) JYRootScrollView *rootScrollView;
@property (nonatomic, assign) CGFloat margin;

- (id)initWithRootScrollView:(JYRootScrollView *)rootScrollView;

@end
