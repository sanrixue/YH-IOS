//
//  NewLoginViewController.m
//  YH-IOS
//
//  Created by li hao on 16/8/4.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "APIHelper.h"
#import "NSString+MD5.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "UMessage.h"
#import "Version.h"
#import "UIColor+Hex.h"

#define WIDTHINPUT CGRectGetWidth(self.userInfoBackView.frame) - 100
#define USERHEIGHT self.view.frame.size.height * 2/7
@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *loginUserImage;
@property (nonatomic, strong) UITextField *userNameText;
@property (nonatomic, strong) UIView *seperateView1;
@property (nonatomic, strong) UIImageView *loginPasswordImage;
@property (nonatomic, strong) UITextField *userPasswordText;
@property (nonatomic, strong) UIView *seperateView2;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIView *userInfoBackView;
@property (nonatomic, strong) Version *version;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.bgView.image = [UIImage imageNamed:@"ip6"];
    [self.view addSubview:self.bgView];
    self.bgView.userInteractionEnabled = YES;

    //userInfoBackView
    self.userInfoBackView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height / 2 + 60, self.view.frame.size.width - 80, USERHEIGHT)];
    self.userInfoBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.userInfoBackView.layer.cornerRadius = 8;
    self.userInfoBackView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.userInfoBackView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userinfomoveToTop)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userinfoMoveToBottom)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //versionLabel
    self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.view.frame.size.height - 30, self.view.frame.size.width - 240, 20)];
    self.version = [[Version alloc] init];
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.font = [UIFont systemFontOfSize:12];
    self.versionLabel.text = [NSString stringWithFormat:@"i%@(%@)", self.version.current, self.version.build];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:self.versionLabel];
    
    // userName
    self.loginUserImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user"]];
    [self.userInfoBackView addSubview:self.loginUserImage];
    
    UIColor *placeHoderColor = [UIColor whiteColor];
    
    self.userNameText = [[UITextField alloc] initWithFrame:CGRectMake(60, 18,WIDTHINPUT, 30)];
    self.userNameText.textAlignment = NSTextAlignmentCenter;
    //self.userNameText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"帐户名" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
    self.userNameText.borderStyle = UITextBorderStyleNone;
    self.userNameText.delegate = self;
    self.userNameText.textColor = [UIColor whiteColor];
    self.userNameText.userInteractionEnabled = YES;
    self.userNameText.returnKeyType = UIReturnKeyDone;
    [self.userNameText becomeFirstResponder];
    [self.userInfoBackView addSubview:self.userNameText];
    
    self.seperateView1 = [[UIView alloc] initWithFrame:CGRectMake(60, 49,WIDTHINPUT, 1)];
    self.seperateView1.backgroundColor = [UIColor whiteColor];
    [self.userInfoBackView addSubview:self.seperateView1];
    
    // userPassword
    self.loginPasswordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    [self.userInfoBackView addSubview:self.loginPasswordImage];
    self.userPasswordText = [[UITextField alloc] init];
    [self.userInfoBackView addSubview:self.userPasswordText];
    self.userPasswordText.frame = CGRectMake(60, 55, WIDTHINPUT, 30);
    self.userPasswordText.textAlignment = NSTextAlignmentCenter;
    self.userPasswordText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userPasswordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
    self.userPasswordText.secureTextEntry = YES;
    self.userPasswordText.delegate = self;
    [self.userPasswordText setTextColor:[UIColor whiteColor]];
    self.userPasswordText.returnKeyType = UIReturnKeyDone;
    self.userPasswordText.userInteractionEnabled = YES;
    self.userPasswordText.borderStyle = UITextBorderStyleNone;
    self.userPasswordText.clearButtonMode = UITextFieldViewModeAlways;
    
    self.seperateView2 = [[UIView alloc] initWithFrame:CGRectMake(60, 91, WIDTHINPUT, 1)];
    self.seperateView2.backgroundColor = [UIColor whiteColor];
    [self.userInfoBackView addSubview:self.seperateView2];
    self.loginPasswordImage.frame = CGRectMake(30, CGRectGetMaxY(self.seperateView2.frame) - 20, 20, 20);
    self.loginUserImage.frame = CGRectMake(30, CGRectGetMaxY(self.seperateView1.frame) - 20, 20, 20);
    // loginButton
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.userPasswordText.frame) + 30, WIDTHINPUT, 30)];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.borderWidth = 0;
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"99C28C"];
    [self.loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.userInfoBackView addSubview:self.loginButton];

}

- (void)userinfomoveToTop {
    self.userInfoBackView.frame = CGRectMake(40, 80, self.view.frame.size.width - 80, USERHEIGHT);
}

- (void)userinfoMoveToBottom {
    self.userInfoBackView.frame = CGRectMake(40, self.view.frame.size.height / 2 + 60, self.view.frame.size.width - 80, USERHEIGHT);
}

//add: 登录按钮事件
- (void)loginBtnClick {
    if (self.userNameText.text.length == 0) {
        [self showProgressHUD:@"请输入用户名 " mode: MBProgressHUDModeText];
        [self.progressHUD hide:YES afterDelay:1.5];
        return;
    }
    if (self.userPasswordText.text.length == 0) {
        [self showProgressHUD:@"请输入密码 " mode: MBProgressHUDModeText];
        [self.progressHUD hide:YES afterDelay:1.5];
        return;
    }
    [self showProgressHUD:@"验证中"];
    NSString *msg = [APIHelper userAuthentication:self.userNameText.text password:self.userPasswordText.text.md5];
    [self.progressHUD hide:YES];
    
    if (!(msg.length == 0)) {
        [self showProgressHUD:msg mode:MBProgressHUDModeText];
        [self.progressHUD hide:YES afterDelay:2.0];
        return;
    }
    
    [self showProgressHUD:@"跳转中"];
    [self jumpToDashboardView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//跳转到仪表盘页面
- (void)jumpToDashboardView {
    UIWindow *window = self.view.window;
    LoginViewController *previousRootViewController = (LoginViewController *)window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    dashboardViewController.fromViewController = @"LoginViewController";
    window.rootViewController = dashboardViewController;   
    // Nasty hack to fix http://stackoverflow.com/questions/26763020/leaking-views-when-changing-rootviewcontroller-inside-transitionwithview
    // The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:self.class]) {
            [subview removeFromSuperview];
        }
    }
    // Allow the view controller to be deallocated
    [previousRootViewController dismissViewControllerAnimated:NO completion:^{
        // Remove the root view in case its still showing
        [previousRootViewController.view removeFromSuperview];
    }];
}

- (void)showProgressHUD:(NSString *)text {
    [self showProgressHUD:text mode:MBProgressHUDModeIndeterminate];
}

- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.bgView animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.mode = mode;
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

#pragma mark - 缓存当前应用版本，每次检测，不一致时，有所动作
- (void)checkVersionUpgrade:(NSString *)assetsPath {
    NSDictionary *bundleInfo       =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion       = bundleInfo[@"CFBundleShortVersionString"];
    NSString *versionConfigPath    = [NSString stringWithFormat:@"%@/%@", assetsPath, kCurrentVersionFileName];
    
    BOOL isUpgrade = YES;
    NSString *localVersion = @"no-exist";
    if([FileUtils checkFileExist:versionConfigPath isDir:NO]) {
        localVersion = [NSString stringWithContentsOfFile:versionConfigPath encoding:NSUTF8StringEncoding error:nil];
        
        if(localVersion && [localVersion isEqualToString:currentVersion]) {
            isUpgrade = NO;
        }
    }
    
    if(isUpgrade) {
        NSLog(@"version modified: %@ => %@", localVersion, currentVersion);
        NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", assetsPath, kCachedDirName];
        [FileUtils removeFile:cachedHeaderPath];
        NSLog(@"remove header: %@", cachedHeaderPath);
        
        [currentVersion writeToFile:versionConfigPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        // 消息推送，重新上传服务器
        NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
        NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
        pushDict[@"push_valid"] = @(NO);
        [pushDict writeToFile:pushConfigPath atomically:YES];
    }
}

# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
