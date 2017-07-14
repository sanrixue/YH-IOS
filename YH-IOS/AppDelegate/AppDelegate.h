//
//  AppDelegate.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CurAppDelegate [AppDelegate shareAppdelegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/***  是否允许横屏的标记 */
@property (nonatomic, assign) BOOL allowRotation;
+ (AppDelegate*)shareAppdelegate;

@end

