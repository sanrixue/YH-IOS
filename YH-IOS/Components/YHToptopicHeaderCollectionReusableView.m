//
//  YHToptopicHeaderCollectionReusableView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHToptopicHeaderCollectionReusableView.h"

@implementation YHToptopicHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.greenView.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
    self.titleLable.font = [UIFont systemFontOfSize:14];
    self.titleLable.textColor = [UIColor colorWithHexString:@"#6aa657"];
    self.titleLable.backgroundColor = [UIColor whiteColor];
    self.leftIamge.image = [UIImage imageNamed:@"line_green"];
    
    // Initialization code
}

@end
