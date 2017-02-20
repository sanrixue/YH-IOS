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
#import "FindPasswordViewController.h"

#define kSloganHeight [[UIScreen mainScreen]bounds].size.height / 6

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *sloganLabel;
@property (nonatomic, strong) UIImageView *loginUserImage;
@property (nonatomic, strong) UIView *seperateView1;
@property (nonatomic, strong) UIImageView *loginPasswordImage;
@property (nonatomic, strong) UIView *seperateView2;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, assign) int sideblank;
@property (nonatomic, strong) Version *version;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.bgView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:self.bgView];
    self.bgView.userInteractionEnabled = YES;
    // logoView
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login-Logo"]];
    self.logoView.contentMode = UIViewContentModeScaleToFill;
    [self.bgView addSubview:self.logoView];
    
    // sloganLabel
    self.sloganLabel = [[UILabel alloc] init];
    self.sloganLabel.text = kLoginSlogan;
    [self.bgView addSubview:self.sloganLabel];
    [self.sloganLabel setTextColor:[UIColor whiteColor]];
    self.sloganLabel.textAlignment = NSTextAlignmentCenter;
    
    // userName
    self.loginUserImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login-Username"]];
    [self.bgView addSubview:self.loginUserImage];
    
    UIColor *placeHoderColor = [UIColor whiteColor];
    
    self.userNameText = [[UITextField alloc] init];
    self.userNameText.textAlignment = NSTextAlignmentCenter;
    self.userNameText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入帐名" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
    self.userNameText.borderStyle = UITextBorderStyleNone;
    self.userNameText.delegate = self;
    self.userNameText.textColor = [UIColor whiteColor];
    self.userNameText.userInteractionEnabled = YES;
    self.userNameText.returnKeyType = UIReturnKeyDone;
    [self.userNameText becomeFirstResponder];
    [self.bgView addSubview:self.userNameText];
    
    self.seperateView1 = [[UIView alloc] init];
    self.seperateView1.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.seperateView1];
    
    // userPassword
    self.loginPasswordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login-Password"]];
    [self.bgView addSubview:self.loginPasswordImage];
    self.userPasswordText = [[UITextField alloc] init];
    self.userPasswordText.textAlignment = NSTextAlignmentCenter;
    self.userPasswordText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userPasswordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
    self.userPasswordText.secureTextEntry = YES;
    self.userPasswordText.delegate = self;
    [self.userPasswordText setTextColor:[UIColor whiteColor]];
    self.userPasswordText.returnKeyType = UIReturnKeyDone;
    self.userPasswordText.userInteractionEnabled = YES;
    self.userPasswordText.borderStyle = UITextBorderStyleNone;
    self.userPasswordText.clearButtonMode = UITextFieldViewModeAlways;
    [self.bgView addSubview:self.userPasswordText];
    
    self.seperateView2 = [[UIView alloc] init];
    self.seperateView2.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.seperateView2];
    
    // loginButton
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.loginButton];
    
    
    self.findPassword = [[UIButton alloc]init];
    [self.findPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.findPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.findPassword.backgroundColor = [UIColor clearColor];
    self.findPassword.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.findPassword addTarget:self action:@selector(jumpToFindPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.findPassword];
    
    //versionLabel
    self.versionLabel = [[UILabel alloc] init];
    self.version = [[Version alloc] init];
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.font = [UIFont systemFontOfSize:12];
    self.versionLabel.text = [NSString stringWithFormat:@"i%@(%@)", self.version.current, self.version.build];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:self.versionLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userinfomoveToTop:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userinfoMoveToBottom:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    isPad ? [self layoutWithIpad] : [self layoutView];
}

//布局视图
- (void)layoutView {
    for (UIView *view in [self.bgView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    self.sideblank = (self.view.frame.size.width - 40) / 2;
    
    NSDictionary *ViewDict = NSDictionaryOfVariableBindings(_logoView, _sloganLabel, _loginButton, _loginPasswordImage, _loginUserImage, _seperateView1, _seperateView2, _userNameText, _userPasswordText,_versionLabel,_findPassword);
    // [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logoView]-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    NSString *strl =[NSString stringWithFormat: @"V:|-100-[_logoView(42)]-20-[_sloganLabel(20)]-%f-[_userNameText(30)]-2-[_seperateView1(2)]-20-[_userPasswordText(30)]-2-[_seperateView2(2)]-10-[_findPassword]-10-[_loginButton(40)]-(>=50)-[_versionLabel(20)]-10-|", kSloganHeight];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strl options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_sloganLabel]-80-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_seperateView1]-40-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_seperateView2]-40-|" options:0 metrics:nil views:ViewDict]];
    //[_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[_logoView(50)]-20-[_sloganLabel]-80-[_loginUserView]-1-[_seperateView1(2)]-20-[_loginPassword]-1-[_seperateView2(2)]-16-[_LoginButton]-200-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_loginUserImage(30)]-10-[_userNameText]-80-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_versionLabel]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_loginPasswordImage(30)]-10-[_userPasswordText]-80-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_loginButton]-40-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_findPassword(70)]-40-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)layoutWithIpad {
    for (UIView *view in [self.bgView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    self.sideblank = (self.view.frame.size.width - 40) / 2;
    
    NSDictionary *ViewDict = NSDictionaryOfVariableBindings(_logoView, _sloganLabel, _loginButton, _loginPasswordImage, _loginUserImage, _seperateView1, _seperateView2, _userNameText, _userPasswordText,_versionLabel,_findPassword);
    // [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logoView]-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    NSString *strl =[NSString stringWithFormat: @"V:|-100-[_logoView(42)]-20-[_sloganLabel(20)]-%f-[_userNameText(30)]-2-[_seperateView1(2)]-20-[_userPasswordText(30)]-2-[_seperateView2(2)]-10-[_findPassword]-10-[_loginButton(40)]-(>=50)-[_versionLabel(20)]-10-|", [[UIScreen mainScreen] bounds].size.height / 5];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strl options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_sloganLabel]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_seperateView1]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_seperateView2]-120-|" options:0 metrics:nil views:ViewDict]];
    //[_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[_logoView(50)]-20-[_sloganLabel]-80-[_loginUserView]-1-[_seperateView1(2)]-20-[_loginPassword]-1-[_seperateView2(2)]-16-[_LoginButton]-200-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_loginUserImage(30)]-10-[_userNameText]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_versionLabel]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_loginPasswordImage(30)]-10-[_userPasswordText]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_loginButton]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_findPassword(70)]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)userinfomoveToTop:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.bgView.frame = CGRectMake(0, - height + height / 2, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)userinfoMoveToBottom:(NSNotification *)aNotification {
    self.bgView.frame = self.view.frame;
}

// 找回密码
- (void)jumpToFindPassword {
    FindPasswordViewController *findPwdViewController = [[FindPasswordViewController alloc]init];
    [self presentViewController:findPwdViewController animated:YES completion:nil];
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
