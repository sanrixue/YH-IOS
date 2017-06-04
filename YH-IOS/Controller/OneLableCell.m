//
//  OneLableCell.m
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "OneLableCell.h"

@implementation OneLableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_contentBtn cornerRadius:15];
    [_contentBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_contentBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
}



@end
