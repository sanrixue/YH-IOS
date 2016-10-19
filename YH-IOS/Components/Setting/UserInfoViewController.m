//
//  UserInfoViewController.m
//  YH-IOS
//
//  Created by li hao on 16/10/18.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "UserInfoViewController.h"
#import "FileUtils.h"
#import "UIColor+Hex.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)NSMutableDictionary *userInfoDict;
@property (strong, nonatomic)NSArray *userInfoDictKey;
@property (strong, nonatomic)UILabel *showInfo;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    // 初始化数据
    NSString *userConfig = [[FileUtils userspace] stringByAppendingPathComponent:kConfigDirName];
    NSMutableDictionary *userConfigBehaviorDict = [FileUtils readConfigFile:[userConfig stringByAppendingPathComponent:kBehaviorConfigFileName]];
    NSMutableDictionary *userConfigSettingDict = [FileUtils readConfigFile:[userConfig stringByAppendingPathComponent:kSettingConfigFileName]];
    NSMutableDictionary *userLocalNotificationDict = [FileUtils readConfigFile:[userConfig stringByAppendingPathComponent:kLocalNotificationConfigFileName]];
    //手机系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    //手机型号
    NSString *phoneModel = [[UIDevice currentDevice] model];

    //显示的 label
    NSString *writeMessageString = [NSString stringWithFormat:@"个人基本信息:\n%@ \n  手机系统版本:%@,\n 手机型号:%@ \n 用户行为记录:\n%@\n 设置信息:\n%@",userConfigSettingDict,phoneVersion,phoneModel,userConfigBehaviorDict,userLocalNotificationDict];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60,self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *showlabel = [[UILabel alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f ], NSParagraphStyleAttributeName : style };
    CGRect labelRect = [writeMessageString boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    showlabel.font =[UIFont systemFontOfSize:14];
    showlabel.frame = CGRectMake(0, 0, self.view.frame.size.width, labelRect.size.height + 200);
    showlabel.text = writeMessageString;
    showlabel.numberOfLines = 0;
    scrollView.contentSize = showlabel.frame.size;
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:showlabel];
    [self.view addSubview:scrollView];
    //顶部返回和title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20,self.view.frame.size.width - 200 , 30)];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.text = @"配置信息";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titlelabel];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 60, 20)];
    [backBtn addTarget:self action:@selector(backToSetting) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn setImage:[UIImage imageNamed:@"Banner-Back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backToSetting {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

