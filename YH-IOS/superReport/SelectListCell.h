//
//  SelectListCell.h
//  SwiftCharts
//
//  Created by CJG on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperChartModel.h"

@interface SelectListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIButton *keyBtn;

@property (nonatomic, strong) CommonBack selectBack;
@property (nonatomic, strong) CommonBack keyBack;

- (void)setItem:(id)item;

@end
