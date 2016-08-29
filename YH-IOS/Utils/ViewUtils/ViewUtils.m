//
//  ViewUtils.m
//  iLogin
//
//  Created by lijunjie on 15/5/6.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import "ViewUtils.h"
#define RMB_WAN 10000
#define TIME_HOUR 60

@implementation ViewUtils

+ (void)simpleAlertView: delegate Title: (NSString*) title Message: (NSString*) message ButtonTitle: (NSString*) buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

+ (UIView *)loadNibClass:(Class)cls {
    UINib *nib=[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil];
    NSArray *views=[nib instantiateWithOwner:nil options:nil];
    return [views firstObject];
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  弹出框架显示临时性文字
 *
 *  @param view controller.view
 *  @param text 提示文字
 */
+ (void)showPopupView:(UIView *)view Info:(NSString*)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = text;
    hud.margin                    = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.5];
}

+ (void)showPopupView:(UIView *)view Info:(NSString*)text while:(void(^)(void))executeBlock {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode                      = MBProgressHUDModeText;
    hud.labelText                 = text;
    hud.margin                    = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    executeBlock();
    
    [hud hide:YES];
}

/**
 *  tableViewCell根据内容自定义高度
 *
 *  @param text     cell显示内容
 *  @param width    cell的宽度，以此自适应高度
 *  @param fontSize 内容字段大小
 *
 *  @return CGSize
 */
+ (CGSize) sizeForTableViewCell:(NSString *)text
                          Width:(NSInteger)width
                       FontSize:(NSInteger)fontSize {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50000)];
    textLabel.text=text;
    textLabel.numberOfLines=0;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:fontSize];
    [textLabel sizeToFit];
    CGRect rect = textLabel.frame;;
    return rect.size;
}

// 100000 元 => 10 万元
+ (NSDictionary *)dealWithMoney:(NSString *)nMoney {
    NSString *unit = @"元";
    NSInteger iMoney = [nMoney intValue];
    
    if (iMoney > RMB_WAN) {
        nMoney = [NSString stringWithFormat:@"%.1f", roundf(iMoney * 10 / RMB_WAN ) / 10];
        unit   = @"万元";
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:nMoney,@"nMoney",unit,@"unit", nil];
}

// 90 分钟 => 1.5 小时
+ (NSDictionary *)dealWithHour:(NSString *)nTime {
    NSString *unit = @"分钟";
    NSInteger iTime = [nTime intValue];
    
    if (iTime > TIME_HOUR) {
        nTime = [NSString stringWithFormat:@"%.1f", roundf(iTime * 10 / TIME_HOUR ) / 10];
        unit   = @"小时";
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:nTime,@"nTime",unit,@"unit", nil];
}

+ (NSString *)moneyformat:(int)num {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithInt: num]];
}

+ (NSString *)humanTimeInterval:(NSInteger)interval {
    NSString *humanSize = [NSString string];
    
    @try {
        NSInteger index = 0;
        NSArray *tokens = [NSArray arrayWithObjects:@"分钟",@"小时",@"天",nil];
        NSArray *intervals = [NSArray arrayWithObjects:@60, @60, @24, nil];
        
        while (interval > [intervals[index] integerValue]) {
            interval = interval / [intervals[index] integerValue];
        }
        humanSize = [NSString stringWithFormat:@"%li%@",(long)interval, tokens[index]];
    } @catch(NSException *e) {
        humanSize = [NSString stringWithFormat:@"%li%@",(long)interval, @"秒"];
    }
    
    return humanSize;
}

@end