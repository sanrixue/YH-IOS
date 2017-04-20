//
//  HomeIndexDetailListCell.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeIndexDetailListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (nonatomic, assign) double maxData;
@property (nonatomic, strong) CommonBack btnClickBack;
@property (weak, nonatomic) IBOutlet UIButton *valueBtn;
@end
