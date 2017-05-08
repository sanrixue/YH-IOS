//
//  JYFallsView.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYFallsView.h"

//#import "JYFallsLayout.h"
#import "JYWaterLayout.h"
#import "JYFallsCell.h"
#import "JYCollectionHeader.h"

@interface JYFallsView () <UICollectionViewDelegate, UICollectionViewDataSource, JYWaterLayoutDelegate/*JYFallsLayoutDelegate*/>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation JYFallsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initilizedSubView];
    }
    return self;
}

- (void)initilizedSubView {
    
    [self addSubview:self.collectView];
}

- (UICollectionView *)collectView {
    if (!_collectView) {
//        __weak typeof(self) weakSelf = self;
//        JYFallsLayout *layout = [[JYFallsLayout alloc] init];// 全部属性默认
//        layout.delegate = self;
//        [layout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath) {
//            __strong typeof(weakSelf) inStrongSelf = weakSelf;
//            CGFloat itemH;
//            if ((inStrongSelf.dataSource[indexPath.row]).dashboardType == DashBoardTypeLine ||
//                (inStrongSelf.dataSource[indexPath.row]).dashboardType == DashBoardTypeBar) {
//                itemH = 263;
//            }
//            else {
//                itemH = (263 - JYDefaultMargin) / 2.0;
//            }
//            return itemH;
//        }];
        
        JYWaterLayout *layout = [[JYWaterLayout alloc] init];
        layout.delegate = self;
        layout.headerViewHeight = 50;
        
        _collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor clearColor];
        [_collectView registerClass:[JYFallsCell class] forCellWithReuseIdentifier:@"JYFallsCell"];
        [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectView registerClass:[JYCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JYCollectionHeader"];
        _collectView.dataSource = self;
        _collectView.delegate = self;
        _collectView.scrollEnabled = NO;
    }
    
    return _collectView;
}

- (JYDashboardModel *)dataForIndexPath:(NSIndexPath *)indexPath {
    return (self.dataSource[indexPath.section][indexPath.row]);
}

#pragma mark - <JYFallsLayoutDelegate>
- (void)layoutComputeFinish:(CGFloat)maxHeight {
    
    CGRect frame = self.collectView.frame;
    frame.size.height = maxHeight;
    self.collectView.frame = frame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fallsView:refreshHeight:)]) {
        [self.delegate fallsView:self refreshHeight:maxHeight];
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JYFallsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYFallsCell" forIndexPath:indexPath];
    cell.model = [self dataForIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource[section].count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JYCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JYCollectionHeader" forIndexPath:indexPath];
    header.sectionTitle = [self dataForIndexPath:indexPath].groupName;
    return header;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fallsView:didSelectedItemAtIndex:data:)]) {
        [self.delegate fallsView:self didSelectedItemAtIndex:indexPath.row data:[self dataForIndexPath:indexPath]];
    }
}


#pragma mark - <JYWaterLayoutDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYWaterLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    CGFloat itemH;
    if (([self dataForIndexPath:indexPath]).dashboardType == DashBoardTypeLine ||
        ([self dataForIndexPath:indexPath]).dashboardType == DashBoardTypeBar) {
        itemH = 263;
    }
    else {
        itemH = (263 - JYDefaultMargin) / 2.0;
    }
    return itemH;
}



@end
