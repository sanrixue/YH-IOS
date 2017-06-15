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

@interface MineResetPwdViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation MineResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
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
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithHexString:@"#6aa657"] forState:UIControlStateNormal];
    return footerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
        cell.contentLable.text = @"工号:80690000";
        cell.userInteractionEnabled=NO;
        return cell;
    }
    else if (indexPath.row == 1 || indexPath.row >2){
        LeftIamgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftIamgeTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.contentIamge.image = [UIImage imageNamed:@"ic_mobile.png"];
            cell.rightText.placeholder= @"请输入手机号";
        }
        else{
            cell.contentIamge.image = [UIImage imageNamed:@"ic_lock.png"];
            if (indexPath.row == 3) {
                cell.rightText.placeholder = @"请输入新密码";
            }
            else{
                 cell.rightText.placeholder = @"请再次输入新密码";
            }
        }
        return cell;
    }
    else{
        RightButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightButtonTableViewCell" forIndexPath:indexPath];
        cell.verifyText.placeholder = @"请输入验证码";
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
