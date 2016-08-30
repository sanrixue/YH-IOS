//
//  DashboardViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseViewController.h"

@interface DashboardViewController : BaseViewController<UITabBarDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSString *fromViewController;

/***  消息推送点击后操作 */
@property (assign, nonatomic) int clickTab;
@end
