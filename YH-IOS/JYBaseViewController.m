//
//  JYBaseViewController.m
//  YH-IOS
//
//  Created by li hao on 17/5/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "JYBaseViewController.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "ViewUtils.h"
#import "NewSettingViewController.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "User.h"
#import "JumpCommonView.h"

@interface JYBaseViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
// 设置按钮点击下拉菜单
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;
@property (nonatomic, strong) User* user;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (nonatomic, strong) NSMutableArray* menuArray;
@property (nonatomic, assign) NSInteger curLineNum;
@property (nonatomic, strong) JumpCommonView* menuView;

@end

@implementation JYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Banner-Logo"]];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(self.view.frame.size.width/2-50, 0, 100, 50);
    [self.navigationController.navigationBar addSubview:imageView];
    self.user = [[User alloc] init];
    [self initDropMenu];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
     //self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.sharedPath = [FileUtils sharedPath];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
    [JumpCommonView clearMenu]; // 清除window菜单
    [self initDropMenu]; //重新生成菜单
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Banner-Setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}


- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    
    if(kDropMenuScan) {
        [tmpTitles addObject:kDropMentScanText];
        [tmpIcons addObject:@"DropMenu-Scan"];
    }
    
    if(kDropMenuVoice) {
        [tmpTitles addObject:kDropMentVoiceText];
        [tmpIcons addObject:@"DropMenu-Voice"];
    }
    
    if(kDropMenuSearch) {
        [tmpTitles addObject:kDropMentSearchText];
        [tmpIcons addObject:@"DropMenu-Search"];
    }
    
    if(kDropMenuUserInfo) {
        [tmpTitles addObject:kDropMentUserInfoText];
        [tmpIcons addObject:@"DropMenu-UserInfo"];
    }
    // [tmpTitles addObject:@"原生报表"];
    //[tmpIcons addObject:@"DropMenu-UserInfo"];
    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - action methods

/**
 *  标题栏设置按钮点击显示下拉菜单
 *
 *  @param sender
 */
-(void)dropTableView:(UIBarButtonItem *)sender {
    DropViewController *dropTableViewController = [[DropViewController alloc]init];
    dropTableViewController.view.frame = CGRectMake(0, 0, 150, 150);
    dropTableViewController.preferredContentSize = CGSizeMake(150,self.dropMenuTitles.count*150/4);
    dropTableViewController.dataSource = self;
    dropTableViewController.delegate = self;
    UIPopoverPresentationController *popover = [dropTableViewController popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = self.navigationItem.rightBarButtonItem;
    popover.delegate = self;
    [popover setSourceRect:sender.customView.frame];
    [popover setSourceView:self.view];
    popover.backgroundColor = [UIColor colorWithHexString:kDropViewColor];
    [self presentViewController:dropTableViewController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(NSInteger)numberOfPagesIndropView:(DropViewController *)flowView{
    return self.dropMenuTitles.count;
}

-(UITableViewCell *)dropView:(DropViewController *)flowView cellForPageAtIndex:(NSIndexPath *)index{
    DropTableViewCell*  cell = [[DropTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dorpcell"];
    cell.tittleLabel.text = self.dropMenuTitles[index.row];
    cell.iconImageView.image = [UIImage imageNamed:self.dropMenuIcons[index.row]];
    
    UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
    cellBackView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackView;
    cell.tittleLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(void)dropView:(DropViewController *)flowView didTapPageAtIndex:(NSIndexPath *)index{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *itemName = self.dropMenuTitles[index.row];
        
        if([itemName isEqualToString:kDropMentScanText]) {
            [self actionBarCodeScanView:nil];
        }
        else if([itemName isEqualToString:kDropMentVoiceText]) {
            [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
        }
        else if([itemName isEqualToString:kDropMentSearchText]) {
            [ViewUtils showPopupView:self.view Info:@"功能开发中，敬请期待"];
        }
        else if([itemName isEqualToString:kDropMentUserInfoText]) {
            NewSettingViewController *settingViewController = [[NewSettingViewController alloc]init];
            UINavigationController *userInfoViewControlller = [[UINavigationController alloc]initWithRootViewController:settingViewController];
            [self presentViewController:userInfoViewControlller animated:YES completion:nil];
        }
    }];
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
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
