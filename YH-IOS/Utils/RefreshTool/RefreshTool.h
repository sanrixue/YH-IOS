//
//  RefreshTool.h
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshToolDownPullHeader.h"

@class RefreshTool;

@protocol RefreshToolDelegate <NSObject>

@optional

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView*)scrollView
                                             tool:(RefreshTool*)tool;

- (void)refreshToolBeginUpRefreshWithScrollView:(UIScrollView*)scrollView
                                             tool:(RefreshTool*)tool;

@end

@interface RefreshTool : NSObject

@property (nonatomic, weak) id<RefreshToolDelegate> delegate;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) RefreshToolDownPullHeader* downPullHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter* upPullFooter;

- (void)beginDownPull;

- (void)endRefreshDownPullEnd:(BOOL)downPullEnd
                   topPullEnd:(BOOL)topPullEnd
                       reload:(BOOL)reload
                       noMore:(BOOL)noMore;

- (void)endDownPullWithReload:(BOOL)reload;

- (void)endTopPullWithReload:(BOOL)reload
                      noMore:(BOOL)noMore;

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                          delegate:(id<RefreshToolDelegate>)delegate
                              down:(BOOL)down
                               top:(BOOL)top;

@end
