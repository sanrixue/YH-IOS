//
//  DashboardViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController<UIWebViewDelegate, UITabBarDelegate>
@property (strong, nonatomic) NSNumber *tabBarItemIndex;
@end
