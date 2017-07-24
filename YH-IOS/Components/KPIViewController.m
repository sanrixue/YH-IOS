//
//  KPIViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "KPIViewController.h"
#import "ThurSayViewController.h"

@interface KPIViewController ()

@end

@implementation KPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *uiVersion = [FileUtils currentUIVersion];
    self.urlString = [NSString stringWithFormat:kKPIMobilePath, kBaseUrl, uiVersion, self.user.groupID, self.user.roleID];
    self.commentObjectType = ObjectTypeKpi;
    self.browser.backgroundColor = [UIColor whiteColor];
    self.browser = [[UIWebView alloc]initWithFrame:CGRectMake(.0f, self.view.origin.y,self.view.frame.size.width,self.view.frame.size.height - self.tabBarController.tabBar.height -10)];
    //self.browser = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview: self.browser];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadWebView];
    [self isLoadHtmlFromService];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)loadWebView {
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    
    [self addWebViewJavascriptBridge];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.browser.scrollView addSubview:refreshControl]; //<- this is point to use. Add "scrollView" property.
}

#pragma mark - UIWebview pull down to refresh
-(void)handleRefresh:(UIRefreshControl *)refresh {
    [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
    [self loadHtml];
    [refresh endRefreshing];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = @"刷新/评论页面/浏览器";
        logParams[kObjTitleALCName] = self.urlString;
        [APIHelper actionLog:logParams];
    });
}



- (void)addWebViewJavascriptBridge {
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*
             * 用户行为记录, 单独异常处理，不可影响用户体验
             */
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[kActionALCName]   = @"JS异常";
                logParams[kObjTypeALCName]  = @(self.commentObjectType);
                logParams[kObjTitleALCName] = [NSString stringWithFormat:@"主页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self isLoadHtmlFromService];
    }];
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data[@"link"] isEqualToString:@""]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"该功能正在开发中"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SubjectViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
                subjectView.bannerName = data[@"bannerName"];
                subjectView.link = data[@"link"];
                subjectView.objectID = data[@"objectID"];
              if ([data[@"link"] rangeOfString:@"template/3/"].location != NSNotFound) {
                NSArray * models = [HomeIndexModel homeIndexModelWithJson:nil withUrl:data[@"link"]];
                HomeIndexVC *vc = [[HomeIndexVC alloc] init];
                vc.dataLink = data[@"link"];
                vc.bannerTitle = data[@"bannerName"];
                 [vc setWithHomeIndexArray:models];
                  UINavigationController *rootchatNav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:rootchatNav animated:YES completion:nil];
              }
              else if ([data[@"link"] rangeOfString:@"template/5/"].location != NSNotFound) {
                  SuperChartVc *superChaerCtrl = [[SuperChartVc alloc]init];
                  superChaerCtrl.bannerTitle = data[@"bannerName"];
                  superChaerCtrl.dataLink = data[@"link"];
                  UINavigationController *superChartNavCtrl = [[UINavigationController alloc]initWithRootViewController:superChaerCtrl];
                  [self presentViewController:superChartNavCtrl animated:YES completion:nil];
              }
              /*else if ([data[@"link"] rangeOfString:@"template/"].location != NSNotFound){
                  if ([data[@"link"] rangeOfString:@"template/5/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/1/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/2/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/3/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/4/"].location == NSNotFound || [data[@"link"] rangeOfString:@"template/-1/"].location == NSNotFound) {
                      SCLAlertView *alert = [[SCLAlertView alloc] init];
                      [alert addButton:@"下一次" actionBlock:^(void) {}];
                      [alert addButton:@"立刻升级" actionBlock:^(void) {
                          NSURL *url = [NSURL URLWithString:[kPgyerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                          [[UIApplication sharedApplication] openURL:url];
                      }];
                      [alert showSuccess:self title:@"温馨提示" subTitle:@"您当前的版本暂不支持该模块，请升级之后查看" closeButtonTitle:nil duration:0.0f];
                  }
              }*/
              else{ //跳转事件
                  UINavigationController *subjectCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
                  [self presentViewController:subjectCtrl animated:YES completion:nil];
              }
        }
    }];
    
    [self.bridge registerHandler:@"dashboardDataCount" handler:^(id data, WVJBResponseCallback responseCallback) {
        // NSString *tabType = data[@"tabType"];
        // NSNumber *dataCount = data[@"dataCount"];
    }];
    
    [self.bridge registerHandler:@"hideAd" handler:^(id data, WVJBResponseCallback responseCallback) {
        //[self hideAdertWebView];
    }];
    
    /* [self.bridge registerHandler:@"pageTabIndex" handler:^(id data, WVJBResponseCallback responseCallback) {
     NSString *action = data[@"action"];
     NSNumber *tabIndex = data[@"tabIndex"];
     
     if([action isEqualToString:@"store"]) {
     self.behaviorDict[kMessageUBCName][kTabIndexUBCName] = tabIndex;
     [self.behaviorDict writeToFile:self.behaviorPath atomically:YES];
     }
     else if([action isEqualToString:@"restore"]) {
     tabIndex = self.behaviorDict[kMessageUBCName][kTabIndexUBCName];
     
     responseCallback(tabIndex);
     }
     else {
     NSLog(@"unkown action %@", action);
     }
     }];*/
}

-(void)isLoadHtmlFromService {
    if ([HttpUtils isNetworkAvailable3]) {
        [self loadHtml];
    }
    else{
        [self clearBrowserCache];
        NSString *filename = [self urlTofilename:self.urlString suffix:@".html"][0];
        NSString *filepath = [self.assetsPath stringByAppendingPathComponent:filename];
        NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:filepath];
        if (![FileUtils checkFileExist:filepath isDir:NO] || ([htmlContent length] == 0 )) {
            [self showLoading:LoadingRefresh];
        }
        else {
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
        }
    }
}

#pragma mark - assistant methods

- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:kIAlreadyKnownText actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:kWarmTitleText subTitle:kAppForbiedUseText closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else if([httpResponse.statusCode isEqualToNumber:@(304)]){
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        else {
            /* UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"更新出错"
             message:httpResponse.errors[0]
             preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
             handler:^(UIAlertAction * action) {
             [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
             [self loadHtml];
             }];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];*/
            dispatch_async(dispatch_get_main_queue(), ^{
               [ViewUtils showPopupView:self.view Info:@"加载最新失败，请手动刷新"];
                [self clearBrowserCache];
                NSString *filename = [self urlTofilename:self.urlString suffix:@".html"][0];
                NSString *filepath = [self.assetsPath stringByAppendingPathComponent:filename];
                NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:filepath];
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
            });

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:self.sharedPath]];
            
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
