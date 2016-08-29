//
//  AppDelegate.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/***  是否允许横屏的标记 */
@property (nonatomic,assign) BOOL allowRotation;
@property(nonatomic,strong)NSMutableDictionary *pushMessageDict;
@property(nonatomic,assign)int clickTab;

@end

