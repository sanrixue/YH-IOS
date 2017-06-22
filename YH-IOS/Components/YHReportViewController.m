//
//  YHReportViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHReportViewController.h"
#import "YHMutileveMenu.h"
#import "ListPage.h"
#import "SubjectViewController.h"
#import "User.h"
#import "HomeIndexVC.h"
#import "SuperChartVc.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"

@interface YHReportViewController ()
{
    NSMutableArray * _list;
    User *user;
}

@property (nonatomic, strong)NSArray<ListPageList *> *listArray;

@end

@implementation YHReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _list = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    //[self initCategoryMenu];
     self.view.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getdata];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Barcode-Scan-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToScanView)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCategoryMenu {
    
    YHMutileveMenu *view = [[YHMutileveMenu alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49) WithData:_listArray withSelectIndex:^(NSInteger left, NSInteger right, ListItem* info) {
        NSLog(@"%@",info);

        [self jumpToSubjectView:info];
    }];
    view.needToScorllerIndex = 0;
    view.leftSelectBgColor = [UIColor whiteColor];
    view.isRecordLastScroll = NO;
    [self.view addSubview:view];
}


-(void)jumpToSubjectView:(ListItem *)item {
    NSString *targeturl = item.linkPath;
  //  NSArray *urlArray = [targeturl componentsSeparatedByString:@"/"];
    if ([targeturl isEqualToString:@""] || targeturl == nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"该功能正在开发中"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
        subjectView.bannerName = item.listName;
        subjectView.link = targeturl;
        subjectView.commentObjectType = ObjectTypeAnalyse;
        subjectView.objectID = @(item.itemID);
        if ([targeturl rangeOfString:@"template/3/"].location != NSNotFound) {
            HomeIndexVC *vc = [[HomeIndexVC alloc] init];
            vc.bannerTitle = item.listName;
            vc.dataLink = targeturl;
            vc.objectID =@(item.itemID);
            vc.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:rootchatNav animated:YES completion:nil];
            
        }
        else if ([targeturl rangeOfString:@"template/5/"].location != NSNotFound) {
            SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
            superChaerCtrl.bannerTitle = item.listName;
            superChaerCtrl.dataLink = targeturl;
            superChaerCtrl.objectID =@(item.itemID);
            superChaerCtrl.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            [self presentViewController:superChartNavCtrl animated:YES completion:nil];
        }
        /* else if ([data[@"link"] rangeOfString:@"template/"].location != NSNotFound){
         if ([data[@"link"] rangeOfString:@"template/5/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/1/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/2/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/3/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/4/"].location == NSNotFound) {
         SCLAlertView *alert = [[SCLAlertView alloc] init];
         [alert addButton:@"下一次" actionBlock:^(void) {}];
         [alert addButton:@"立刻升级" actionBlock:^(void) {
         NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         [[UIApplication sharedApplication] openURL:url];
         }];
         [alert showSuccess:self title:@"温馨提示" subTitle:@"您当前的版本暂不支持该模块，请升级之后查看" closeButtonTitle:nil duration:0.0f];
         }
         }*/
        else if ([targeturl rangeOfString:@"whatever/group/1/original/kpi"].location != NSNotFound){
          //  JYHomeViewController *jyHome = [[JYHomeViewController alloc]init];
            //jyHome.bannerTitle = title;
            //jyHome.dataLink = targeturl;
           // UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:jyHome];
           // [self presentViewController:superChartNavCtrl animated:YES completion:nil];
        }
        else{ //跳转事件
            UINavigationController *subjectCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
            [self presentViewController:subjectCtrl animated:YES completion:nil];
        }
    }
}

-(void)jumpToScanView {
    [self actionBarCodeScanView:nil];
}

- (IBAction)actionBarCodeScanView:(UIButton *)sender {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if(!userDict[kStoreIDsCUName] || [userDict[kStoreIDsCUName] count] == 0) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoStoreText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        
        return;
    }
    
    if(![self cameraPemission]) {
        [[[UIAlertView alloc] initWithTitle:kWarningTitleText message:kWarningNoCaremaText delegate:nil cancelButtonTitle:kSureBtnText otherButtonTitles:nil] show];
        
        return;
    }
    
    [self qqStyle];
}


#pragma mark - LBXScan Delegate Methods

- (BOOL)cameraPemission {
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}


#pragma mark - 扫描商品二维码（模仿qq界面）

- (void)qqStyle {
    //设置扫码区域参数设置
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)getdata{
    user = [[User alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://development.shengyiplus.com/api/v1/group/%@/role/%@/analyses",user.groupID,user.roleID]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"下载成功");
          NSArray *dic = responseObject[@"data"];
          NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:dic error:nil];
          self.listArray = [array copy];
          [self initCategoryMenu];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
}

@end
