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

@interface UserInfoViewController ()
@property (strong, nonatomic) NSMutableDictionary *userInfoDict;
@property (strong, nonatomic) NSArray *userInfoDictKey;
@property (strong, nonatomic) UILabel *showInfo;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    // 初始化数据
    NSString *configPath = [FileUtils dirPath:kConfigDirName];
    NSString *settingDict = [self toString:configPath fileName:kSettingConfigFileName];
    NSString *behaviorDict = [self toString:configPath fileName:kBehaviorConfigFileName];
    NSString *noticeDict = [self toString:configPath fileName:kLocalNotificationConfigFileName];
    NSString *betaDict = [self toString:configPath fileName:kBetaConfigFileName];
    NSString *javascriptPath = [FileUtils barcodeScanResultPath];
    NSString *barCodeResult = @"";
    if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
         barCodeResult = [NSString stringWithContentsOfFile:javascriptPath encoding:NSUTF8StringEncoding error:nil];
    }
    //显示的 label
    NSString *writeMessageString = [NSString stringWithFormat:@"%@:\n%@\n%@:\n%@\n%@:\n%@\n%@:\n%@\n%@:%@\n",kSettingConfigFileName, settingDict, kBehaviorConfigFileName, behaviorDict,kLocalNotificationConfigFileName, noticeDict, kBetaConfigFileName, betaDict,kBarcodeReturnFileName,barCodeResult];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60,self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *showlabel = [[UILabel alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f ], NSParagraphStyleAttributeName : style };
    CGRect labelRect = [writeMessageString boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    showlabel.font =[UIFont systemFontOfSize:14];
    showlabel.frame = CGRectMake(0, 0, self.view.frame.size.width, labelRect.size.height + 100);
    showlabel.text = writeMessageString;
    showlabel.numberOfLines = 0;
    scrollView.contentSize = showlabel.frame.size;
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:showlabel];
    scrollView.bounces = NO;
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

- (NSString *)toString:(NSString *)folder fileName:(NSString *)fileName {
    NSString *filePath = [folder stringByAppendingPathComponent:fileName];
    NSMutableDictionary *configContent = [FileUtils readConfigFile:filePath];
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configContent
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        jsonString = [NSString stringWithFormat:@"%@", configContent];
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

