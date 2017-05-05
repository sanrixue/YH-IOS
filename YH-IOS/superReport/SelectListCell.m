//
//  SelectListCell.m
//  SwiftCharts
//
//  Created by CJG on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "SelectListCell.h"
#import "SuperChartMainModel.h"

@interface SelectListCell ()


@end

@implementation SelectListCell
- (IBAction)titleAction:(id)sender {
    if (self.selectBack) {
        self.selectBack(self);
    }
    
}
- (IBAction)keyAction:(id)sender {
    if (self.keyBack) {
        self.keyBack(self);
    }
}

- (void)setItem:(TableDataBaseItemModel*)item{
  /* if (item.isKey) { //关键列无法取消选中
        item.select = YES;
    }*/
    [self.titleBtn setTitle:item.value forState:UIControlStateNormal];
    self.titleBtn.selected = item.select;
    self.desLab.hidden = !item.isKey;
    self.keyBtn.selected = item.isKey;
   // self.titleBtn.userInteractionEnabled = !item.isKey;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
