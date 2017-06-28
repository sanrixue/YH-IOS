//
//  SettingArrayViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/29.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SettingArrayViewController.h"
#import "SettingNormalViewController.h"
#import "FileUtils.h"
#import "User.h"


@interface SettingArrayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,assign) BOOL isUserable;

@end

@implementation SettingArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self setupUI];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated {
  /*  [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    self.navigationController.navigationBar.translucent = NO;*/
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell*  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
    if ([_array[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = _array[indexPath.row][@"name"];
        if ([_array[indexPath.row][@"os"] hasPrefix:@"iPhone"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"iOS%@",_array[indexPath.row][@"os_version"]];
        }
        else{
             cell.detailTextLabel.text = [NSString stringWithFormat:@"Android%@",_array[indexPath.row][@"os_version"]];
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([_array[indexPath.row] isKindOfClass:[NSString class]]){
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = @"手动删除";
        self.isUserable = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_array[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        SettingNormalViewController *thirdView = [[SettingNormalViewController alloc]init];
        thirdView.title = self.title;
        thirdView.infodict = _array[indexPath.row];
        [self.navigationController pushViewController:thirdView animated:YES];
    }
    if (self.isUserable && [_array[indexPath.row] isKindOfClass:[NSString class]]) {
        NSString *messageInfo = [NSString stringWithFormat:@"删除%@",_array[indexPath.row]];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:messageInfo
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSString* filePath = [[FileUtils basePath] stringByAppendingPathComponent:_array[indexPath.row]];
                                                                  [FileUtils removeFile:filePath];
                                                                  [self getDocumentName];}];
        
        [alert addAction:defaultAction];
        UIAlertAction* defaultActioncancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
         [alert addAction:defaultActioncancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (NSArray *)getPathFileName{
    NSArray *firstSavePathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    for (NSString *path in firstSavePathArray) {
        NSLog(@"%@",path);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:firstSavePathArray[0] error:&error];
    NSMutableArray* cleanArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",fileList);
    User *user = [[User alloc]init];
    NSString *userFileName = [NSString stringWithFormat:@"user-%@",user.userID];
    for (NSString* value in fileList) {
        if ([value hasPrefix:@"user-"] && ![value isEqualToString:userFileName] && ![value isEqualToString:@"user-(null)"]) {
            [cleanArray addObject:value];
        }
    }
    return cleanArray;
}

// 获取清理文件
- (NSArray*)getDocumentName{
    NSArray *firstSavePathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    for (NSString *path in firstSavePathArray) {
        NSLog(@"%@",path);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:firstSavePathArray[0] error:&error];
    NSMutableArray* cleanArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",fileList);
    User* user = [[User alloc]init];
    NSString *userFileName = [NSString stringWithFormat:@"user-%@",user.userID];
    for (NSString* value in fileList) {
        if ([value hasPrefix:@"user-"] && ![value isEqualToString:userFileName] && ![value isEqualToString:@"user-(null)"]) {
            NSMutableDictionary *userDict;
            NSString *userPath = [[FileUtils basePath] stringByAppendingPathComponent:value];
            if ([FileUtils checkFileExist:userPath isDir:YES]) {
                NSString *userConfigPath = [userPath stringByAppendingPathComponent:@"Configs"];
                if ([FileUtils checkFileExist:userConfigPath isDir:YES]) {
                    NSString *userInfoPath = [userConfigPath stringByAppendingPathComponent:@"setting.plist"];
                    userDict = [FileUtils readConfigFile:userInfoPath];
                    if (userDict[@"user_name"] && ![userDict[@"user_name"] isEqualToString:@""]) {
                        [cleanArray addObject:userDict[@"user_name"]];
                    }
                }
            }
        }
    }
    self.array = cleanArray;
    [self.tableView reloadData];
    return cleanArray;
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
