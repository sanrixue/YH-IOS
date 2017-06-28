//
//  RightSwitchTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RightSwitchTableViewCell.h"

@implementation RightSwitchTableViewCell

-(id)init {
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}


-(void)initSubView {
    
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
