//
//  ChartHeaderView.h
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartHeaderView : UIView <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end
