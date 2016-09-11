//
//  OneButtonTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "OneButtonTableViewCell.h"

@implementation OneButtonTableViewCell

- (instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithView];
    }
    return self;
}

- (void)initWithView {
    self.actionBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 5, [[UIScreen mainScreen]bounds].size.width-28, 34)];
    self.actionBtn.backgroundColor = [UIColor redColor];
    self.actionBtn.layer.cornerRadius = 6.0f;
    [self addSubview:self.actionBtn];
}

@end
