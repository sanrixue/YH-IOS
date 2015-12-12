//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"
#import "FileUtils.h"
#import "ViewUtils.h"
#import "HttpUtils.h"
#import "const.h"
#import <MBProgressHUD/MBProgressHUD.h>



@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView *gesturePasswordView;
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@property (assign, nonatomic) BOOL isChange;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
}

@synthesize gesturePasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    previousString = [NSString string];
    _isChange = NO;
    
    NSString *gesturePasswordPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:GESTURE_PASSWORD_FILENAME];
    NSDictionary *gesturePasswordInfo = [FileUtils readConfigFile:gesturePasswordPath];
    password = gesturePasswordInfo[@"gesture_password"];
    
    if (!password || [password isEqualToString:@""]) {
        
        [self reset];
    }
    else {
        
        [self verify];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_progressHUD hide:YES];
    _progressHUD = nil;
    gesturePasswordView = nil;
}


#pragma mark - 验证手势密码
- (void)verify {
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView setIsChangeGesturePassword:_isChange];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
//    [gesturePasswordView.imgView setHidden:YES];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [gesturePasswordView setIsChangeGesturePassword:_isChange];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    NSString *gesturePasswordPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:GESTURE_PASSWORD_FILENAME];
    NSDictionary *gesturePasswordInfo = [FileUtils readConfigFile:gesturePasswordPath];
    password = gesturePasswordInfo[@"gesture_password"];
    
    if (!password || [password isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark - 清空记录
- (void)clear {
    NSString *gesturePasswordPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:GESTURE_PASSWORD_FILENAME];
    [FileUtils removeFile:gesturePasswordPath];
}

#pragma mark - 改变手势密码
- (void)change {
    _isChange = YES;
    
    [self verify];
    
    gesturePasswordView.state.hidden = NO;
    gesturePasswordView.state.textColor = [UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1];
    gesturePasswordView.state.text = @"请输入旧手势密码:";
}

#pragma mark - 忘记手势密码
- (void)forget {
//    [ViewUtils showPopupView:self.view Info:@"请在微信公众号中回复:\"忘记手势密码\""];
    
//    NSString *deviceConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:DEVICE_CONFIG_FILENAME];
//    NSDictionary *deviceConfig = [FileUtils readConfigFile:deviceConfigPath];
//    NSString *deviceUID = deviceConfig[@"device_uid"];
//    NSString *message = [NSString stringWithFormat:@"忘记手势密码@%@", deviceUID];;
//    [ViewUtils simpleAlertView:self Title:@"微信公众号中回复" Message:message ButtonTitle:@"拷贝"];
    
//    [[UIPasteboard generalPasteboard] setPersistent:YES];
//    [[UIPasteboard generalPasteboard] setValue:message forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
}

- (void)cancel {
    _isChange = NO;
    
    [self verify];
    
    gesturePasswordView.state.hidden = NO;
    gesturePasswordView.state.textColor = [UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1];
    gesturePasswordView.state.text = @"请验证手势密码:";
}

- (BOOL)verification:(NSString *)result{
    NSLog(@"%@", result);
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"输入正确"];
        //[self presentViewController:(UIViewController) animated:YES completion:nil];
        
        if(_isChange) {
            [self reset];
            gesturePasswordView.state.hidden = NO;
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            gesturePasswordView.state.text = @"请输入新手势密码:";
        }
        else {
            if([_delegate respondsToSelector:@selector(verifySucess)]) {
                [_delegate verifySucess];
            }
            else {
                [self enterMainView];
            }
        }
        
        return YES;
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:@"手势密码错误"];
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    NSLog(@"%@", result);
    
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"请再次输入手势密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            
            [self showProgressHUD:@"保存中..."];
            
            NSString *gesturePasswordPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:GESTURE_PASSWORD_FILENAME];
            NSDictionary *gesturePasswordInfo = [FileUtils readConfigFile:gesturePasswordPath];
            NSMutableDictionary *gesturePasswordEditor = [NSMutableDictionary dictionaryWithDictionary:gesturePasswordInfo];
            gesturePasswordEditor[@"gesture_password"] = result;
            [FileUtils writeJSON:gesturePasswordEditor Into:gesturePasswordPath];
            
            //[self presentViewController:(UIViewController) animated:YES completion:nil];
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [gesturePasswordView.state setText:@"已保存手势密码"];
            
            NSString *settingsConfigPath = [FileUtils dirPath:CONFIG_DIRNAME FileName:SETTINGS_CONFIG_FILENAME];
            NSDictionary *settingsInfo = [FileUtils readConfigFile:settingsConfigPath];
            NSMutableDictionary *settingsInfoEditor = [NSMutableDictionary dictionaryWithDictionary:settingsInfo];
            settingsInfoEditor[@"use_gesture_password"] = @1;
            settingsInfoEditor[@"gesture_password_is_synced"] = @0;
            [FileUtils writeJSON:settingsInfoEditor Into:settingsConfigPath];
            
            if([HttpUtils isNetworkAvailable]) {
                //[DataHelper postGesturePassword];
            }
            [_progressHUD hide:YES];
            
            if([_delegate respondsToSelector:@selector(verifySucess)]) {
                [_delegate verifySucess];
            }
            else {
                [self enterMainView];
            }
            
            return YES;
        }
        else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}


- (void)enterMainView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showProgressHUD:(NSString *)msg {
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.labelText = msg;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
