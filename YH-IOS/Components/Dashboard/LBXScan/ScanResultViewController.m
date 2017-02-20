//
//  ScanResultViewController.m
//  YH-IOS
//
//  Created by lijunjie on 16/06/07.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "ScanResultViewController.h"
#import "APIHelper.h"
#import "SelectStoreViewController.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"
#import "UMSocial.h"
#import "ManualInputViewController.h"
#import "SubLBXScanViewController.h"

static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface ScanResultViewController() <UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UMSocialDataDelegate,UMSocialUIDelegate> {
    NSMutableDictionary *betaDict;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintBannerView;
@property (strong, nonatomic) NSString *htmlContent;
@property (strong, nonatomic) NSString *htmlPath;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) NSArray *dropMenuTitles;
@property (strong, nonatomic) NSArray *dropMenuIcons;
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self idColor];
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"DashboardViewController - Response for message from ObjC");
    }];
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self loadHtml];
    }];
    
    self.htmlPath = [FileUtils sharedDirPath:kBarCodeScanFolderName FileName:kBarCodeScanFileName];
    self.htmlContent = [NSString stringWithContentsOfFile:self.htmlPath encoding:NSUTF8StringEncoding error:nil];

    [self.selectBtn addTarget:self action:@selector(actionJumpToSelectStoreViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self clearBrowserCache];
    [self loadHtml];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self clearBrowserCache];
    [self showLoading:LoadingLoad];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
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
    
    NSString *cacheJsonPath = [FileUtils dirPath:kCachedDirName FileName:kBarCodeResultFileName];
    NSMutableDictionary *cacheDict = [FileUtils readConfigFile:cacheJsonPath];
    
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *storeID = @"-1";
    if ((!cacheDict[@"store"] || !cacheDict[@"store"][@"id"]) &&
        userDict[kStoreIDsCUName] && [userDict[kStoreIDsCUName] count] > 0) {
        
        cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
        [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
    }
    else {
        // 缓存的门店信息可能过期，判断是否在用户权限门店列表中（user.plist）
        BOOL isExpired = YES;
        NSDictionary *storeDict = [NSDictionary dictionary];
        for(NSInteger i = 0, len = [userDict[kStoreIDsCUName] count]; i < len; i++) {
            storeDict = userDict[kStoreIDsCUName][i];
            if(storeDict[@"name"] && storeDict[@"id"] && ([storeDict[@"id"] integerValue] == [cacheDict[@"store"][@"id"] integerValue])) {
                isExpired = NO;
                break;
            }
        }
        
        if(isExpired) {
            cacheDict[@"store"] = userDict[kStoreIDsCUName][0];
            [FileUtils writeJSON:cacheDict Into:cacheJsonPath];
        }
    }
    
    storeID = cacheDict[@"store"][@"id"];
    self.labelTheme.text = cacheDict[@"store"][@"name"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      BOOL jsonFormateRight = [APIHelper barCodeScan:self.user.userNum group:self.user.groupID role:self.user.roleID store:storeID code:self.codeInfo type:self.codeType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            if (jsonFormateRight) {
                [self.browser loadHTMLString:[self htmlContentWithTimestamp] baseURL:[NSURL fileURLWithPath:self.htmlPath]];
            }
            else {
                [self showLoading:LoadingRefresh];
            }
        });
    });
}

#pragma mark
- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    [tmpTitles addObject:kDropShareText];
    [tmpIcons addObject:@"Subject-Share"];
    [tmpTitles addObject:kDropSearchText];
    [tmpIcons addObject:@"Subject-Search"];
    [tmpTitles addObject:kDropRefreshText];
    [tmpIcons addObject:@"Subject-Refresh"];
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}

- (void)actionJumpToSelectStoreViewController:(UIButton *)sender {
    
    [self initDropMenu];
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width / 3.2, 150 / 4 * self.dropMenuTitles.count);
    dropTableViewController.modalPresentationStyle = UIModalPresentationPopover;
    [dropTableViewController setPreferredContentSize:CGSizeMake(self.view.frame.size.width / 3.2, 150 / 4 * self.dropMenuTitles.count)];
    dropTableViewController.view.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    dropTableViewController.dropTableView.delegate = self;
    dropTableViewController.dropTableView.dataSource =self;
    
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.delegate = self;
    [popover setSourceRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 12, sender.frame.size.width, sender.frame.size.height)];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}

# pragma mark - UITableView Delgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dropMenuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dorpcell"];
    if (!cell) {
        cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    }
    cell.tittleLabel.text = self.dropMenuTitles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[indexPath.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = cellBackView;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150 / 4;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[indexPath.row];

        if([itemName isEqualToString:kDropSearchText]) {
            SelectStoreViewController *select = [[SelectStoreViewController alloc] init];
             [self presentViewController:select animated:YES completion:nil];
        }
        else if([itemName isEqualToString:kDropShareText]) {
            [self actionWebviewScreenShot];
        }
        else if ([itemName isEqualToString:kDropRefreshText]) {
            [self loadHtml];
        }
    }];
}

- (void)actionWebviewScreenShot {
    UIImage *image;
    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName];
    betaDict = [FileUtils readConfigFile:settingsConfigPath];
    if (!betaDict[@"image_within_screen"] || [betaDict[@"image_within_screen"] boolValue]) {
        image = [self saveWebViewAsImage];
    }
    else {
        image = [self getImageFromCurrentScreen];
    }
    // End the graphics context
    UIGraphicsEndImageContext();
    
#pragma todo# 分享文字
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.title = kWeiXinShareText;
    [UMSocialData defaultData].extConfig.qqData.url = kBaseUrl;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppId
                                      shareText:NULL
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession]
                                       delegate:self];
}

- (UIImage *)getImageFromCurrentScreen {
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


- (UIImage *)saveWebViewAsImage {
    UIScrollView *scrollview = self.browser.scrollView;
    UIImage *image = nil;
    CGSize boundsSize = self.browser.scrollView.contentSize;
    if (boundsSize.height > kScreenHeight * 6) {
        boundsSize.height = kScreenHeight * 6;
    }
    UIGraphicsBeginImageContextWithOptions(boundsSize ,NO, 0.0);
    CGPoint savedContentOffset = scrollview.contentOffset;
    CGRect savedFrame = scrollview.frame;
    scrollview.contentOffset = CGPointZero;
    scrollview.frame = CGRectMake(0,0, boundsSize.width, boundsSize.height);
    
    // 将scrollView的layer渲染到上下文中
    [scrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scrollview.contentOffset = savedContentOffset;
    scrollview.frame = savedFrame;
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    UIImage *fullImage = [UIImage imageWithData:imageData];
    return fullImage;
}

- (NSString *)htmlContentWithTimestamp {
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000 + arc4random()];
    NSString *newHtmlContent = [self.htmlContent stringByReplacingOccurrencesOfString:@"TIMESTAMP" withString:timestamp];

    return newHtmlContent;
}

#pragma mark - ibaction block
- (IBAction)actionBack:(id)sender {
    [super dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_VIEW" object:nil userInfo:nil];
        [self.browser stopLoading];
        [self.browser cleanForDealloc];
        self.browser.delegate = nil;
        self.browser = nil;
        [self.progressHUD hide:YES];
        self.progressHUD = nil;
        self.bridge = nil;
    }];
}


#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享(%d)", fromViewControllerType];
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"]  && [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

// 下面得到分享完成的回调
// {
//    data = {
//        wxsession = "";
//    };
//    responseCode = 200;
//    responseType = 5;
//    thirdPlatformResponse = "<SendMessageToWXResp: 0x136479db0>";
//    viewControllerType = 3;
// }
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    /*
     * 用户行为记录, 单独异常处理，不可影响用户体验
     */
    @try {
        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
        logParams[kActionALCName]   = [NSString stringWithFormat:@"微信分享完成(%d)", response.viewControllerType];
        logParams[kScreenshotType] = ( betaDict[@"image_within_screen"]&& [betaDict[@"image_within_screen"] boolValue]) ? @"screenIamge" : @"allImage";
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
@end
