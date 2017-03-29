//
//  OptionConfigViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "OptionConfigViewController.h"
#import "SwitchTableViewCell.h"
#import "SettingNormalViewController.h"
#import "FileUtils.h"
#import "ViewUtils.h"
#import "APIHelper.h"
#import "LTHPasscodeViewController.h"

@interface OptionConfigViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchTableViewCellDelegate>
{
    NSArray *array;
}
@property(nonatomic,strong)UITableView *tableView;
@property (assign, nonatomic) BOOL isChangeLochPassword;
@property (strong, nonatomic) NSString *settingsConfigPath;

@end

@implementation OptionConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    array = @[@"启动锁屏",@"分享长图",@"报表操作",@"清理缓存"];
    [self setupUI];
    self.settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false];
}

-(void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == array.count-1) {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        cell.textLabel.text = array[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else {
        SwitchTableViewCell*  cell = [[SwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.messageLabel.text = array[indexPath.row];
        cell.delegate = self;
        cell.cellId  = indexPath.row;
        switch (indexPath.row) {
            case 0:{
                BOOL isUseGesturePassword = [LTHPasscodeViewController doesPasscodeExist] && [LTHPasscodeViewController didPasscodeTimerEnd];
                cell.changStatusBtn.on = isUseGesturePassword;
            }
                break;
            case 1:{
                NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
                cell.changStatusBtn.on = (betaDict[@"image_within_screen"] && [betaDict[@"image_within_screen"] boolValue]);
            }
                break;
            case 2:{
               NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
                cell.changStatusBtn.on = (betaDict[@"allow_brower_copy"] && [betaDict[@"allow_brower_copy"] boolValue]);
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 4:{
            NSDictionary *infoArray = @{@"清理其他用户缓存":@" ",@"清理自身缓存":@" "};
            SettingNormalViewController *settingNormalView = [[SettingNormalViewController alloc]init];
            settingNormalView.infodict = infoArray;
            settingNormalView.title = @"清理缓存";
            [self.navigationController pushViewController:settingNormalView animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId {
    switch (cellId) {
        case 0:{
            [self actionWehtherUseGesturePassword:button];
        }
            break;
        case 1: {
            [self actionSwitchToNewUI:button];
        }
            break;
        case 2:{
            [self actionSwitchToReportDeal:button];
        }
            break;
            
        default:
            break;
    }
}

// 分享长图
- (void)actionSwitchToNewUI:(UISwitch *)sender {
    NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
    if (!betaDict[@"image_within_screen"]) {
        betaDict[@"image_within_screen"] = @(1);
        [betaDict writeToFile:self.settingsConfigPath atomically:YES];
    }
    betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
    betaDict[@"image_within_screen"] = @(sender.isOn);
    [betaDict writeToFile:self.settingsConfigPath atomically:YES];
}

- (void)actionSwitchToReportDeal:(UISwitch *)sender {
    NSMutableDictionary* betaDict = [FileUtils readConfigFile:self.settingsConfigPath];
    betaDict[@"allow_brower_copy"] = @(sender.isOn);
    [betaDict writeToFile:self.settingsConfigPath atomically:YES];
}


- (void)actionWehtherUseGesturePassword:(UISwitch *)sender {
    if([sender isOn]) {
        self.isChangeLochPassword = YES;
        [self showLockViewForEnablingPasscode];
    }
    else {
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        userDict[kIsUseGesturePasswordCUName] = @(NO);
        [userDict writeToFile:userConfigPath atomically:YES];
        [userDict writeToFile:self.settingsConfigPath atomically:YES];
        
        //self.buttonChangeGesturePassword.enabled = NO;
        
        [ViewUtils showPopupView:self.view Info:@"禁用手势锁设置成功"];
        self.isChangeLochPassword = NO;
        
        [self.tableView reloadData];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [APIHelper screenLock:userDict[kUserDeviceIDCUName] passcode:userDict[kGesturePasswordCUName] state:NO];
            
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName] = [NSString stringWithFormat:@"点击/设置页面/%@锁屏", sender.isOn ? @"开启" : @"禁用"];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }
}

#pragma mark - LTHPasscode delegate methods
- (void)showLockViewForEnablingPasscode {
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                            asModal:YES];
}

- (void)showLockViewForChangingPasscode {
    [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
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
