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
#import "MianTabBarViewController.h"


#import "RMessage.h"
#import "RMessageView.h"

#define kSloganHeight [[UIScreen mainScreen]bounds].size.height / 6

@interface LoginViewController () <UITextFieldDelegate,MBProgressHUDDelegate,RMessageProtocol>

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
@property (nonatomic, strong) UIButton *registerBtn;



@property (nonatomic, strong)UITextField *passwordNumber;



@property (nonatomic, copy)NSString *peopleNumString;

@property (nonatomic, copy)NSString *passwordNumString;

@property (nonatomic, strong)UIView *PasswordUnderLine;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [RMessage setDefaultViewController:self.navigationController];
    [RMessage setDelegate:self];
    

    
    
    UIImageView *Logo =[[UIImageView alloc] init];
    
    [self.view addSubview:Logo];
    
    [Logo setImage:[UIImage imageNamed:@"pic_logo"]];
    
    [Logo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_topMargin).offset(132);
        
//        make.left.mas_equalTo(self.view.mas_left).offset(100);
//        
//        make.right.mas_equalTo(self.view.mas_right).offset(-100);
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
    
        make.size.mas_equalTo(CGSizeMake(70, 70));
        
    }];
    
    
    UILabel *APPName=[[UILabel alloc] init];
    
    [self.view addSubview:APPName];
    
//    APPName.text=@"永辉生意人";
    
    APPName.textColor=[UIColor colorWithHexString:@"bcbcbc"];
    
    //设置字间距 NSKernAttributeName:@1.0f
    NSDictionary *dic = @{NSKernAttributeName:@1.0f};
    
    APPName.font=[UIFont systemFontOfSize:15];
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"永辉生意人" attributes:dic];
    
    APPName.attributedText = attributeStr;
    
    
    [APPName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
//        make.left.mas_equalTo(self.view.mas_left).offset(141);
        
        make.top.mas_equalTo(Logo.mas_bottom).offset(14);
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
        make.size.mas_equalTo(CGSizeMake(94, 15));
    }];
    
    
    
    
    UITextField *peopleNumber=[[UITextField alloc] init];
    
    [self.view addSubview:peopleNumber];
    
    peopleNumber.placeholder=@"员工号";
    
    peopleNumber.font=[UIFont systemFontOfSize:15];
    
    peopleNumber.textAlignment=NSTextAlignmentLeft;

    peopleNumber.textColor=[UIColor colorWithHexString:@"#cccccc"];
    
    [peopleNumber addTarget:self action:@selector(peopleNumberChange:) forControlEvents:UIControlEventEditingChanged];

    
    [peopleNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.mas_equalTo(APPName.mas_bottom).offset(77);
        
         make.left.mas_equalTo(self.view.mas_left).offset(94);
        
         make.centerX.mas_equalTo(self.view.mas_centerX);
        
         make.size.mas_equalTo(CGSizeMake(245, 30));
        
    }];
    
    
    UIImageView *peopleLogo=[[UIImageView alloc] init];
    
    [peopleLogo setImage:[UIImage imageNamed:@"login_name"]];
    
    
    [self.view addSubview:peopleLogo];
    
    [peopleLogo mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(APPName.mas_bottom).offset(75);
        
        make.centerY.mas_equalTo(peopleNumber.mas_centerY);
        
        make.left.mas_equalTo(self.view.mas_left).offset(65);
        
        make.size.mas_equalTo(CGSizeMake(14, 18));
        
    }];
    
    
    
    UIView * PeopleUnderLine = [[UIView alloc]init];
    
    PeopleUnderLine.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    
    [self.view addSubview:PeopleUnderLine];

    [PeopleUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        
        make.left.mas_equalTo(peopleLogo.mas_left);
        
        make.top.mas_equalTo(peopleLogo.mas_bottom).offset(9);
        
        make.centerX.mas_equalTo(self.view.mas_centerX);

        make.size.mas_equalTo(CGSizeMake(245, 1));
    }];
    
 
        _passwordNumber=[[UITextField alloc] init];
    
        [self.view addSubview:_passwordNumber];
    
        [_passwordNumber setSecureTextEntry:YES];
    
        _passwordNumber.font=[UIFont systemFontOfSize:16];
    
        _passwordNumber.textAlignment=NSTextAlignmentLeft;
    
    
        _passwordNumber.textColor=[UIColor colorWithHexString:@"#666667"];
    
    
   [_passwordNumber addTarget:self action:@selector(PasswordDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [_passwordNumber addTarget:self action:@selector(changePwdLine:) forControlEvents:UIControlEventEditingDidBegin];
    
        [_passwordNumber mas_makeConstraints:^(MASConstraintMaker *make) {
    
            
            make.left.mas_equalTo(peopleNumber.mas_left);
            
            make.top.mas_equalTo(peopleNumber.mas_bottom).offset(20);
    
            make.centerX.mas_equalTo(self.view.mas_centerX);
    
            make.size.mas_equalTo(CGSizeMake(245, 30));
            
        }];
    
    

        _PasswordUnderLine = [[UIView alloc]init];
    

    
     _PasswordUnderLine.backgroundColor= [UIColor colorWithHexString:@"#cccccc"];
        [self.view addSubview:_PasswordUnderLine];
    
        [_PasswordUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
    
            
            make.left.mas_equalTo(peopleLogo.mas_left);
            
            make.top.mas_equalTo(PeopleUnderLine.mas_bottom).offset(47);
    
            make.centerX.mas_equalTo(self.view.mas_centerX);
    
            make.size.mas_equalTo(CGSizeMake(245, 1));
        }];
    
    
    
           UIImageView *PasswordLogo=[[UIImageView alloc] init];
    
            [PasswordLogo setImage:[UIImage imageNamed:@"login_password"]];
    
            [self.view addSubview:PasswordLogo];
    
    
            [PasswordLogo mas_makeConstraints:^(MASConstraintMaker *make) {
    

                make.top.mas_equalTo(_PasswordUnderLine.mas_bottom).offset(-27);
                
                make.centerY.mas_equalTo(_passwordNumber.mas_centerY);
    
                make.left.mas_equalTo(self.view.mas_left).offset(65);
    
                make.size.mas_equalTo(CGSizeMake(14, 17));
                
            }];
    
    UIButton *deleteLogo=[[UIButton alloc] init];

    [deleteLogo setBackgroundImage:[UIImage imageNamed:@"btn_empty"] forState:UIControlStateNormal];
    
    
    [deleteLogo addTarget:self action:@selector(deleteOldPassword) forControlEvents:UIControlEventTouchDown];
    

    [self.view addSubview:deleteLogo];
    
    
    [deleteLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.mas_equalTo(PeopleUnderLine.mas_bottom).offset(25);
        
        make.centerY.mas_equalTo(_passwordNumber.mas_centerY);
        
        make.right.mas_equalTo(self.view.mas_right).offset(-76);

        make.size.mas_equalTo(CGSizeMake(10, 10));
        
    }];
    

    

    UIButton *logoInBtn=[UIButton buttonWithType:UIButtonTypeCustom];

    
    [logoInBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    logoInBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
    
    [logoInBtn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchDown];
    
    [logoInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [logoInBtn setBackgroundColor:[UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1] forState:UIControlStateNormal];
    
//    logoInBtn.layer.cornerRadius=10;
    
    logoInBtn.clipsToBounds=YES;
    
    logoInBtn.layer.cornerRadius=20;
    
    
    [self.view addSubview:logoInBtn];
    
    [logoInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.mas_equalTo(_PasswordUnderLine.mas_bottom).offset(24);
        
        make.centerX.mas_equalTo(self.view.mas_centerX);

        make.size.mas_equalTo(CGSizeMake(245, 40));
    }];

    
    

    UIButton *forGotPwd=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [forGotPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    forGotPwd.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [forGotPwd addTarget:self action:@selector(jumpToFindPassword) forControlEvents:UIControlEventTouchDown];
    
    [forGotPwd setTitleColor:[UIColor colorWithHexString:@"bcbcbc"] forState:UIControlStateNormal];
    
 
    [self.view addSubview:forGotPwd];
    
    [forGotPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_bottom).offset(-44);
        
        make.left.mas_equalTo(self.view.mas_left).offset(120);
        
        make.size.mas_equalTo(CGSizeMake(55,12));
    }];
    
    
    
    UIView *line=[[UIView alloc] init];
    
    [line setBackgroundColor:[UIColor colorWithHexString:@"bcbcbc"]];
    
    [self.view addSubview:line];
    

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
          make.top.mas_equalTo(self.view.mas_bottom).offset(-44);
    
          make.left.mas_equalTo(forGotPwd.mas_right).offset(16);

          make.size.mas_equalTo(CGSizeMake(0.5,14));
    }];
    
    
   
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [registerBtn setTitle:@"申请注册" forState:UIControlStateNormal];
    
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchDown];
    
    [registerBtn setTitleColor:[UIColor colorWithHexString:@"bcbcbc"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:registerBtn];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_bottom).offset(-44);
        
        make.left.mas_equalTo(line.mas_right).offset(16);
        
        make.size.mas_equalTo(CGSizeMake(55,12));
    }];
    

    
//    self.bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    self.bgView.image = [UIImage imageNamed:@"login-bg"];
//    [self.view addSubview:self.bgView];
//    self.bgView.userInteractionEnabled = YES;
//    // logoView
//    self.logoView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    self.logoView.contentMode = UIViewContentModeScaleToFill;
//    [self.bgView addSubview:self.logoView];
//    
//    // sloganLabel
//    self.sloganLabel = [[UILabel alloc] init];
//    self.sloganLabel.text = kLoginSlogan;
//    [self.bgView addSubview:self.sloganLabel];
//    [self.sloganLabel setTextColor:[UIColor colorWithHexString:@"#000"]];
//    self.sloganLabel.textAlignment = NSTextAlignmentCenter;
//    
//    // userName
//    self.loginUserImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sh"]];
//    [self.bgView addSubview:self.loginUserImage];
//    
//    UIColor *placeHoderColor = [UIColor colorWithHexString:@"#6c6c6c"];
//    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
//    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
//    self.userNameText = [[UITextField alloc] init];
//    self.userNameText.textAlignment = NSTextAlignmentCenter;
//    self.userNameText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    self.userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"帐户" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
//    self.userNameText.borderStyle = UITextBorderStyleNone;
//    self.userNameText.delegate = self;
//    if (![userDict[@"user_name"] isEqualToString:@""] && userDict[@"user_name"]) {
//        self.userNameText.text = userDict[@"user_num"];
//    }
//    self.userNameText.textColor = [UIColor blackColor];
//    self.userNameText.userInteractionEnabled = YES;
//    self.userNameText.returnKeyType = UIReturnKeyDone;
//    [self.userNameText becomeFirstResponder];
//    [self.bgView addSubview:self.userNameText];
//    
//    self.seperateView1 = [[UIView alloc] init];
//    self.seperateView1.backgroundColor = [UIColor blackColor];
//    [self.bgView addSubview:self.seperateView1];
//    
//    // userPassword
//    self.loginPasswordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lock"]];
//    [self.bgView addSubview:self.loginPasswordImage];
//    self.userPasswordText = [[UITextField alloc] init];
//    self.userPasswordText.textAlignment = NSTextAlignmentCenter;
//    self.userPasswordText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    self.userPasswordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
//    self.userPasswordText.secureTextEntry = YES;
//    self.userPasswordText.delegate = self;
//    [self.userPasswordText setTextColor:[UIColor blackColor]];
//    self.userPasswordText.returnKeyType = UIReturnKeyDone;
//    self.userPasswordText.userInteractionEnabled = YES;
//    self.userPasswordText.borderStyle = UITextBorderStyleNone;
//    self.userPasswordText.clearButtonMode = UITextFieldViewModeAlways;
//    [self.bgView addSubview:self.userPasswordText];
//    
//    self.seperateView2 = [[UIView alloc] init];
//    self.seperateView2.backgroundColor = [UIColor blackColor];
//    [self.bgView addSubview:self.seperateView2];
//    
//    // loginButton
//    self.loginButton = [[UIButton alloc] init];
//    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"#64b04a"];
//    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
//    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.loginButton.layer.cornerRadius = 6;
//   // self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//    [self.loginButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:self.loginButton];
//    
//    
//    self.registerBtn = [[UIButton alloc]init];
//    [self.registerBtn setTitle:@"申请注册" forState:UIControlStateNormal];
//    [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.registerBtn.backgroundColor = [UIColor clearColor];
//    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    [self.registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:self.registerBtn];
//    
//    self.findPassword = [[UIButton alloc]init];
//    [self.findPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [self.findPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.findPassword.backgroundColor = [UIColor clearColor];
//    self.findPassword.titleLabel.font = [UIFont systemFontOfSize:10];
//    [self.findPassword addTarget:self action:@selector(jumpToFindPassword) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:self.findPassword];
//    
//    
//    //versionLabel
//    self.versionLabel = [[UILabel alloc] init];
//    self.version = [[Version alloc] init];
//    self.versionLabel.textColor = [UIColor blackColor];
//    self.versionLabel.font = [UIFont systemFontOfSize:12];
//    self.versionLabel.text = [NSString stringWithFormat:@"i%@(%@)", self.version.current, self.version.build];
//    self.versionLabel.textAlignment = NSTextAlignmentCenter;
//    self.versionLabel.adjustsFontSizeToFitWidth = YES;
//    [self.bgView addSubview:self.versionLabel];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(userinfomoveToTop:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(userinfoMoveToBottom:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    isPad ? [self layoutWithIpad] : [self layoutView];
    
    
}


-(void)peopleNumberChange:(UITextField*)PeopleNumber
{
// NSLog(@"PhoneNumberDidChange===%@",peopleNumber.text);
    
    _peopleNumString=PeopleNumber.text;

}

-(void)PasswordDidChange:(UITextField*)PasswordNumber
{
    
//    NSLog(@"PhoneNumberDidChange===%@",PasswordNumber.text);

    _passwordNumString=PasswordNumber.text;
    
    _PasswordUnderLine.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1];

}

-(void)changePwdLine:(UITextField*)PasswordNumber
{
    _PasswordUnderLine.backgroundColor = [UIColor colorWithRed:0.24 green:0.69 blue:0.98 alpha:1];
}



-(void)loginBtn
{

    if (_peopleNumString.length == 0) {
        [self showProgressHUD:@"请输入用户名 " mode: MBProgressHUDModeText];
        [self.progressHUD hide:YES afterDelay:1.5];
        return;
    }
    if (_passwordNumString.length == 0) {
        [self showProgressHUD:@"请输入密码 " mode: MBProgressHUDModeText];
        [self.progressHUD hide:YES afterDelay:1.5];
        return;
    }
    [self showProgressHUD:@"验证中"];
//    NSString *msg = [APIHelper userAuthentication:_peopleNumString password:_passwordNumString.md5];
    
   NSString *msg =  [APIHelper userAuthentication:_peopleNumString password:_passwordNumString.md5 coordinate:nil];
    
    [self.progressHUD hide:YES];
    
    if (!(msg.length == 0)) {
        
        
        
//        [self showProgressHUD:msg mode:MBProgressHUDModeText];
//        [self.progressHUD hide:YES afterDelay:2.0];
        
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:@"密码错误"
                                          subtitle:nil
                                         iconImage:nil
                                              type:RMessageTypeError
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        
        
        return;
    }
    
    [self showProgressHUD:@"跳转中"];
    
    [self jumpToDashboardView];
    
}


-(void)deleteOldPassword
{

    _passwordNumber.text=@"";
    
    _PasswordUnderLine.backgroundColor= [UIColor colorWithHexString:@"#cccccc"];
    
}















// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//布局视图
- (void)layoutView {
    for (UIView *view in [self.bgView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    self.sideblank = (self.view.frame.size.width - 40) / 2;
    
    NSDictionary *ViewDict = NSDictionaryOfVariableBindings(_logoView, _sloganLabel, _loginButton, _loginPasswordImage, _loginUserImage, _seperateView1, _seperateView2, _userNameText, _userPasswordText,_versionLabel,_findPassword,_registerBtn);
    // [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logoView]-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    NSString *strl =[NSString stringWithFormat: @"V:|-100-[_logoView(58)]-20-[_sloganLabel(20)]-%f-[_userNameText(30)]-8-[_seperateView1(1)]-20-[_userPasswordText(30)]-8-[_seperateView2(1)]-10-[_findPassword]-30-[_loginButton(40)]-(>=50)-[_versionLabel(20)]-10-|", kSloganHeight];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strl options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_sloganLabel]-80-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_seperateView1]-40-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_seperateView2]-40-|" options:0 metrics:nil views:ViewDict]];
    //[_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[_logoView(50)]-20-[_sloganLabel]-80-[_loginUserView]-1-[_seperateView1(2)]-20-[_loginPassword]-1-[_seperateView2(2)]-16-[_LoginButton]-200-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_loginUserImage(30)]-10-[_userNameText]-80-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_versionLabel]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_loginPasswordImage(30)]-10-[_userPasswordText]-80-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_loginButton]-40-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_registerBtn(70)]-(>=50)-[_findPassword(70)]-40-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_findPassword attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_findPassword attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)layoutWithIpad {
    for (UIView *view in [self.bgView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    self.sideblank = (self.view.frame.size.width - 40) / 2;
    
    NSDictionary *ViewDict = NSDictionaryOfVariableBindings(_logoView, _sloganLabel, _loginButton, _loginPasswordImage, _loginUserImage, _seperateView1, _seperateView2, _userNameText, _userPasswordText,_versionLabel,_findPassword,_registerBtn);
    // [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logoView]-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    NSString *strl =[NSString stringWithFormat: @"V:|-100-[_logoView(58)]-20-[_sloganLabel(20)]-%f-[_userNameText(30)]-2-[_seperateView1(2)]-20-[_userPasswordText(30)]-2-[_seperateView2(2)]-10-[_findPassword]-10-[_loginButton(40)]-(>=50)-[_versionLabel(20)]-10-|", [[UIScreen mainScreen] bounds].size.height / 5];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:strl options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_sloganLabel]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_seperateView1]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_seperateView2]-120-|" options:0 metrics:nil views:ViewDict]];
    //[_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[_logoView(50)]-20-[_sloganLabel]-80-[_loginUserView]-1-[_seperateView1(2)]-20-[_loginPassword]-1-[_seperateView2(2)]-16-[_LoginButton]-200-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_loginUserImage(30)]-10-[_userNameText]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_versionLabel]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_loginPasswordImage(30)]-10-[_userPasswordText]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_loginButton]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-120-[_registerBtn(70)]-(>=50)-[_findPassword(70)]-120-|" options:0 metrics:nil views:ViewDict]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginUserImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userNameText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_loginPasswordImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_userPasswordText attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_findPassword attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [_bgView addConstraint:[NSLayoutConstraint constraintWithItem:_registerBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_findPassword attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
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
    UINavigationController *findPwdCtrl = [[UINavigationController alloc]initWithRootViewController:findPwdViewController];
    [self presentViewController:findPwdCtrl animated:YES completion:nil];

    
}

// 点击注册按钮
-(void)clickRegisterBtn {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"申请注册"
                                                                   message:@"请到数据化运营平台申请开通账号"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
     NSString *msg =  [APIHelper userAuthentication:_peopleNumString password:_passwordNumString.md5 coordinate:nil];
    [self.progressHUD hide:YES];
    
    if (!(msg.length == 0)) {
       
        
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:@"密码错误"
                                          subtitle:nil
                                         iconImage:nil
                                              type:RMessageTypeError
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        
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
   // DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    //dashboardViewController.fromViewController = @"LoginViewController";
    MianTabBarViewController *mainTabbar = [[MianTabBarViewController alloc]init];
    window.rootViewController = mainTabbar;
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
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
