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

static NSString *const kReportSelectorSegueIdentifier = @"ToReportSelectorSegueIdentifier";

@interface ScanResultViewController() <UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
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
    
    /**htmlContent
     *  被始化页面样式
     */
    [self idColor];
    self.bannerView.backgroundColor = [UIColor colorWithHexString:kBannerBgColor];
    self.labelTheme.textColor = [UIColor colorWithHexString:kBannerTextColor];
    
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
    storeID = cacheDict[@"store"][@"id"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APIHelper barCodeScan:self.user.userNum group:self.user.groupID role:self.user.roleID store:storeID code:self.codeInfo type:self.codeType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            [self.browser loadHTMLString:[self htmlContentWithTimestamp] baseURL:[NSURL fileURLWithPath:self.htmlPath]];
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
    
    /*SelectStoreViewController *select = [[SelectStoreViewController alloc] init];
    [self presentViewController:select animated:YES completion:nil];*/
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
    }];
}

- (void)actionWebviewScreenShot{
    UIImage *image = [self saveWebViewAsImage];
    
    // End the graphics context
    UIGraphicsEndImageContext();
    
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

- (UIImage *)saveWebViewAsImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize boundsSize = self.browser.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    CGSize contentSize = self.browser.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    CGPoint offset = self.browser.scrollView.contentOffset;
    [self.browser.scrollView setContentOffset:CGPointMake(0, 0)];
    NSMutableArray *images = [NSMutableArray array];
    //将整个webview 分成若干图片
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);//生成一个透明的图形
        [self.browser.layer renderInContext:UIGraphicsGetCurrentContext()];//使用webview内容渲染该图形
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//获取该图形
        UIGraphicsEndImageContext();//关闭上下文
        [images addObject:image];
        CGFloat offsetY = self.browser.scrollView.contentOffset.y;
        [self.browser.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    [self.browser.scrollView setContentOffset:offset];
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    //将数组中的每一图片重写编写位置。并生成完整的图片
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
        [APIHelper actionLog:logParams];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
@end
