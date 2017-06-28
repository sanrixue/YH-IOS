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
#import "MineResetPwdViewController.h"
#import "MineQuestionViewController.h"
#import "MineRequestListViewController.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "User.h"
#import "MineSingleSettingViewController.h"
#import "LoginViewController.h"
#import "APIHelper.h"
#import <SDWebImage/UIButton+WebCache.h>


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

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    user = [[User alloc]init];
    _mineHeaderView = [[MineHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    _mineHeaderView.delegate =self;
    //[self loadData];
    titleArray = @[@"用户角色",@"归属部门",@"密码修改",@"问题反馈"];
    titleIameArray = @[@"list_ic_person",@"list_ic_department",@"list_ic_lock",@"list_ic_feedback"];
    
    secondArray = @[@"我的设置"];
    seconImageArray = @[@"list_ic_set"];
     [self setupTableView];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self BindDate];
    RACSignal *requestSingal = [self.requestCommane execute:nil];
    [requestSingal subscribeNext:^(NSDictionary *x) {
        [_mineHeaderView  refreshViewWith:x];
        [self.minetableView reloadData];
        
    }];
}

- (void)BindDate {
    _requestCommane = [[RACCommand  alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:[NSString stringWithFormat:@"%@/api/v1/user/%@/group/%@/role/%@/statistics",kBaseUrl,user.userNum,user.groupID,user.roleID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    self.minetableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    [self.view addSubview:self.minetableView];
    [self.minetableView setScrollEnabled:YES];
    self.minetableView.tableHeaderView=_mineHeaderView;
    self.minetableView.delegate = self;
    self.minetableView.dataSource = self;
    self.minetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *mineInfoCell = [UINib nibWithNibName:@"MineInfoTableViewCell" bundle:nil];
    [self.minetableView registerNib:mineInfoCell forCellReuseIdentifier:@"MineInfoTableViewCell"];
    self.minetableView.tableFooterView = [self LogoutFooterView];
    
  //  [self.mineHeaderView.avaterImageView sd_setImageWithURL:self.person.icon];
}

// 上传图像

-(void)ClickButton:(UIButton *)btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
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
    [_mineHeaderView refeshAvaImgeView:userIconImage];
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


/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _mineHeaderView;
    }
    else{
        return nil;
    }
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headView.backgroundColor = [UIColor whiteColor];
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
    [headView addSubview:sepView];
    return headView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
          return 35;
    }
    else if (section == 2) {
        return 15;
    }
    else if(section == 0){
        return 0;
    }
    else {
        return 0.01;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineInfoTableViewCell" forIndexPath:indexPath];
    [cell.noticeImage setHidden:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.userTitle.text = titleArray[indexPath.row];
            cell.noticeIcon.image = [UIImage imageNamed:titleIameArray[indexPath.row]];
            cell.userDetailLable.text = [NSString stringWithFormat:@"%@", user.roleName];
        }
        else if (indexPath.row == 1){
            cell.userTitle.text = titleArray[indexPath.row];
            NSString *userRole =[NSString stringWithFormat:@"%@", user.groupName];

            cell.noticeIcon.image = [UIImage imageNamed:titleIameArray[indexPath.row]];
            cell.userDetailLable.text = userRole;
        }
        else {
            cell.userTitle.text = titleArray[indexPath.row];
            cell.noticeIcon.image = [UIImage imageNamed:titleIameArray[indexPath.row]];
            cell.userDetailLable.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 2 && [user.password isEqualToString:@"123456".md5]) {
                [cell.noticeImage setHidden:NO];
            }
        }
    }
    else if (indexPath.section == 1) {
        
        cell.userTitle.text = secondArray[indexPath.row];
        cell.noticeIcon.image = [UIImage imageNamed:seconImageArray[indexPath.row]];
        cell.userDetailLable.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if (!(indexPath.row % 2)) {
        cell.backgroundColor = [UIColor colorWithHexString:@"fbfcf5"];
    }
    return cell;
}


-(UIView *)LogoutFooterView{
    
    UIView *logoutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
    [logoutView addSubview:sepView];
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH, 40)];
    [logoutView addSubview:logoutButton];
    logoutButton.layer.borderWidth = 1;
    logoutButton.layer.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    if ((indexPath.section == 0 ) && (indexPath.row == 2)) {
        MineResetPwdViewController *mineResetPwdCtrl = [[MineResetPwdViewController alloc]init];
        mineResetPwdCtrl.title = @"密码修改";
        [self.navigationController pushViewController:mineResetPwdCtrl animated:YES];
        
    }
    else if ((indexPath.section == 0)&&(indexPath.row == 3)){
        MineQuestionViewController *mineQuestionCtrl = [[MineQuestionViewController  alloc]init];
        mineQuestionCtrl.title = @"生意人反馈收集";
        [self.navigationController pushViewController:mineQuestionCtrl animated:YES];
    }
    else if ((indexPath.section ==1)&&(indexPath.row ==0)){
        MineSingleSettingViewController *settingCtrl = [[MineSingleSettingViewController alloc]init];
        settingCtrl.title = @"我的设置";
        [self.navigationController pushViewController:settingCtrl animated:YES];
    }
}

- (void)logoutButtonClick:(UIButton*) button {
    [self jumpToLogin];
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
