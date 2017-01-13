//
//  FindPasswordViewController.m
//  YH-IOS
//
//  Created by li hao on 17/1/13.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "APIHelper.h"
#import "UIColor+Hex.h"
#import "HttpResponse.h"
#import "Version.h"

@interface FindPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) Version *version;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,60)];
    self.navBar.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 30)];
    [backBtn addTarget:self action:@selector(dismissFindPwd) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.navBar addSubview:backBtn];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 30)];
    titleLabel.text = @"找回密码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navBar addSubview:titleLabel];
    [self.view addSubview:self.navBar];
    
    self.reminderLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, self.view.frame.size.width - 80, 30)];
    self.reminderLabel.font = [UIFont systemFontOfSize:12];
    self.reminderLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.reminderLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.userNumber = [[UITextField alloc]initWithFrame:CGRectMake(40, 130, self.view.frame.size.width - 80, 50)];
    self.userNumber.placeholder = @"请输入帐号";
    [self.userNumber becomeFirstResponder];
    self.userNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userNumber.delegate = self;
    self.userNumber.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_userNumber];
    
    UIView *sepLine1 = [[UIView alloc]initWithFrame:CGRectMake(40, 180, self.view.frame.size.width - 80, 2)];
    sepLine1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:sepLine1];
    
    self.userPhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(40, 200, self.view.frame.size.width - 80, 50)];
    self.userPhoneNumber.placeholder = @"手机号码";
    self.userPhoneNumber.delegate = self;
    self.userPhoneNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.userPhoneNumber.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_userPhoneNumber];
    
    UIView *sepLine2 = [[UIView alloc]initWithFrame:CGRectMake(40, 250, self.view.frame.size.width - 80, 2)];
    sepLine2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:sepLine2];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 270, self.view.frame.size.width - 160, 40)];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.layer.borderWidth = 2;
    self.submitBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.submitBtn.layer.cornerRadius = 4;
    [self.submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitToFindPasswd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 30)];
    self.version = [[Version alloc] init];
    self.versionLabel.textColor = [UIColor lightGrayColor];
    self.versionLabel.font = [UIFont systemFontOfSize:12];
    self.versionLabel.text = [NSString stringWithFormat:@"i%@(%@)", self.version.current, self.version.build];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.versionLabel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) submitToFindPasswd {
    self.reminderLabel.text = NULL;
    if (![_userNumber.text isEqualToString:@""] && ![_userPhoneNumber.text isEqualToString:@""]) {
       HttpResponse *reponse =  [APIHelper findPassword:self.userNumber.text withMobile:self.userPhoneNumber.text];
        if ([reponse.statusCode isEqualToNumber:@(201)]) {
            self.reminderLabel.textColor = [UIColor greenColor];
            NSString *message = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
            self.reminderLabel.text = message;
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"重置成功"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self dismissFindPwd];
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            self.reminderLabel.textColor = [UIColor redColor];
            self.reminderLabel.text = [NSString stringWithFormat:@"%@",reponse.data[@"info"]];
        }
    }
    else {
        self.reminderLabel.textColor = [UIColor redColor];
        self.reminderLabel.text = @"信息未填写完整";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissFindPwd {
    self.reminderLabel.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
