//
//  ViewController.h
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "BaseWebViewController.h"
#import "Constant.h"
#import "User.h"
#import "HttpUtils.h"
#import "APIHelper.h"
#import "FileUtils+Assets.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>
#import "UIColor+Hex.h"
#import "UIWebview+Clean.h"
#import "LTHPasscodeViewController.h"
#import "ExtendNSLogFunctionality.h"




@interface LoginViewController : UIViewController

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField *userPasswordText;
@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UIButton *findPassword;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

- (void)loginBtnClick;

@end

