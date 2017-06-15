//
//  PhotoRevealCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "PhotoRevealCell.h"
#import "PhotoManagerConfig.h"


@interface PhotoRevealCell ()


@end


@implementation PhotoRevealCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingUI];
        [self layoutUI];
    }
    return self;
}

- (void)buildingUI {
    self.imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = kPlaceholderImageColor;
    [self addSubview:_imageView];
}

- (void)layoutUI {
    WeakSelf(self)
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(weakSelf);
    }];
}

- (void)reloadDataWithImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)reloadDataWithString:(NSString *)imagestring{
    [self.imageView sd_setImageWithURL:imagestring];
}


@end
