//
//  MineResetPwdViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineResetPwdViewController.h"
#import "SingleLabelTableViewCell.h"
#import "LeftIamgeTableViewCell.h"
#import "RightButtonTableViewCell.h"
#import "User.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "FileUtils.h"
#import "LoginViewController.h"

@interface MineResetPwdViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)User *user;
@property(nonatomic, strong)NSString *oldpassword;
@property(nonatomic, strong)NSString *newpassword;
@property(nonatomic, strong)NSString *confirmnewpassword;

@property(nonatomic, strong)UITextField *oldpasswordfiled;
@property(nonatomic, strong)UITextField *newpasswordfiled;
@property(nonatomic, strong)UITextField *confirmnewpasswordfiled;

@end

@implementation MineResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc]init];
    [self.navigationController.navigationBar setHidden:NO];
    //[self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"#000"]];
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, SCREEN_HEIGHT- 30) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fbfcf5"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self tableFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftIamgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftIamgeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RightButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"RightButtonTableViewCell"];
    // Do any additional setup after loading the view.
}


//登录按钮所在视图
-(UIView *)tableFooterView {
    
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, 100);
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(12, 37, footerView.width-24, 40)];
    [footerView addSubview:loginButton];
    loginButton.layer.cornerRadius = 20;
    loginButton.clipsToBounds = YES;
    [loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(submitTochangePwdwithPwd:withNewPwd:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithHexString:@"#6aa657"] forState:UIControlStateNormal];
    return footerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 39;
    }
    else if (indexPath.row == 1){
        return 45;
    }
    else if (indexPath.row == 2){
        return 45;
    }
    else if (indexPath.row == 3){
        return 45;
    }
    else {
        return 45;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SingleLabelTableViewCell *cell = [[SingleLabelTableViewCell alloc]init];
        cell.contentLable.text = [NSString stringWithFormat:@"工号:%@",_user.userNum];
        cell.userInteractionEnabled=NO;
        return cell;
    }
    else if (indexPath.row == 1) {
        RightButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightButtonTableViewCell" forIndexPath:indexPath];
        cell.verifyText.placeholder= @"请输入旧密码";
        cell.verifyText.tag = indexPath.row;
        [cell.verifyText addTarget:self action:@selector(textfiledWithText:) forControlEvents:UIControlEventAllEditingEvents];
        return cell;
    }
    
    else{
        LeftIamgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftIamgeTableViewCell" forIndexPath:indexPath];
        [cell.rightText addTarget:self action:@selector(textfiledWithText:) forControlEvents:UIControlEventAllEditingEvents];
        cell.rightText.tag = indexPath.row;
        cell.contentIamge.image = [UIImage imageNamed:@"ic_lock.png"];
        if (indexPath.row == 2) {
            cell.rightText.placeholder = @"请输入新密码";
        }
        else{
            cell.rightText.placeholder = @"请再次输入新密码";
        }
        return cell;
    }
}


-(void)textfiledWithText:(UITextField *)textField{
    
    switch (textField.tag) {
        case 1:
            self.oldpassword = textField.text;
            break;
        case 2:
            self.newpassword = textField.text;
            break;
        case 3:
            self.confirmnewpassword = textField.text;
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 10;
}


-(void)submitTochangePwdwithPwd:(NSString *)oldPassword withNewPwd: (NSString *)newPassword{
    oldPassword = self.oldpassword;
    newPassword = self.newpassword;
    
    if (![oldPassword.md5 isEqualToString:self.user.password]) {
        [ViewUtils showPopupView:self.view Info:@"密码输入错误"];
        return;
    }
    if (![_newpassword isEqualToString:_confirmnewpassword]) {
         [ViewUtils showPopupView:self.view Info:@"新密码输入不一致"];
        return;
    }
    if([oldPassword.md5 isEqualToString:self.user.password]) {
        
        HttpResponse *response = [APIHelper resetPassword:self.user.userID newPassword:newPassword.md5];
        NSString *message = [NSString stringWithFormat:@"%@", response.data[@"info"]];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        if(response.statusCode && [response.statusCode isEqualToNumber:@(201)]) {
            [self changLocalPwd:newPassword];
            [alert addButton:@"重新登录" actionBlock:^(void) {
                [self jumpToLogin];
            }];
            
            [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                @try {
                    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                    logParams[@"action"] = @"点击/密码修改";
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });
            
        }
        else {
            // [self changLocalPwd:newPassword];
            [alert addButton:@"好的" actionBlock:^(void) {
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }];
            [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
        }
    }
    else {
        [ViewUtils showPopupView:self.view Info:@"原始密码输入有误"];
    }
}



- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsLoginCUName] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainSBName bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginVCName];
    self.view.window.rootViewController = loginViewController;
}

- (void)changLocalPwd:(NSString *)newPassword {
    NSString  *noticeFilePath = [FileUtils dirPath:@"Cached" FileName:@"local_notifition.json"];
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:noticeFilePath];
    noticeDict[@"setting_password"] = @(-1);
    noticeDict[@"setting"] = @(0);
    [FileUtils writeJSON:noticeDict Into:noticeFilePath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"user_md5"] = newPassword.md5;
    [FileUtils writeJSON:userDict Into:userConfigPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
