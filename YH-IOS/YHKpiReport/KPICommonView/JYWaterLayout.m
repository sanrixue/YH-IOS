//
//  JYWaterCollectionViewLayout.m
//  JYUICollectionView
//
//  Created by FM-13 on 16/6/23.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "JYWaterLayout.h"
#import "JHCollectionReusableView.h"
#import "JHCollectionViewLayoutAttributes.h"

//NSString *const JHCollectionViewSectionBackground = @"JHCollectionViewSectionBackground";


@interface JYWaterLayout()

@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;//保存cell的布局
@property (strong, nonatomic) NSMutableDictionary *headLayoutInfo;//保存头视图的布局
@property (strong, nonatomic) NSMutableDictionary *footLayoutInfo;//保存尾视图的布局

@property (assign, nonatomic) CGFloat startY;//记录开始的Y
@property (strong, nonatomic) NSMutableDictionary *maxYForColumn;//记录瀑布流每列最下面那个cell的底部y值
@property (strong, nonatomic) NSMutableArray *shouldanimationArr;//记录需要添加动画的NSIndexPath


@end

@implementation JYWaterLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        // self.numberOfColumns = 1;
        self.topAndBottomDustance = 0;
        _headerViewHeight = 41;
        _footViewHeight = 15.5;
        self.startY = 1;
        self.maxYForColumn = [NSMutableDictionary dictionary];
        self.shouldanimationArr = [NSMutableArray array];
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.headLayoutInfo = [NSMutableDictionary dictionary];
        self.footLayoutInfo = [NSMutableDictionary dictionary];
        self.decorationViewAttrs = [NSMutableArray array];
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self registerClass:[JHCollectionReusableView class] forDecorationViewOfKind:@"JHCollectionViewSectionBackground"];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //重新布局需要清空
    [self.cellLayoutInfo removeAllObjects];
    [self.headLayoutInfo removeAllObjects];
    [self.footLayoutInfo removeAllObjects];
    [self.maxYForColumn removeAllObjects];
    self.sectionInset = UIEdgeInsetsMake(10, 0, -20, 0);
    self.startY = 1;
    
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionsCount; section++) {
        self.numberOfColumns =[(id<JYWaterLayoutDelegate>)self.delegate collectionView:self.collectionView layout:self withSection:(NSInteger )section];
        if (self.numberOfColumns ==1) {
            self.cellDistance = 8;
        }
        else{
            self.cellDistance = 8;
        }
        CGFloat viewWidth = self.collectionView.frame.size.width;
        CGFloat itemWidth = (viewWidth - self.cellDistance*(self.numberOfColumns + 1))/self.numberOfColumns;
        
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (_headerViewHeight>0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView: viewForSupplementaryElementOfKind: atIndexPath:)]) {
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
            
            attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, _headerViewHeight);
            self.headLayoutInfo[supplementaryViewIndexPath] = attribute;
            self.startY = self.startY + _headerViewHeight + _topAndBottomDustance;
        }else{
            self.startY += _topAndBottomDustance;
        }
        
        for (int i = 0; i < _numberOfColumns; i++) {
            self.maxYForColumn[@(i)] = @(self.startY);
        }
        
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger row = 0; row < rowsCount; row++) {
            NSIndexPath *cellIndePath =[NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndePath];
            
            CGFloat y = [self.maxYForColumn[@(0)] floatValue];
            NSInteger currentRow = 0;
            for (int i = 1; i < _numberOfColumns; i++) {
                if ([self.maxYForColumn[@(i)] floatValue] < y) {
                    y = [self.maxYForColumn[@(i)] floatValue];
                    currentRow = i;
                }
            }
            
            CGFloat x = self.cellDistance + (self.cellDistance + itemWidth)*currentRow;
            CGFloat height = [(id<JYWaterLayoutDelegate>)self.delegate collectionView:self.collectionView layout:self heightOfItemAtIndexPath:cellIndePath itemWidth:itemWidth];
            
            attribute.frame = CGRectMake(x, y, itemWidth, height);
            y = y + self.cellDistance + height;
            self.maxYForColumn[@(currentRow)] = @(y);
            
            self.cellLayoutInfo[cellIndePath] = attribute;
            
            if (row == rowsCount -1) {
                CGFloat maxY = [self.maxYForColumn[@(0)] floatValue];
                for (int i = 1; i < _numberOfColumns; i++) {
                    if ([self.maxYForColumn[@(i)] floatValue] > maxY) {
                        NSLog(@"%f", [self.maxYForColumn[@(i)] floatValue]);
                        maxY = [self.maxYForColumn[@(i)] floatValue];
                    }
                }
                self.startY = maxY - self.cellDistance + self.topAndBottomDustance;
            }
        }
        
        if (_footViewHeight>0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView: viewForSupplementaryElementOfKind: atIndexPath:)]) {
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
            
            attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, _footViewHeight);
            self.footLayoutInfo[supplementaryViewIndexPath] = attribute;
            self.startY = self.startY + _footViewHeight;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutComputeFinish:)]) {
        __block CGFloat maxHeigh = 0.0;
        [self.maxYForColumn enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (maxHeigh < [obj floatValue]) {
                maxHeigh = [obj floatValue];
            }
        }];
        [self.delegate layoutComputeFinish:maxHeigh];
    }
    
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    [self.headLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    [self.footLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    return allAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = self.headLayoutInfo[indexPath];
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        attribute = self.footLayoutInfo[indexPath];
    }
    return attribute;
}


- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
}
@end
