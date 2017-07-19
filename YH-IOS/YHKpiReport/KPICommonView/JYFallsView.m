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
#import "JYCollectionFooterView.h"

@interface JYFallsView () <UICollectionViewDelegate, UICollectionViewDataSource, JYWaterLayoutDelegate/*JYFallsLayoutDelegate*/>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation JYFallsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initilizedSubView];
    }
    return self;
}

- (void)initilizedSubView {
    
    [self addSubview:self.collectView];
}

- (UICollectionView *)collectView {
    if (!_collectView) {
        
        JYWaterLayout *layout = [[JYWaterLayout alloc] init];
        layout.delegate = self;
        layout.headerViewHeight = 41;
        layout.minimumLineSpacing =8;
        _collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor clearColor];
        [_collectView registerClass:[JYFallsCell class] forCellWithReuseIdentifier:@"JYFallsCell"];
        [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectView registerClass:[JYCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JYCollectionHeader"];
        [_collectView registerClass:[JYCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JYCollectionFooterView"];
        _collectView.dataSource = self;
        _collectView.delegate = self;
        _collectView.scrollEnabled = NO;
        
    }
    
    return _collectView;
}

- (YHKPIDetailModel *)dataForIndexPath:(NSIndexPath *)indexPath {
    return (self.dataSource[indexPath.section].data[indexPath.row]);
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
    if (indexPath.item == 0) {
        cell.isFirstRow = YES;
    }
    else{
        cell.isFirstRow = NO;
    }
    cell.model = [self dataForIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
   // UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
   // bgView.image = [UIImage imageNamed:@"B_bg"];
    //cell.backgroundView = bgView;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource[section].data.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JYCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JYCollectionHeader" forIndexPath:indexPath];
        header.sectionTitle = self.dataSource[indexPath.section].group_name;
        header.backgroundColor = [UIColor whiteColor];
        return header;
    }
  /*  else if ([kind isEqualToString:@"background"]){
        UICollectionReusableView *backView = [[UICollectionReusableView alloc]init];
        backView.backgroundColor = [UIColor redColor];
        return backView;
    }*/
    else{
        JYCollectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JYCollectionFooterView" forIndexPath:indexPath];
        return footer;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fallsView:didSelectedItemAtIndex:data:)]) {
        [self.delegate fallsView:self didSelectedItemAtIndex:indexPath.row data:[self dataForIndexPath:indexPath]];
    }
}


//节颜色

-(UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section{
    return [UIColor whiteColor];
}


#pragma mark - <JYWaterLayoutDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYWaterLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    CGFloat itemH;
    if (([self dataForIndexPath:indexPath]).dashboardType == DashBoardTypeLine ||
        ([self dataForIndexPath:indexPath]).dashboardType == DashBoardTypeBar) {
        itemH = 280;
    }
    else if (([self dataForIndexPath:indexPath]).dashboardType == DashBoardTypeSignleLongValue1){
        itemH = 58;
    }
    
    else if (([self dataForIndexPath:indexPath]).dashboardType == DashBoardTypeSignleValue1){
        itemH = 107;
    }
    else {
        itemH = (280 - JYDefaultMargin) / 2.0;
    }
    return itemH;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JYWaterLayout *)layout withSection:(NSInteger )section{
     CGFloat itemW;
    if (self.dataSource[section].data[0].dashboardType == DashBoardTypeLine ||
        self.dataSource[section].data[0].dashboardType == DashBoardTypeBar) {
        itemW = 2;
    }
    else if (self.dataSource[section].data[0].dashboardType == DashBoardTypeSignleLongValue1){
        itemW = 1;
    }
    
    else if (self.dataSource[section].data[0].dashboardType == DashBoardTypeSignleValue1){
        itemW = 2;
    }
    else {
        itemW = 2;
    }
    
    return itemW;
}


@end
