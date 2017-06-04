//
//  GifRefreshHeader.m
//  JinXiaoEr
//
//  Created by CJG on 16/12/29.
//
//

#import "GifRefreshHeader.h"

@interface GifRefreshHeader ()

@end

@implementation GifRefreshHeader

+ (instancetype)instanceWithTarget:(id)target selector:(SEL)selector{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    GifRefreshHeader *header = [GifRefreshHeader headerWithRefreshingTarget:target refreshingAction:selector];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    return header;
}

- (UIImageView *)animationView{
    if (!_animationView) {
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 0; i<=23; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_000%zd", i+10]];
            [idleImages addObject:image];
        }
        _animationView = [[UIImageView alloc] init];
        _animationView.animationImages = idleImages;
        _animationView.animationDuration = 1.5;
        _animationView.animationRepeatCount = 0;
        [self addSubview:_animationView];
        [self.animationView startAnimating];
    }
    return _animationView;
}

- (void)prepare
{
    [super prepare];
    self.mj_h = 60;//60*Device_Scale+20;
    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 0; i<=23; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_000%zd", i+10]];
//        [idleImages addObject:image];
//    }
//    
//    NSMutableArray *pull = [NSMutableArray array];
//    for (NSUInteger i = 0; i<=23; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_000%zd", i+10]];
//        [pull addObject:image];
//    }
//    
//    
//    [self setImages:pull forState:MJRefreshStateIdle];
//
//    
//    [self setImages:idleImages forState:MJRefreshStatePulling];
//    
//    // 设置正在刷新状态的动画图片
//    [self setImages:idleImages forState:MJRefreshStateRefreshing];
//    
//    [self setImages:idleImages forState:MJRefreshStateWillRefresh];
}

//- (void)setImages:(NSArray *)images forState:(MJRefreshState)state{
//    if (state == MJRefreshStateRefreshing) {
//        [self setImages:images duration:1.5 forState:state];
//    }else{
//        [self setImages:images duration:1.5 forState:state];
//    }
//}

//- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state{
//    [super setImages:images duration:duration forState:state];
//    self.mj_h = 60*Device_Scale+20;
//}

- (void)placeSubviews{
    [super placeSubviews];
    self.gifView.hidden = YES;
    self.gifView.alpha = 0;
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
//        make.height.mas_equalTo(60*Device_Scale);
//        make.width.mas_equalTo(76*Device_Scale);
        make.width.height.mas_equalTo(0.1);
    }];;
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(60);//*Device_Scale);
        make.width.mas_equalTo(76);//*Device_Scale);
    }];
}

- (void)endRefreshing{
    [super endRefreshing];
}

- (void)setState:(MJRefreshState)state{
    [super setState:state];
}



@end
