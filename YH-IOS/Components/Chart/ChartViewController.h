//
//  ChartViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *bannerName;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSNumber *dashBoardTabBarItemIndex;
@end
