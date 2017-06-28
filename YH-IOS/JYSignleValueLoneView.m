//
//  JYSignleValueLoneView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/21.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "JYSignleValueLoneView.h"

@implementation JYSignleValueLoneView


-(id)initWithFrame:(CGRect)frame withShow:(BOOL)isShow{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
     self.isShow = isShow;
    [self layoutAllSubView];
    return self;
}

-(void)layoutAllSubView{
    
    //添加分割线
    UIView *seperLine = [[UIView alloc]init];
    seperLine.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
    [self addSubview:seperLine];
    [seperLine setHidden:NO];
    
    _seperLine2 = [[UIView alloc]init];
    _seperLine2.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
    [self addSubview:_seperLine2];
    if (_isShow) {
         [_seperLine2 setHidden:NO];
    }
    else{
        [_seperLine2 setHidden:YES];
    }
    
    //self.backgroundColor = [UIColor yellowColor];
   // self.layer.borderColor = [UIColor colorWithHexString:@"#959595"].CGColor;
    //self.layer.borderWidth = 1;
    // 添加标题
    self.titleLable = [UILabel new];
    self.titleLable.font = [UIFont systemFontOfSize:16];
    self.titleLable.text = @"小店销售概况";
    self.titleLable.numberOfLines = 0;
    //self.titleLable.adjustsFontSizeToFitWidth = YES;
    self.titleLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLable];
    
    // 添加值
    self.valueLable = [UILabel new];
    self.valueLable.font = [UIFont systemFontOfSize:15];
    self.valueLable.text = @"12345";

    self.valueLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_valueLable];
    
    // 添加值单位
    
    self.utilLable = [UILabel new];
    self.utilLable.font = [UIFont systemFontOfSize:7];
    self.utilLable.text= @"万元";
    self.utilLable.textColor = [UIColor colorWithHexString:@"#808080"];
    [self addSubview:_utilLable];
    
    // 添加值描述
    self.detailUtilLable = [UILabel new];
    self.detailUtilLable.font = [UIFont systemFontOfSize:9];
    self.detailUtilLable.textColor =[UIColor colorWithHexString:@"#808080"];
    self.detailUtilLable.text = @"小店品类周销售额";
    self.detailUtilLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_detailUtilLable];
    
    self.warnLable = [UILabel new];
    self.warnLable.font = [UIFont systemFontOfSize:14];
    self.warnLable.text = @"-0.17";
    self.warnLable.textAlignment = NSTextAlignmentCenter;
    self.warnLable.layer.cornerRadius = 3;
    self.warnLable.clipsToBounds = YES;
    self.warnLable.textColor = [UIColor whiteColor];
    self.warnLable.backgroundColor = [UIColor colorWithHexString:@"#ff0000"];
    [self addSubview:self.warnLable];
    
    self.detailWarnLable = [UILabel new];
    self.detailWarnLable.textColor =[UIColor colorWithHexString:@"#808080"];
    self.detailWarnLable.font = [UIFont systemFontOfSize:9];
    self.detailWarnLable.text = @"周同比增长率";
    [self addSubview:self.detailWarnLable];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(0);
        make.left.equalTo(self.mas_left).mas_offset(13);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-1);
        make.right.equalTo(self.mas_centerX).mas_offset(-20);
        
    }];
    
    [self.valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(16);
        make.centerX.equalTo(self.mas_centerX).mas_offset(0);
        //make.right.equalTo(self.utilLable.mas_left).mas_offset(-5);
        make.bottom.equalTo(self.detailUtilLable.mas_top).mas_offset(-6);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
    }];
    
    [self.detailUtilLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueLable.mas_bottom).mas_offset(6);
        //make.left.equalTo(self.valueLable.mas_left).mas_offset(-6);
        make.centerX.equalTo(self.mas_centerX).mas_offset(0);
       // make.right.equalTo(self.utilLable.mas_right).mas_offset(6);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-10);
        make.width.equalTo(@80);
    }];
    
    [self.warnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(10);
        make.right.equalTo(self.mas_right).mas_offset(-20);
        make.bottom.equalTo(self.detailWarnLable.mas_top).mas_offset(-5);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    [self.utilLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(16);
        make.bottom.equalTo(self.valueLable.mas_bottom).mas_offset(0);
        make.left.equalTo(self.valueLable.mas_right).mas_offset(5);
        make.width.equalTo(@20);
    }];
    
    [self.detailWarnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.warnLable.mas_bottom).mas_offset(5);
        make.left.equalTo(self.warnLable.mas_left).mas_offset(0);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-10);
        make.right.equalTo(self.mas_right).mas_offset(-5);
    }];
    
    [seperLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(-2);
        make.bottom.equalTo(self.mas_bottom).mas_offset(0);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.mas_right).mas_offset(2);
    }];
    
    [_seperLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(-2);
        make.top.equalTo(self.mas_top).mas_offset(0);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.mas_right).mas_offset(2);
    }];
}


- (void)setModel:(YHKPIDetailModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
        
        [self refreshSubViewData];
    }
}

- (void)refreshSubViewData {
    self.titleLable.numberOfLines = 0;
    self.titleLable.text = self.model.title;
    self.valueLable.text = self.model.hightLightData.number;
    self.warnLable.text = self.model.hightLightData.compare;
    self.warnLable.backgroundColor = [self.model getMainColor];
    self.detailUtilLable.text = self.model.memo1;
    self.detailWarnLable.text = self.model.memo2;
    self.utilLable.text =self.model.unit;
}



@end
