//
//  RefreshTool.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RefreshTool.h"

@interface RefreshTool ()
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UICollectionView* collectionView;
@end

@implementation RefreshTool

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshToolDelegate>)delegate down:(BOOL)down top:(BOOL)top{
    self = [super init];
    if (self) {
        if (down) {
            [self addDownPullHeaderWithScrollView:scrollView delegate:delegate];
        }
        if (top) {
            [self addTopPullHeaderWithScrollView:scrollView delegate:delegate];
        }
    }
    return self;
}

- (void)addDownPullHeaderWithScrollView:(UIScrollView*)scrollView delegate:(id<RefreshToolDelegate>)delegate{
    _delegate = delegate;
    self.scrollView = scrollView;
    _scrollView.mj_header = self.downPullHeader;
}

- (void)addTopPullHeaderWithScrollView:(UIScrollView*)scrollView delegate:(id<RefreshToolDelegate>)delegate{
    _delegate = delegate;
    self.scrollView = scrollView;
    _scrollView.mj_footer = self.upPullFooter;
}

- (void)beginDownPull{
    if (_scrollView.mj_header) {
        [_downPullHeader beginRefreshing];
    }
}

- (void)endRefreshDownPullEnd:(BOOL)downPullEnd topPullEnd:(BOOL)topPullEnd reload:(BOOL)reload noMore:(BOOL)noMore{
    if (downPullEnd) {
        [_downPullHeader endRefreshing];
        if (reload) {
            [self reloadScrollView];
        }
    }
    if (topPullEnd) {
        if (noMore) {
            [_upPullFooter endRefreshingWithNoMoreData];
        }else{
            [_upPullFooter endRefreshing];
        }
        if (reload) {
            [self reloadScrollView];
        }
    }
    if (_scrollView.mj_footer) { //防止刚出来的时候footer显示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_tableView) {
                _upPullFooter.hidden = _tableView.visibleCells.count<1;
            }
            if (_collectionView) {
                _upPullFooter.hidden = _collectionView.visibleCells.count<1;
            }
        });
    }
}

- (void)endDownPullWithReload:(BOOL)reload{
    [self endRefreshDownPullEnd:YES topPullEnd:false reload:reload noMore:NO];
}

- (void)endTopPullWithReload:(BOOL)reload noMore:(BOOL)noMore{
    [self endRefreshDownPullEnd:false topPullEnd:YES reload:reload noMore:noMore];

}

- (void)reloadScrollView{
    [_tableView reloadData];
    [_collectionView reloadData];
}


#pragma mark - lazy init and set

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        _tableView = (UITableView*)scrollView;
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        _collectionView = (UICollectionView*)scrollView;
    }
}

- (RefreshToolDownPullHeader *)downPullHeader{
    if (!_downPullHeader) {
        _downPullHeader = [RefreshToolDownPullHeader headerWithRefreshingBlock:^{
            if (_delegate && [_delegate respondsToSelector:@selector(refreshToolBeginDownRefreshWithScrollView:tool:)]) {
                [_delegate refreshToolBeginDownRefreshWithScrollView:_scrollView tool:self];
            }
        }];
    }
    return _downPullHeader;
}

- (MJRefreshAutoNormalFooter *)upPullFooter{
    if (!_upPullFooter) {
        _upPullFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (_delegate && [_delegate respondsToSelector:@selector(refreshToolBeginUpRefreshWithScrollView:tool:)]) {
                [_delegate refreshToolBeginUpRefreshWithScrollView:_scrollView tool:self];
            }
        }];
        _upPullFooter.triggerAutomaticallyRefreshPercent = 0.01;
        _upPullFooter.hidden = YES;
    }
    return _upPullFooter;
}

@end
