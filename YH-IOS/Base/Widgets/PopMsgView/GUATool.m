//
//  GUATool.m
//  ShenghuoJia
//
//  Created by Guava on 15/12/16.
//  Copyright © 2015年 YongHui. All rights reserved.
//

#import "GUATool.h"
#import "CommonAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BaseNavigationController.h"
#import "MainTabbarViewController.h"
#import "UILabel+ContentSize.h"
#import "UILabel+Badge.h"

@interface GUATool ()
@property (nonatomic, strong) UIImageView* gifImageView;
@end

@implementation GUATool
/*
+(void)showDialog:(NSString*) title
          message:(NSString*) message
      waitingTime:(NSTimeInterval) time {
    UIView *view = CurAppDelegate.window;
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self settingHud:hud];
    hud.label.text = message;
    hud.transform = CGAffineTransformMakeScale(0.1, 0.1);
    hud.alpha = 0;
    [hud showAnimated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        hud.alpha = 1;
        hud.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
}

+ (void)showMessage:(NSString *)message waitingTime:(NSTimeInterval)time{
    [self showDialog:nil message:message waitingTime:time];
}

+ (MBProgressHUD*)settingHud:(MBProgressHUD*)hud{
    hud.backgroundColor = [UIColor clearColor];
    hud.backgroundView.backgroundColor = [UIColor clearColor];
    hud.bezelView.backgroundColor = RGB(10, 10, 10, 0.6);
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10;
    hud.label.backgroundColor = [UIColor clearColor];
    hud.label.font = [UIFont systemFontOfSize:13 weight:8];
    hud.label.numberOfLines = 0;
    hud.label.textColor = RGB(248, 248, 248, 1);
    hud.layer.shadowOpacity = 0.5;// 阴影透明度
    hud.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    hud.layer.shadowRadius = 3;// 阴影扩散的范围控制
    hud.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    hud.minSize = CGSizeMake(275, 40);//CGSizeMake(SCREEN_WIDTH-100, 40);
    return hud;
}

+ (void)showMessage:(NSString *)message needGif:(BOOL)need inView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    if (need) {
        hud.bezelView.backgroundColor = [UIColor whiteColor];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [self getGifImageView];
        hud.margin = 7;
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.layer.shadowOpacity = 0.5;// 阴影透明度
        hud.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        hud.layer.shadowRadius = 3;// 阴影扩散的范围控制
        hud.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
        [hud.bezelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
        [hud showAnimated:YES];
    }else{
        [self settingHud:hud];
        hud.transform = CGAffineTransformMakeScale(0.1, 0.1);
        hud.alpha = 0;
        [hud showAnimated:NO];
        [UIView animateWithDuration:0.3 animations:^{
            hud.alpha = 1;
            hud.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }

}

+ (void)showMessage:(NSString *)message needGif:(BOOL)need inView:(UIView *)view afterTime:(NSTimeInterval)time showTime:(NSTimeInterval)showTime{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMessage:message needGif:need inView:view];
        if (showTime>0) {
            [self hideHUDInView:view afterTime:showTime];
        }
    });
}

+ (void)hideHUDInView:(UIView *)view afterTime:(NSTimeInterval)time{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:NO];
    });
}

//+(void)showDialog:(NSString*) title
//          message:(NSString*) message
//      waitingTime:(NSTimeInterval) time {
//    [CurAppDelegate.window setUserInteractionEnabled:0];
//    CommonAlertView *alertView = [[CommonAlertView alloc] init];
//    [alertView showWithTitle:title message:message time:time inView:[AppDelegate shareAppdelegate].window];
//}

+ (CGFloat)calculateLabelHeightWithWidth:(CGFloat) widthOfLabel
                            contentText:(NSString *) content
                                   font:(UIFont *)contentFont
{
    CGRect frame = [content boundingRectWithSize:CGSizeMake(widthOfLabel, 100)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:contentFont}
                                         context:nil];
    return frame.size.height;
}

+(CGFloat)calculateLabelWidthWithHeight:(CGFloat) heightOfLabel
                            contentText:(NSString *) content
{
    return 0;
}

+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

+ (BOOL)simpleYHCard:(NSString *)num {
    NSString *pattern = @"^\\d{13}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:num];
}

+(BOOL)simpleCellphoneNumberCheck:(NSString *)cellNumber {
    NSString *pattern = @"^[1-9]\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:cellNumber];
}

+ (BOOL)haveHUDInView:(UIView*)view{
    for (MBProgressHUD *hud in view.subviews) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            return YES;
        }
    }
    return NO;
}

+ (void)showGifImageHUDInView:(UIView*)view{
//    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    if (view == nil) {
        view = CurAppDelegate.window;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [self getGifImageView];
    hud.margin = 7;
    hud.label.text = @"努力加载中...";
    hud.label.font = [UIFont systemFontOfSize:12];
    hud.layer.shadowOpacity = 0.5;// 阴影透明度
    hud.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    hud.layer.shadowRadius = 3;// 阴影扩散的范围控制
    hud.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    [hud.bezelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
//    [hud.customView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(hud.bezelView);
//    }];
    [hud showAnimated:YES];
}

+ (UIImageView *)getGifImageView{
        UIImageView* gifImageView = [[UIImageView alloc] init];
//        NSMutableArray *imageArr = [NSMutableArray new];
//        for (int i=0; i<79; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"分针动画_000%zd",i]];
//            [imageArr addObject:image];
//        }
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 0; i<=23; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_000%zd", i+10]];
            [idleImages addObject:image];
        }
        gifImageView.animationImages = idleImages;
        gifImageView.animationDuration = 1.5;// 3
        [gifImageView startAnimating];
    return gifImageView;
}

+ (void)hideGifImageHUDInView:(UIView*)view{
    if (view == nil) {
        view = CurAppDelegate.window;
    }
    [MBProgressHUD hideHUDForView:view animated:NO];
}

+ (void)hideAllGifImageHUD{
    for (MBProgressHUD *hud in CurAppDelegate.window.subviews) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            [hud hideAnimated:YES];
        }
    }
//    for (MBProgressHUD *hud in RootNavigationController.topViewController.view.subviews) {
//        if ([hud isKindOfClass:[MBProgressHUD class]]) {
//            [hud hideAnimated:YES];
//        }
//    }
//    for (MBProgressHUD *hud in RootTabbarViewConTroller.view.subviews) {
//        if ([hud isKindOfClass:[MBProgressHUD class]]) {
//            [hud hideAnimated:YES];
//        }
//    }
//    for (MBProgressHUD *hud in RootNavigationController.view.subviews) {
//        if ([hud isKindOfClass:[MBProgressHUD class]]) {
//            [hud hideAnimated:YES];
//        }
//    }
}
*/
@end
