//
//  ChartHeaderViewCell.m
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "ChartHeaderViewCell.h"
#import "HomeIndexModel.h"

@implementation ChartHeaderViewCell

+ (CGSize)sizeItem:(HomeIndexItemModel*)item indexPath:(NSIndexPath *)indexPath{
    CGFloat w1 = [NSString sizeWithString:[NSString stringWithFormat:@"%.2f",item.main_data.data] font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(SCREEN_WIDTH, 15) minHeight:15].width+30+3;
    CGFloat w2 = [NSString sizeWithString:[NSString stringWithFormat:@"%.2f",item.sub_data.data] font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(SCREEN_WIDTH, 15) minHeight:15].width+30+3;
    CGFloat w3 = [NSString sizeWithString:[NSString stringWithFormat:@"%.2f%@",(item.main_data.data/item.sub_data.data-1)*100,@"%"] font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(SCREEN_WIDTH, 15) minHeight:15].width+43+3;
    if (indexPath.row==0) {
        return CGSizeMake(w1, 75);
    }
    if (indexPath.row==1) {
        return CGSizeMake(w2, 75);
    }
    if (indexPath.row==2) {
        return CGSizeMake(w3, 75);
    }
    return CGSizeZero;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItem:(HomeIndexItemModel*)item{
    self.tipImageV.hidden = YES;
    self.valueRightLayout.constant = 10;
    NSArray* colors = @[[AppColor app_15color],[AppColor app_4color],[AppColor app_4color]];
    self.valueLab.textColor = colors[_indexPath.row];
    NSArray* titles = @[item.name,@"对比数据",@"变化率"];
    self.desLab.text = titles[_indexPath.row];
    if (_indexPath.row==0) {
        self.valueLab.text = [NSString stringWithFormat:@"%.2f",item.main_data.data];
    }
    if (_indexPath.row==1) {
        self.valueLab.text = [NSString stringWithFormat:@"%.2f",item.sub_data.data];

    }
    if (_indexPath.row==2) {
        self.tipImageV.hidden = NO;
        NSString* arrowString = [NSString stringWithFormat:@"%@_%@",item.state.arrow,item.state.color];
        _tipImageV.image = [UIImage imageNamed:arrowString];
        self.valueRightLayout.constant = 23;
        self.valueLab.text = [NSString stringWithFormat:@"%.2f%@",(item.main_data.data/item.sub_data.data-1)*100,@"%"];
    }
}

@end
