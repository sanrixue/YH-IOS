//
//  JYSigleValueView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/20.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "JYSigleValueView.h"

@implementation JYSigleValueView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
        
    }
    [self layoutAllSubView];
    return self;
}

-(void)layoutAllSubView{
    
    //self.backgroundColor = [UIColor redColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"#bdbdbd"].CGColor;
    self.layer.cornerRadius = 4;
    //添加标题视图
    self.titleLable = [UILabel new];
    self.titleLable.textColor = [UIColor colorWithHexString:@"#000"];
    self.titleLable.font = [UIFont systemFontOfSize:16];
    self.titleLable.text = @"蔬果销售预警";
    self.titleLable.numberOfLines = 0;
    self.titleLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLable];
    
    //添加值
    self.valueLable = [UILabel new];
    self.valueLable.font = [UIFont systemFontOfSize:15];
    self.valueLable.textAlignment = NSTextAlignmentLeft;
    self.valueLable.text = @"12890";
    [self addSubview:_valueLable];
    
    //添加单位
    self.utilLable = [UILabel new];
    self.utilLable.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    self.utilLable.font = [UIFont systemFontOfSize:7];
    self.utilLable.textAlignment = NSTextAlignmentLeft;
    self.utilLable.text = @"万元";
    [self addSubview:_utilLable];
    
    self.warnLable = [UILabel new];
    self.warnLable.textColor = [UIColor colorWithHexString:@"#333"];
    self.warnLable.font = [UIFont systemFontOfSize:9];
    self.warnLable.textAlignment = NSTextAlignmentLeft;
    self.warnLable.text = @"当前10项负毛利过高预警";
    [self addSubview:_warnLable];
    
    
    self.rateLable = [UILabel new];
    self.rateLable.text = @"-0.77";
    self.rateLable.font = [UIFont systemFontOfSize:20];
    self.rateLable.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rateLable];
    
    self.warnIamgeView = [UIImageView new];
    self.warnIamgeView.image = [UIImage imageNamed:@"ic_red_sign"];
    self.warnIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_warnIamgeView];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(10);
        make.left.equalTo(self.mas_left).mas_offset(10);
        make.right.equalTo(self.mas_right).mas_offset(-1);
        make.bottom.equalTo(self.valueLable.mas_top).mas_offset(-12);
        make.height.equalTo(@40);
    }];
    
    [self.valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).mas_offset(12);
        make.left.equalTo(self.titleLable.mas_left).mas_offset(0);
        make.right.equalTo(self.utilLable.mas_left).mas_offset(-6);
        make.bottom.equalTo(self.warnLable.mas_top).mas_offset(-13);
        //make.width.equalTo(@50);
        make.height.lessThanOrEqualTo(@17);
    }];
    
    [self.utilLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.valueLable.mas_bottom).mas_offset(-2);
        make.width.equalTo(@15);
       // make.height.equalTo(self.valueLable.mas_height);
    }];
    
    [self.rateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(58);
        make.right.equalTo(self.mas_right).mas_offset(-10);
       // make.left.equalTo(self.utilLable.mas_right).mas_offset(10);
        make.bottom.equalTo(@[self.valueLable.mas_bottom,self.utilLable.mas_bottom]);
    }];
    
    [self.warnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.utilLable.mas_bottom).mas_offset(13);
        make.left.equalTo(self.mas_left).mas_offset(22);
        make.right.equalTo(self.mas_right).mas_offset(-10);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-11);
    }];
    
    [self.warnIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(self.utilLable.mas_top).mas_offset(15);
        make.left.equalTo(self.mas_left).mas_offset(10);
        make.centerY.equalTo(self.warnLable.mas_centerY).mas_offset(0);
      //  make.width.equalTo(@3);
        make.right.equalTo(self.warnLable.mas_left).mas_offset(-5);
        //make.bottom.equalTo(self.warnLable.mas_bottom).mas_offset(0);
    }];
}


- (void)setModel:(YHKPIDetailModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
        
        [self refreshSubViewData];
    }
}

- (void)refreshSubViewData {
    self.titleLable.text = self.model.title;
    self.valueLable.textColor = [self.model getMainColor];
    self.valueLable.text = self.model.hightLightData.number;
    self.warnLable.text = self.model.memo1;
    self.utilLable.text = self.model.unit;
    self.rateLable.textColor=[self.model getMainColor];
    self.rateLable.text =self.model.hightLightData.compare;
}

@end
