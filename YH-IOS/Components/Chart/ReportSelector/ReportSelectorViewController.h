//
//  ReportSelectorViewController.h
//  YH-IOS
//
//  Created by lijunjie on 16/7/15.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWebViewController.h"

@interface ReportSelectorViewController : BaseWebViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *bannerName;
@property (strong, nonatomic) NSNumber *groupID;
@property (strong, nonatomic) NSString *reportID;
@property (strong, nonatomic) NSString *templateID;
@end
