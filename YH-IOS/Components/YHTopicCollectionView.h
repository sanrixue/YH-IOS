//
//  YHTopicCollectionView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/16.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListPage.h"

@interface YHTopicCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic) NSArray<ListPage*> * allData;


@property(copy,nonatomic,readonly) id block;
@property (nonatomic, strong)UICollectionView *collectionView;


-(void)reloadData;


-(id)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSInteger left, id info))selectIndex;
@end
