//
//  DashboardViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/25.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseViewController.h"
#import "QRCodeReaderViewController.h"

@interface DashboardViewController : BaseViewController<UITabBarDelegate, QRCodeReaderDelegate>
@property (strong, nonatomic) NSString *fromViewController;
@end
