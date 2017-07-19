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
}

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) JYBlockButton *btn;

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
    title.textColor = JYColor_TextColor_Chief;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), (CGRectGetHeight(self.bounds) - 12) / 2.0, 6, 12)];
    _icon.image = [UIImage imageNamed:@"icon_sort"];
    _icon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_icon];
    
    __weak typeof(self) weakSelf = self;
    _btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = self.bounds;
    [_btn setHandler:^(BOOL isSelected) {
        
        if (weakSelf.inverHandler) {
            weakSelf.inverHandler(weakSelf.typeName, isSelected);
        }
        weakSelf.icon.image = [UIImage imageNamed:@"icon_array"];
        if (isSelected) {
            weakSelf.icon.layer.transform = CATransform3DIdentity;
        }
        else {
            weakSelf.icon.layer.transform = CATransform3DMakeRotation(-M_PI, 0, 0, 1);
        }
    }];
    [self addSubview:_btn];
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
    
    CGRect frame = self.icon.frame;
    frame.origin.x = CGRectGetMaxX(title.frame) + JYDefaultMargin / 2.0;
    self.icon.frame = frame;
}

- (void)recoverIconTransform {
    self.icon.image = [UIImage imageNamed:@"icon_sort"];
    self.btn.selected = NO;
    self.icon.layer.transform = CATransform3DIdentity;
}

@end
