//
//  DoubleClickSuperChartHeaderCell.h
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleClickSuperChartHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, strong) CommonBack sortBack;
@end
