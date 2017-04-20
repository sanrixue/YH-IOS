//
//  ChartHeaderViewCell.h
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartHeaderViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageV;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueRightLayout;
@property (nonatomic, strong) NSIndexPath* indexPath;

+ (CGSize)sizeItem:(id)item indexPath:(NSIndexPath*)indexPath;

@end
