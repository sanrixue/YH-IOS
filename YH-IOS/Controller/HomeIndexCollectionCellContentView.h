//
//  HomeIndexCollectionCellContentView.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeIndexModel.h"

@interface HomeIndexCollectionCellContentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageV;
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UILabel *secondValueLab;

- (void)setWithHomeIndexItemModel:(HomeIndexItemModel*)model;

@end
