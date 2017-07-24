//
//  RefreshToolDownPullHeader.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RefreshToolDownPullHeader.h"

@interface RefreshToolDownPullHeader ()

@property (nonatomic, strong) UIImageView* loadingImageV;
@property (nonatomic, strong) CABasicAnimation* animation;

@end

@implementation RefreshToolDownPullHeader


- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    static NSString* animationKey = @"旋转";
    switch (state) {
        case MJRefreshStateIdle:
            [_loadingImageV.layer removeAnimationForKey:animationKey];
            break;
        case MJRefreshStatePulling:
            if (![_loadingImageV.layer animationForKey:animationKey]) {
                [_loadingImageV.layer addAnimation:self.animation forKey:animationKey];
            }
            break;
        case MJRefreshStateRefreshing:
            if (![_loadingImageV.layer animationForKey:animationKey]) {
                [_loadingImageV.layer addAnimation:self.animation forKey:animationKey];
            }
            break;
        default:
            break;
    }
}


- (void)prepare{
    [super prepare];
    self.mj_h = 60.0;
    [self addSubview:self.loadingImageV];
//    [_loadingImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//    }];
}

- (void)placeSubviews{
    [super placeSubviews];
    CGSize imageSize = self.loadingImageV.image.size;
    self.loadingImageV.frame = CGRectMake((self.mj_w-imageSize.width)*0.5, (self.mj_h-imageSize.height)*0.5, imageSize.width, imageSize.height);
}


#pragma mark - lazy init
- (UIImageView *)loadingImageV{
    if (!_loadingImageV) {
        _loadingImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        [_loadingImageV sizeToFit];
    }
    return _loadingImageV;
}

- (CABasicAnimation *)animation{
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _animation.fromValue = [[NSNumber alloc] initWithFloat:0];
        _animation.toValue = [[NSNumber alloc] initWithFloat:M_PI*2.0];
        _animation.duration = 1;
        _animation.autoreverses = false;
        _animation.fillMode = kCAFillModeForwards;
        _animation.repeatCount = MAXFLOAT;
    }
    return _animation;
}

@end
