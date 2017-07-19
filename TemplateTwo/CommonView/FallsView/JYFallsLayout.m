//
//  JYFallsLayout.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYFallsLayout.h"

@interface JYFallsLayout ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *dicOfheight;
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *attrArray;
@property (nonatomic, copy) HeightBlock block;


@end

@implementation JYFallsLayout

- (instancetype)init {
    if (self = [super init]) {
        
        self.attrArray = [NSMutableArray array];
        self.dicOfheight = [NSMutableDictionary dictionary];
        self.lineNumber = 2;
        self.lineSpacing = JYDefaultMargin;
        self.rowSpacing = JYDefaultMargin;
        self.sectionInset = UIEdgeInsetsMake(JYDefaultMargin, JYDefaultMargin*2, JYDefaultMargin, JYDefaultMargin*2);
    }
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < self.lineNumber; i++) {
        
        [self.dicOfheight setObject:[NSString stringWithFormat:@"%f", self.sectionInset.top] forKey:[NSString stringWithFormat:@"%zi", i]];
    }
    
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.attrArray addObject:[self layoutAttributesForItemAtIndexPath:idxPath]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutComputeFinish:)]) {        
        __block CGFloat maxHeigh = 0.0;
        [self.dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (maxHeigh < [obj floatValue]) {
                maxHeigh = [obj floatValue];
            }
        }];
        [self.delegate layoutComputeFinish:maxHeigh];
    }
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemWidth = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.lineNumber - 1) * self.lineSpacing) / self.lineNumber - JYDefaultMargin;
    // TODO:根据图标类型确定高度
    CGFloat itemHeight;
    if (self.block != nil) {
        itemHeight = self.block(indexPath);
    }else{
        NSAssert(itemHeight != 0,@"Please implement computeIndexCellHeightWithWidthBlock Method");
    }
    
    CGRect frame;
    frame.size = CGSizeMake(itemWidth, itemHeight);
    __block NSString *lineMinHeight = @"0";
    [self.dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        if ([self.dicOfheight[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    
    int line = [lineMinHeight intValue];
    frame.origin = CGPointMake(self.sectionInset.left + line * (itemWidth + self.lineSpacing), [self.dicOfheight[lineMinHeight] floatValue]);
    self.dicOfheight[lineMinHeight] = [NSString stringWithFormat:@"%f", frame.size.height + self.rowSpacing + [self.dicOfheight[lineMinHeight] floatValue]];
    attri.frame = frame;
    
    return attri;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrArray;
}

- (CGSize)collectionViewContentSize {
    __block NSString *maxHeighLine = @"0";
    [self.dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([self.dicOfheight[maxHeighLine] floatValue] < [obj floatValue]) {
            maxHeighLine = key;
        }
    }];
    
    return CGSizeMake(self.collectionView.frame.size.width, [self.dicOfheight[maxHeighLine] floatValue] + self.sectionInset.bottom);
}

- (void)computeIndexCellHeightWithWidthBlock:(CGFloat (^)(NSIndexPath *))block{
  if (self.block != block) {
      self.block = block;
   }
}

@end
