//
//  JYCollectionFooterView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "JYCollectionFooterView.h"

@implementation JYCollectionFooterView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
        //self.backgroundColor = [UIColor redColor];
        [self layoutSepView];
    }
    return self;
}


-(void)layoutSepView {
    UIView *topwhiteView = [[UIView alloc]initWithFrame:CGRectMake(8,0 ,SCREEN_WIDTH - 16, 4)];
    topwhiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topwhiteView];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8,4 ,SCREEN_WIDTH - 16, 1.5)];;
    view.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
    [self addSubview:view];
}

@end
