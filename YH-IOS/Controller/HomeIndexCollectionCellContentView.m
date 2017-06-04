//
//  HomeIndexCollectionCellContentView.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexCollectionCellContentView.h"

@implementation HomeIndexCollectionCellContentView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setBorderColor:[AppColor app_9color] width:0.5];
}

- (void)setWithHomeIndexItemModel:(HomeIndexItemModel *)model{
    _titleLab.text = model.name;
    _valueLab.text = [NSString stringWithFormat:@"%.2f",model.main_data.data];
    _secondValueLab.text = [NSString stringWithFormat:@"%.2f",model.sub_data.data];
    NSString* arrowString = [NSString stringWithFormat:@"%@_%@",model.state.arrow,model.state.color];
    _tipImageV.image = [UIImage imageNamed:arrowString];
    if (model.select) {
        [self setBorderColor:[AppColor app_1color] width:1];

    }else{
        [self setBorderColor:[AppColor app_9color] width:0.5];

    }
}

@end
