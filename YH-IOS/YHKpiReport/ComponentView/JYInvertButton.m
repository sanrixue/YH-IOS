//
//  JYInvertButton.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYInvertButton.h"
#import "JYBlockButton.h"

@interface JYInvertButton () {
    UILabel *title;
    UIImageView *icon;
}

@end

@implementation JYInvertButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubView];
    }
    
    return self;
}

- (void)initializeSubView {
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.bounds) - 30) / 2.0, 60, 30)];
    title.text = @"增长率";
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), (CGRectGetHeight(self.bounds) - 10) / 2.0, 10, 10)];
    icon.image = [UIImage imageNamed:@"down_greenarrow"];
    icon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:icon];
    
    
    JYBlockButton *btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    [btn setHandler:^(BOOL isSelected) {
        if (self.inverHandler) {
            self.inverHandler(self.typeName);
        }
        
        if (isSelected) {
            icon.layer.transform = CATransform3DMakeRotation(-M_PI, 0, 0, 1);
        }
        else {
            icon.layer.transform = CATransform3DIdentity;
        }
    }];
    [self addSubview:btn];
}

- (void)setTypeName:(NSString *)typeName {
    if (![_typeName isEqualToString:typeName]) {
        _typeName = typeName;
    }
    CGSize size = [typeName boundingRectWithSize:CGSizeMake(100, 30) options:0 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    CGRect titleBound = title.bounds;
    titleBound.size.width = size.width;
    title.bounds = titleBound;
    title.text = typeName;
    
    CGRect frame = icon.frame;
    frame.origin.x = CGRectGetMaxX(title.frame) + JYDefaultMargin / 2.0;
    icon.frame = frame;
}

@end
