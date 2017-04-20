//
//  HomeIndexCollectionCell.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeIndexModel.h"

@interface HomeIndexCollectionCell : UICollectionViewCell

/** 单击第几个回调 */
@property (nonatomic, strong) CommonBack indexBack;
/** 双击第几个回调 */
@property (nonatomic, strong) CommonBack doubleIndexBack;


- (void)setWithIndex:(NSInteger)index items:(NSArray*)items;

@end
