//
//  FilterSuperChartHeaderCell.h
//  SwiftCharts
//
//  Created by CJG on 17/4/24.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSuperChartHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *swichBtn;
@property (nonatomic, strong) CommonBack swichBack;
@end
