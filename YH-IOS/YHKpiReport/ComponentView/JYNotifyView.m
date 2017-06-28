//
//  JYNotifyView.m
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYNotifyView.h"
#import "NSTimer+JYTimer.h"


@interface JYNotifyView () <UIScrollViewDelegate> {
    UIScrollView *sc;
    UIImageView *imageTitleView;
    NSTimer *timer;
    NSInteger idx;
    NSInteger ntCount;
}

@end

@implementation JYNotifyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        idx = 1;
        
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 0.8;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%d -- %s", __LINE__, __func__);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self initilizeNotifications];
}

- (void)initilizeNotifications {
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    ntCount = self.notifications.count + 2;
    
    imageTitleView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 30, 30)];
    [self addSubview:imageTitleView];
    imageTitleView.image = [[UIImage imageNamed:@"data_title"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    sc = [[UIScrollView alloc] initWithFrame:CGRectMake(65, 10, self.bounds.size.width-65, 20)];
    sc.pagingEnabled = YES;
    sc.showsVerticalScrollIndicator = NO;
    sc.delegate = self;
    CGFloat height = CGRectGetHeight(sc.bounds);
    CGFloat wight = CGRectGetWidth(sc.bounds) - 8 * 2 - 15;
    for (int i = 0; i < ntCount; i++) {
        
        UILabel *imglb = [[UILabel alloc]initWithFrame:CGRectMake(0, height * i + height, 30, height)];
        imglb.text = @"推荐";
        imglb.textAlignment = NSTextAlignmentCenter;
        imglb.textColor = [UIColor colorWithHexString:@"#f39800"];
        imglb.layer.cornerRadius = 2;
        imglb.layer.borderColor = [UIColor colorWithHexString:@"#f39800"].CGColor;
        imglb.layer.borderWidth = 1;
        imglb.font = [UIFont systemFontOfSize:10];
        [sc addSubview:imglb];
        
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(36, height * i, wight, height)];
        lb.font = [UIFont systemFontOfSize:13];
        lb.textColor = [UIColor colorWithHexString:@"999"];
        [sc addSubview:lb];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(8, height * i, wight, height);
        [btn addTarget:self action:@selector(selectedNotify:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            lb.text = self.notifications[ntCount - 2 - 1];
        }
        else if (i == ntCount - 1) {
            lb.text = self.notifications[0];
        }
        else {
            lb.text = self.notifications[i - 1];
            btn.tag = -10000 + (i - 1);
            [btn addTarget:self action:@selector(selectedNotify:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (self.notifyColor) {
            lb.textColor = self.notifyColor;
        }
        [sc addSubview:btn];
    }
    sc.contentSize = CGSizeMake(CGRectGetWidth(sc.bounds), height * ntCount);
    sc.contentOffset = CGPointMake(0, height);
    [self addSubview:sc];
    
    UIButton *closeNotify = [UIButton buttonWithType:UIButtonTypeCustom];
    closeNotify.frame = CGRectMake(wight, (height - 30) / 2.0, 30, 30);
    [closeNotify setTitle:@"ㄨ" forState:UIControlStateNormal];
    [closeNotify addTarget:self action:@selector(closeNotifyView:) forControlEvents:UIControlEventTouchUpInside];
   // [self addSubview:closeNotify];
    if (self.closeBtnColor) {
        [closeNotify setTitleColor:self.closeBtnColor forState:UIControlStateNormal];
    }
    
    if (self.interval) {
        __weak typeof(self) weakSelf = self;
        NSTimeInterval interval = self.interval ?: 5.0;
        timer = [NSTimer invocationWithTimeInterval:interval repeats:YES block:^{
            __strong typeof(weakSelf) inStrongSelf = weakSelf;
            [inStrongSelf refreshNotifyView];
        }];
    }
}

- (void)setNotifications:(NSArray<NSString *> *)notifications {
    
    if ([_notifications isEqual:notifications]) return;
    _notifications = notifications;
    
    [self setNeedsDisplay];
}

- (void)setCloseBtnColor:(UIColor *)closeBtnColor {
    if ([_closeBtnColor isEqual:closeBtnColor]) return;
    _closeBtnColor = closeBtnColor;
    [self setNeedsDisplay];
}
/* 默认无，当设置时，自动实现动画效果 */
- (void)setNotifyColor:(UIColor *)notifyColor {
    if ([_notifyColor isEqual:notifyColor]) return;
    _notifyColor = notifyColor;
    [self setNeedsDisplay];
}

- (void)setDrawable:(BOOL)drawable {
    _drawable = drawable;
    sc.scrollEnabled = _drawable;
}

- (void)setInterval:(NSTimeInterval)interval {
    [super setInterval:interval];
    
    [self setNeedsDisplay];
}

- (void)refreshNotifyView {
    
    idx = (idx >= (ntCount - 2) ? 1 : ++idx);
    [UIView animateWithDuration:0.5 animations:^{
        sc.contentOffset = CGPointMake(0, idx * CGRectGetHeight(sc.bounds));
    }];    
}

- (void)closeNotifyView:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeNotifyView:)]) {
        [self.delegate closeNotifyView:self];
    }
    [self removeFromSuperview];
}

- (void)selectedNotify:(UIButton *)sender {
    NSInteger tag = sender.tag + 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(notifyView:didSelected:selectedData:)]) {
        [self.delegate notifyView:self didSelected:tag selectedData:self.notifications[tag]];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGPoint currentOffset = scrollView.contentOffset;
    idx = currentOffset.y / CGRectGetHeight(scrollView.bounds)/2;
    
    [timer setFireDate:[NSDate date]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y == 0) {
        scrollView.contentOffset = CGPointMake(0, (ntCount - 2) * CGRectGetHeight(sc.bounds));
    }
    if (currentOffset.y == ((ntCount - 1) * CGRectGetHeight(sc.bounds))) {
        scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(scrollView.bounds));
    }
    idx = currentOffset.y / CGRectGetHeight(scrollView.bounds)/2;
}

@end
