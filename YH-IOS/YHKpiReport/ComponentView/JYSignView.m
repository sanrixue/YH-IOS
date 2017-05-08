//
//  JYFreezeView.m
//  JYFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "JYSignView.h"

@interface JYSignView ()

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation JYSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, frame.size.width - 7, frame.size.height / 2)];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

@end
