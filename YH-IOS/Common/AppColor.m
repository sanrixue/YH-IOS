//
//  AppColor.m
//  Chart
//
//  Created by ice on 16/5/17.
//  Copyright © 2016年 ice. All rights reserved.
//

#import "AppColor.h"

@implementation AppColor

+ (UIColor *)tabbarTintColor {
    return [self oneColor];
}

+ (UIColor *)navBackgroudColor {
    return RGB(241, 241, 241, 1);
}

+ (UIColor *)bordColor{
    return UIColorHex(BFBFBF);
}

+ (UIColor *)textColor{
    return [UIColor colorWithHexString:@"252525"];
}

+ (UIColor *)textGrayColor{
    return [UIColor colorWithHexString:@"7d7d7d"];
}

+ (UIColor *)grayBackgroudColor{
    return [UIColor colorWithHexString:@"f2f2f2"];
}

+ (UIColor *)lightGreen {
    return [UIColor colorWithRed:28/255.0 green:186/255.0 blue:97/255.0 alpha:.5];
}

+ (UIColor *)oneColor{
    return [UIColor colorWithHexString:@"54B59A"];
}

+ (UIColor *)twoColor{
    return [self textColor];
}

+ (UIColor *)threeColor{
    return [UIColor colorWithHexString:@"#bdc0c5"];
}

+ (UIColor *)fourColor{
    return [UIColor colorWithHexString:@"ffffff"];
}

+ (UIColor *)fiveColor{
    return [UIColor colorWithHexString:@"f6f6f6"];
}

+ (UIColor *)sixColor{
    return [UIColor colorWithHexString:@"dddddd"];
}

+ (UIColor *)sevenColor{
    return [UIColor colorWithHexString:@"b3b3b3"];
}
+ (UIColor *)eightColor{
    return [UIColor colorWithHexString:@"ea6e85"];
}
+ (UIColor *)nineColor{
    return [UIColor colorWithHexString:@"fdbd37"];
}
+ (UIColor *)tenColor{
    return [UIColor colorWithHexString:@"f59975"];
}


+(UIColor *)navigationBarBackgroundColor
{
    return [UIColor colorWithRed:191/255.0 green:159/255.0 blue:98/255.0 alpha:1];
}

+ (UIColor *)app_1color{
    return UIColorHex(51aa38);
}
+ (UIColor *)app_2color{
    return UIColorHex(91c941);
}
+ (UIColor *)app_3color{
    return UIColorHex(595b57);
}
+ (UIColor *)app_4color{
    return UIColorHex(bcbcbc);
}
+ (UIColor *)app_5color{
    return UIColorHex(393f42);
}
+ (UIColor *)app_6color{
    return UIColorHex(32414b);
}
+ (UIColor *)app_7color{
    return UIColorHex(eeeff1);
}
+ (UIColor *)app_8color{
    return UIColorHex(f8f8f8);
}
+ (UIColor *)app_9color{
    return UIColorHex(e6e6e6);
}
+ (UIColor *)app_10color{
    return UIColorHex(ffffff);
}
+ (UIColor *)app_11color{
    return UIColorHex(f57658);
}
+ (UIColor *)app_12color{
    return UIColorHex(f4bc45);
}
+ (UIColor *)app_13color{
    return UIColorHex(3cc7c9);
}
+ (UIColor *)app_14color{
    return UIColorHex(71a3ed);
}
+ (UIColor *)app_15color{
    return UIColorHex(4688b5);
}
+ (UIColor *)app_16color{
    return UIColorHex(a984d3);
}
+ (UIColor *)app_17color{
    return UIColorHex(f44f4f);
}


@end
