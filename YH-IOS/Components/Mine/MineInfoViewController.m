//
//  MineInfoViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineHeadView.h"
#import "MineInfoTableViewCell.h"

//#import "MineResetPwdViewController.h"
//use new ResetPwdViewController
#import "NewMineResetPwdController.h"

#import "MineQuestionViewController.h"
#import "MineRequestListViewController.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "User.h"
#import "MineSingleSettingViewController.h"
#import "LoginViewController.h"
#import "APIHelper.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UserAvaTableViewCell.h"
#import "UserMessageTableViewCell.h"
#import "MineTwoLabelTableViewCell.h"
#import "MineDetailTableViewCell.h"
#import "LogoutTableViewCell.h"


@interface MineInfoViewController ()<UITableViewDelegate,UITableViewDataSource,MineHeadDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate >
{
    NSArray *titleArray;
    NSArray *secondArray;
    NSArray *titleIameArray;
    NSArray *seconImageArray;
    User *user;
}

@property (nonatomic, strong) MineHeadView *mineHeaderView;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSDictionary *userMessageDict;
@property (nonatomic, strong) UITableView *minetableView;
@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, strong) NSArray *leftImageArray;
@property (nonatomic, strong) UIImage *userAvaImage;
@property (nonatomic, strong) NSDictionary *userDict;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    user = [[User alloc]init];
    _mineHeaderView = [[MineHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    _mineHeaderView.delegate =self;
    self.userArray = @[@[],@[@"归属部门",@"工号"],@[@"文章收藏"],@[@"设置",@"修改密码",@"问题反馈"]];
    titleIameArray = @[@"list_ic_person",@"list_ic_department"];
    self.leftImageArray = @[@[],@[@"icon_section",@"login_jobno"],@[@"icon_collection"],@[@"icon_setting",@"icon_password",@"icon_feedback"]];
    
    secondArray = @[user.groupName,user.userNum];
    seconImageArray = @[@"list_ic_set"];
     [self setupTableView];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self BindDate];
    RACSignal *requestSingal = [self.requestCommane execute:nil];
    [requestSingal subscribeNext:^(NSDictionary *x) {
        
        self.userDict = [x copy];
        [self.minetableView reloadData];
    }];
}


- (void)BindDate {
    _requestCommane = [[RACCommand  alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/user/%@/group/%@/role/%@/statistics",kBaseUrl,user.userNum,user.groupID,user.roleID];
            [manager GET:kpiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"用户信息 %@",responseObject);
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR- %@",error);
            }];
             return nil;
        }];
        return [requestSignal map:^id(NSDictionary *value){
            NSDictionary *dict = value;
            self.userMessageDict = dict;
            return dict;
        }];
    }];
}



-(void)setupTableView {
    
    self.minetableView= [[UITableView alloc]init];
    self.minetableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64);
    [self.view addSubview:self.minetableView];
    [self.minetableView setScrollEnabled:YES];
    self.minetableView.delegate = self;
    self.minetableView.dataSource = self;
    self.minetableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
   // UINib *mineInfoCell = [UINib nibWithNibName:@"MineInfoTableViewCell" bundle:nil];
    //[self.minetableView registerNib:mineInfoCell forCellReuseIdentifier:@"MineInfoTableViewCell"];
   // self.minetableView.tableFooterView = [self LogoutFooterView];
    
  //  [self.mineHeaderView.avaterImageView sd_setImageWithURL:self.person.icon];
}

// 上传图像

-(void)ClickButton:(UIButton *)btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action){}];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [alertController addAction:photoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - upload user gravatar
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage* userIconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(userIconImage, 1.0);
    self.userAvaImage = userIconImage;
    [self.minetableView reloadData];
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *gravatarName = [NSString stringWithFormat:@"%@-%@-%@.jpg", kAppCode, user.userNum, timestamp];
    NSString *urlPath = [NSString stringWithFormat:kUploadGravatarAPIPath, user.deviceID, user.userID];
   // NSString *urlPath = @"http://192.168.0.187:3000/api/v1/user/123456/problem_render";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    AFHTTPRequestOperation *op = [manager POST:urlPath parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"gravatar" fileName:gravatarName mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    [op start];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 2;
    }
    else if (section == 2){
        return 1;
    }
    else if (section == 3){
        return 3;
    }
    else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return adaptHeight(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 95;
                break;
            case 1:
                return 80;
            default:
                return 80;
                break;
        }
    }
    else {
        return 50;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
       UserAvaTableViewCell* Cell = [[UserAvaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userAva"];
        if (self.userDict != nil) {
            Cell.userNameLabel.text = self.userDict[@"user_name"];
            Cell.userRoleLabel.text = self.userDict[@"role_name"];
            if (self.userAvaImage != nil) {
                [Cell.avaterImageView setImage:self.userAvaImage forState:UIControlStateNormal];
            }
            else {
                [Cell.avaterImageView sd_setImageWithURL:self.userDict[@"gravatar"] forState:UIControlStateNormal];
            }
        }
        else {
           Cell.userNameLabel.text = user.userName;
           Cell.userRoleLabel.text = [NSString stringWithFormat:@"%@",user.roleName];
           if (self.userAvaImage != nil) {
              [Cell.avaterImageView setImage:self.userAvaImage forState:UIControlStateNormal];
          }
        }
        [[Cell.avaterImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"点击了按钮");
            [self ClickButton:Cell.avaterImageView];
        }];
          return Cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
    UserMessageTableViewCell*  Cell = [[UserMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userMessage"];
        Cell.userInteractionEnabled = NO;
           if (self.userDict != nil) {
               [Cell refreshViewWith:self.userDict];
           }
        return Cell;
    }
    
    else if (indexPath.section == 1) {
      MineTwoLabelTableViewCell*  Cell = (MineTwoLabelTableViewCell *)[[MineTwoLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaltCell"];
        Cell.userInteractionEnabled = NO;
        
        Cell.leftLabel.text = self.userArray[indexPath.section][indexPath.row];
        Cell.leftImageView.image = [[UIImage imageNamed:self.leftImageArray[indexPath.section][indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        Cell.rightLabel.text =secondArray[indexPath.row];
        
        return Cell;
    }
    else if (indexPath.section == 4){
        LogoutTableViewCell *Cell = [[LogoutTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logoutCell"];
        [[Cell.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self logoutButtonClick:Cell.logoutButton];
        }];
        return Cell;
    }
    else {
        MineDetailTableViewCell *Cell = [[MineDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaulttwo"];
        Cell.leftLabel.text = self.userArray[indexPath.section][indexPath.row];
        Cell.leftImageView.image = [[UIImage imageNamed:self.leftImageArray[indexPath.section][indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        return Cell;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    return headView;
}

-(UIView *)LogoutFooterView{
    
    UIView *logoutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH, 40)];
    [logoutView addSubview:logoutButton];
    logoutButton.layer.borderWidth = 1;
    logoutButton.layer.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [[logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self logoutButtonClick:logoutButton];
    }];
    //[logoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitleColor:[UIColor colorWithHexString:@"#010101"] forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor colorWithHexString:@"#fbfcf5"];
    logoutView.backgroundColor = [UIColor whiteColor];
    
    return logoutView;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 3 ) && (indexPath.row == 1)) {
//        MineResetPwdViewController *mineResetPwdCtrl = [[MineResetPwdViewController alloc]init];
        
        NewMineResetPwdController *mineResetPwdCtrl = [[NewMineResetPwdController alloc]init];
        mineResetPwdCtrl.title = @"修改密码";
        [RootNavigationController pushViewController:mineResetPwdCtrl animated:YES hideBottom:YES];
    }
    else if ((indexPath.section == 3)&&(indexPath.row == 2)){
        MineQuestionViewController *mineQuestionCtrl = [[MineQuestionViewController  alloc]init];
        mineQuestionCtrl.title = @"生意人反馈收集";
        [RootNavigationController pushViewController:mineQuestionCtrl animated:YES hideBottom:YES];
    }
    else if ((indexPath.section ==3)&&(indexPath.row ==0)){
        MineSingleSettingViewController *settingCtrl = [[MineSingleSettingViewController alloc]init];
        settingCtrl.title = @"设置";
        [RootNavigationController pushViewController:settingCtrl animated:YES hideBottom:YES];
    }
}

- (void)logoutButtonClick:(UIButton*) button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认退出" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self jumpToLogin];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action){}];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        [APIHelper deleteUserDevice:@"ios" withDeviceID:user.deviceID];
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[kActionALCName] = @"退出登录";
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    });
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
