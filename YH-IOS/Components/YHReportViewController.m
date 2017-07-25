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
#import "YHScanStoreViewController.h"
#import "SubjectOutterViewController.h"
#import "JYDemoViewController.h"

@interface YHReportViewController ()
{
    NSMutableArray * _list;
    User *user;
}

@property (nonatomic, strong)NSArray<ListPageList *> *listArray;
@property (nonatomic, strong)YHMutileveMenu *menuView ;
@property (nonatomic, strong) UIRefreshControl* refreshControl;

@end

@implementation YHReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.tabBarController.tabBar.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9f"];
    //self.navigationController.navigationBar.backgroundColor =[UIColor colorWithHexString:@"#f9f9f9f"];
    _list = [NSMutableArray new];
    
   // [self initCategoryMenu];
     self.view.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self getdata];
    [self addMuneView];
    [self getSomeThingNew];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9f"];
    self.navigationController.navigationBar.backgroundColor =[UIColor colorWithHexString:@"#f9f9f9f"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Barcode-Scan-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToScanView)];
}

-(void)addMuneView {
    _menuView  = [[YHMutileveMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) WithData:_listArray withSelectIndex:^(NSInteger left, NSInteger right, ListItem* info) {
        // NSLog(@"%@",info);
        
        [self jumpToSubjectView:info];
    }];
    _menuView.needToScorllerIndex = 0;
    _menuView.leftSelectBgColor = [UIColor whiteColor];
    _menuView.isRecordLastScroll = NO;
    [self.view addSubview:_menuView];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl addTarget:self
     
                        action:@selector(getSomeThingNewRefresh)
     
              forControlEvents:UIControlEventValueChanged];
    
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] init]];
    
    [self.menuView.rightCollection addSubview:_refreshControl];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCategoryMenu {
    self.menuView.allData = _listArray;
    [self.refreshControl endRefreshing];
    [self.menuView reloadData];
}


-(void)jumpToSubjectView:(ListItem *)item {
    NSString *targeturl = item.linkPath;
       NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
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
        BOOL isInnerLink = !([targeturl hasPrefix:@"http://"] || [targeturl hasPrefix:@"https://"]);
        if ([targeturl rangeOfString:@"template/3/"].location != NSNotFound) {
            HomeIndexVC *vc = [[HomeIndexVC alloc] init];
            vc.bannerTitle = item.listName;
            vc.dataLink = targeturl;
            vc.objectID =@(item.itemID);
            vc.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
            logParams[kActionALCName]   = @"点击/报表/报表";
            logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
            logParams[kObjTitleALCName] =  item.listName;
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });
            [self presentViewController:rootchatNav animated:YES completion:nil];
            
        }
        else if ([targeturl rangeOfString:@"template/5/"].location != NSNotFound) {
            SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
            superChaerCtrl.bannerTitle = item.listName;
            superChaerCtrl.dataLink = targeturl;
            superChaerCtrl.objectID =@(item.itemID);
            superChaerCtrl.commentObjectType = ObjectTypeAnalyse;
            UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
            logParams[kActionALCName]   = @"点击/报表/报表";
            logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
            logParams[kObjTitleALCName] =  item.listName;
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });

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
            logParams[kActionALCName]   = @"点击/报表/报表";
            logParams[kObjIDALCName]    = @(item.itemID);
            logParams[kObjTypeALCName]  = @(ObjectTypeAnalyse);
            logParams[kObjTitleALCName] =  item.listName;
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            });
            if (isInnerLink) {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
                subjectView.bannerName = item.listName;
                subjectView.link = targeturl;
                subjectView.commentObjectType = ObjectTypeAnalyse;
                subjectView.objectID = @(item.itemID);
                UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                [self.navigationController presentViewController:subCtrl animated:YES completion:nil];
            }
            else{
                
                SubjectOutterViewController *subjectView = [[SubjectOutterViewController alloc]init];
                subjectView.bannerName = item.listName;
                subjectView.link = targeturl;
                subjectView.commentObjectType = ObjectTypeAnalyse;
                subjectView.objectID = @(item.itemID);
                //UINavigationController *subCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                
                [self.navigationController presentViewController:subjectView animated:YES completion:nil];
            }
        }
    }
}

-(void)jumpToScanView {
   // [self jumpToStoreScan];
    [self actionBarCodeScanView:nil];
}

-(void)jumpToStoreScan{
    JYDemoViewController *scanStore = [[JYDemoViewController alloc]init];
    [self.navigationController pushViewController:scanStore animated:YES];
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
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/group/%@/role/%@/analyses",kBaseUrl,user.groupID,user.roleID]
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


-(void)getSomeThingNew {
    user = [[User alloc]init];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/role/%@/analyses",kBaseUrl,user.groupID,user.roleID];
    NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    NSString*fileName =  @"home_report";
    javascriptPath = [javascriptPath stringByAppendingPathComponent:fileName];
    if ([HttpUtils isNetworkAvailable3]) {
        HttpResponse *reponse = [HttpUtils httpGet:kpiUrl];
        if ([reponse.statusCode  isEqual: @200] || [HttpUtils isNetworkAvailable3]) {
            NSData *data = reponse.received;
            if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
                [FileUtils removeFile:javascriptPath];
            }
            [reponse.received writeToFile:javascriptPath atomically:YES];
            NSArray *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
            NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:dic error:nil];
            self.listArray = [array copy];
            [self initCategoryMenu];
        }
        else{
            NSData *data = [NSData dataWithContentsOfFile:javascriptPath];
            NSArray *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
            if (!data || dic.count == 0) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"重新加载" actionBlock:^(void) {
                        [self getSomeThingNewRefresh];
                    }];
                    [alert showSuccess:self title:@"温馨提示" subTitle:@"暂无数据" closeButtonTitle:nil duration:0.0f];
            }
          
        }
    }
    else{
        NSData *data = [NSData dataWithContentsOfFile:javascriptPath];
        if (!data) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"重新加载" actionBlock:^(void) {
                [self getSomeThingNewRefresh];
            }];
            [alert showSuccess:self title:@"温馨提示" subTitle:@"请检查您的网络状态" closeButtonTitle:nil duration:0.0f];
        }
        else {
        NSArray *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
        NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:dic error:nil];
        self.listArray = [array copy];
        [self initCategoryMenu];
        }
    }
}

-(void)getSomeThingNewRefresh {
    user = [[User alloc]init];
    NSString *kpiUrl = [NSString stringWithFormat:@"%@/api/v1/group/%@/role/%@/analyses",kBaseUrl,user.groupID,user.roleID];
    NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    NSString*fileName =  @"home_report";
    javascriptPath = [javascriptPath stringByAppendingPathComponent:fileName];
    if ([HttpUtils isNetworkAvailable3]) {
        HttpResponse *reponse = [HttpUtils httpGet:kpiUrl];
        if ([reponse.statusCode  isEqual: @200] || [HttpUtils isNetworkAvailable3]) {
            NSData *data = reponse.received;
            if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
                [FileUtils removeFile:javascriptPath];
            }
            [reponse.received writeToFile:javascriptPath atomically:YES];
            NSArray *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
            NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:dic error:nil];
            self.listArray = [array copy];
            [self initCategoryMenu];
        }
        else{
            NSData *data = [NSData dataWithContentsOfFile:javascriptPath];
            NSArray *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
            if (!data || dic.count == 0) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert addButton:@"重新加载" actionBlock:^(void) {
                    [self getSomeThingNewRefresh];
                }];
                [alert showSuccess:self title:@"温馨提示" subTitle:@"暂无数据" closeButtonTitle:nil duration:0.0f];
            }
            
        }
    }
    else{
        NSData *data = [NSData dataWithContentsOfFile:javascriptPath];
        if (!data) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"确定" actionBlock:^(void) {
               // [self getSomeThingNewRefresh];
            }];
            [alert showSuccess:self title:@"温馨提示" subTitle:@"请检查您的网络状态" closeButtonTitle:nil duration:0.0f];
        }
        else {
            NSArray *dic = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"data"];
            NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:dic error:nil];
            self.listArray = [array copy];
            [self initCategoryMenu];
        }
    }
}


@end
