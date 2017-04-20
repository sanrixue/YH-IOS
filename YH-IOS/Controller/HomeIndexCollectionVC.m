//
//  HomeIndexCollectionVC.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexCollectionVC.h"
#import "HomeIndexCollectionCell.h"

@interface HomeIndexCollectionVC () <UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collection;
@property (nonatomic, strong) HomeIndexItemModel* data;
@end

@implementation HomeIndexCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setWithHomeIndexModel:(HomeIndexItemModel *)model{
    _data = model;
    [_collection reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeIndexCollectionCell *cell = [HomeIndexCollectionCell cellWithCollctionView:collectionView needXib:YES IndexPath:indexPath];
    [cell setWithIndex:indexPath.row items:_data.items];
    cell.indexBack = ^(NSNumber* item){
        if (self.delegate && [self.delegate respondsToSelector:@selector(homeIndexCollectionVCSelectIndex:model:vc:)]) {
            DLog(@"index === %zd",item.integerValue);
            [self.delegate homeIndexCollectionVCSelectIndex:item.integerValue model:_data vc:self];
        }
    };
    cell.doubleIndexBack = ^(NSNumber* item){
        if (self.delegate && [self.delegate respondsToSelector:@selector(doubClikWithHomeIndexCollectionVCSelectIndex:model:vc:)]) {
            DLog(@"双击了index === %zd",item.integerValue);
            [self.delegate doubClikWithHomeIndexCollectionVCSelectIndex:item.integerValue model:_data vc:self];
        }
    };
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (_data.items.count+5)/6;
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 640.0/750.0*SCREEN_WIDTH);
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.dataSource = self;
        _collection.backgroundColor = UIColorHex(ffffff);
        _collection.showsHorizontalScrollIndicator = NO;
    }
   return _collection;
}


@end
