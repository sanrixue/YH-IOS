//
//  DoubleClickSuperChartCell.h
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YH_BarView.h"

@interface DoubleClickSuperChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet YH_BarView *barView;
@property (nonatomic, strong) CommonBack doubleBack;
@end
