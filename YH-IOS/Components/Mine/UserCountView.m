//
//  UserCountView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "UserCountView.h"

@implementation UserCountView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    //数据
    _dataLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-112-80)/3, 40)];
    _dataLable.font = [UIFont systemFontOfSize:30];
    _dataLable.textAlignment= NSTextAlignmentCenter;
    _dataLable.textColor = [UIColor colorWithHexString:@"#000"];
    _dataLable.text = @"0";
    [self addSubview:_dataLable];
    
    // 单位
    _utilLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 15, (SCREEN_WIDTH-112-80)/3, 20)];
    _utilLabel.font = [UIFont systemFontOfSize:16];
    _utilLabel.textAlignment = NSTextAlignmentLeft;
    _utilLabel.textColor = [UIColor colorWithHexString:@"#000"];
    [self addSubview:_utilLabel];
    
    //名称
    _noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, 60, 20)];
    _noteLabel.font = [UIFont systemFontOfSize:12];
    _noteLabel.adjustsFontSizeToFitWidth = YES;
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    _noteLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_noteLabel];
    
}


@end
