//
//  JYBaseViewController.h
//  YH-IOS
//
//  Created by li hao on 17/5/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtils.h"
#import "APIHelper.h"
#import "FileUtils+Assets.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"

@interface JYBaseViewController : UIViewController<DropViewDataSource,DropViewDelegate,UIPopoverPresentationControllerDelegate>

@end
