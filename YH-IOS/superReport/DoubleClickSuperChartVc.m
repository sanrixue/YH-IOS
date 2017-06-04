//
//  DoubleClickSuperChartVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/25.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "DoubleClickSuperChartVc.h"
#import "TableViewAndCollectionPackage.h"
#import "DoubleClickSuperChartCell.h"
#import "DoubleClickSuperChartHeaderCell.h"
#import "UMSocial.h"
#import "APIHelper.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "CommentViewController.h"

@interface DoubleClickSuperChartVc ()<DropViewDelegate,DropViewDataSource,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  TableViewAndCollectionPackage* package;
@property (nonatomic, strong) NSArray* dataList;
@property (nonatomic, assign) NSInteger column;
//@property (nonatomic, strong) NSArray* heads;
@property (nonatomic, strong) TableDataBaseItemModel* maxItem;
@property (nonatomic, strong) SuperChartMainModel* superModel;
@property (nonatomic, strong) UIButton* clearBackBtn;
@property (nonatomic, strong) NSMutableArray* array;
@property (nonatomic, strong) NSMutableArray* baseArray;
@property (strong, nonatomic) NSArray *dropMenuTitles;
@property (strong, nonatomic) NSArray *dropMenuIcons;

@end

@implementation DoubleClickSuperChartVc


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Banner-Setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];
    [self.navigationController setNavigationBarHidden:false];
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
    [self initPackage];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setWithSuperModel:(SuperChartMainModel*)superModel column:(NSInteger)column{
//    _heads = heades;
    _superModel = superModel;
    _dataList = [superModel.table showData];
    _column = column;
    [self initDropMenu];
    _array = [NSMutableArray array];
  //  NSMutableArray *demoArray = [NSMutableArray array];
    for (NSArray* array in _dataList) {
        TableDataBaseItemModel *item = array[column];
       // for (TableDataBaseItemModel* table in demoArray) {
            [_array addObject:item];
        //}
    }
    self.baseArray = [NSMutableArray arrayWithArray:_array];
   _array = [NSArray sortArray:_array key:@"value" down:YES];
  /*  [_superModel.table.dataSet removeAllObjects];
    for (TableDataBaseItemModel* item in _array) {
        int index = item.lineTag;
        [_superModel.table.dataSet addObject:@(index)];
    }*/
    if (_array.count) {
            self.maxItem = _array[0];
    }
   /* NSMutableArray *inModelArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 2; i++) {
        NSArray* modelArray = [_superModel.table showData][i];
        TableDataBaseItemModel* demo = modelArray[0];
        [inModelArray addObject:demo];
    }
    _keyArray = inModelArray;*/
    [self.tableView reloadData];
}


#pragma 下拉菜单功能块
- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    if(kSubjectShare) {
        [tmpTitles addObject:kDropShareText];
        [tmpIcons addObject:@"Subject-Share"];
    }
    if(kSubjectComment) {
        [tmpTitles addObject:kDropCommentText];
        [tmpIcons addObject:@"Subject-Comment"];
    }
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
        
        if([itemName isEqualToString:kDropCommentText]) {
            [self actionWriteComment];
        }
        else if([itemName isEqualToString:kDropShareText]) {
            [self actionWebviewScreenShot];
        }
        else if ([itemName isEqualToString:kDropRefreshText]){
            [self.tableView reloadData];
        }
    }];
    
}

- (void)actionWriteComment{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    subjectView.bannerName = _bannerName;
    [self.navigationController presentViewController:subjectView animated:YES completion:nil];
}



#pragma 分享图片

- (void)actionWebviewScreenShot{
    UIImage *image = [self createViewImage:self.navigationController.view];
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1ull *NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [UMSocialData defaultData].extConfig.title = kWeiXinShareText;
        [UMSocialData defaultData].extConfig.qqData.url = kBaseUrl;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUMAppId
                                          shareText:self.title
                                         shareImage:image
                                    shareToSnsNames:@[UMShareToWechatSession]
                                           delegate:self];
    });
}

- (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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



-(void)initPackage{
    __WEAKSELF;
    self.package = [TableViewAndCollectionPackage instanceWithScrollView:self.tableView delegate:nil cellBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        
        DoubleClickSuperChartCell* cell = [DoubleClickSuperChartCell cellWithTableView:weakSelf.tableView needXib:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TableDataBaseItemModel* table = weakSelf.array[indexPath.row];
        
      //  TableDataBaseItemModel* item = _baseArray[indexPath.row];
        TableDataBaseItemModel* item = _baseArray[indexPath.row];
        CGFloat scale = 0.0;
        if (weakSelf.maxItem.value.doubleValue>0 && item.value.doubleValue >0) {
            scale = item.value.doubleValue/weakSelf.maxItem.value.doubleValue;
            scale = scale<0? 0:scale;
        }
        else if (weakSelf.maxItem.value.doubleValue <=0 && item.value.doubleValue <=0){
            scale =  weakSelf.maxItem.value.doubleValue/item.value.doubleValue;
            scale = scale<0? 0:scale;
        }
        else if (weakSelf.maxItem.value.doubleValue >0 && item.value.doubleValue <=0){
            scale = 0;
        }
        NSArray* modelArray = _dataList[indexPath.row];
        TableDataBaseItemModel* demo = modelArray[0];
        [cell.titleBtn setTitle:demo.value forState:UIControlStateNormal];
        cell.valueLab.text = item.value;
        cell.titleBtn.titleLabel.numberOfLines = _lineNumber;
        cell.barView.scale = scale;
       // NSString* color = item.color;
        NSString* color = weakSelf.superModel.config.color[table.color.integerValue];
        cell.barView.barColor = color.toColor;//[UIColor redColor];
        NSString* cellValueColor =_superModel.config.color[[demo.color integerValue]];
        cell.valueLab.textColor = [UIColor colorWithHexString:cellValueColor];
        
        cell.doubleBack = ^(id item){
            [weakSelf popNeedAnimation:YES];
        };
        config.cell = cell;
        
    } sectionNumBack:^(PackageConfig *config) {
        config.sectionNum = 1;
        config.estimateHeight = 50;
        config.rowHeight = 40+(_lineNumber-1)*20;
        config.cellNum = weakSelf.dataList.count;
    } cellSizeBack:^(NSIndexPath *indexPath, PackageConfig *config) {
        
    } cellNumBack:^(NSInteger section, PackageConfig *config) {
        
    } selectedBack:^(NSIndexPath *indexPath) {
        
    }];
    [self.package addHeaderBack:^(NSInteger section, PackageConfig *config) {
        
        DoubleClickSuperChartHeaderCell* header = [DoubleClickSuperChartHeaderCell cellWithTableView:weakSelf.tableView needXib:YES];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        header.userInteractionEnabled=YES;
        [header.titleBtn setTitle:weakSelf.titleString forState:UIControlStateNormal];
       // [header.titleBtn setTitle:@"这个人" forState:UIControlStateNormal];
        [header.rightBtn setTitle:weakSelf.superModel.table.showhead[weakSelf.column].value forState:UIControlStateNormal];
        [header.rightBtn addTarget:weakSelf action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
      //  [header.rightBtn setTitle:weakSelf.keyArray[weakSelf.column].value forState:UIControlStateNormal];
        header.sortBack = weakSelf.sortBack;
        [header.rightBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
        config.header = header;
        if (!weakSelf.isSort) {
               [header.rightBtn setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
        }
        else{
            if (weakSelf.isdownImage) {
                [header.rightBtn setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
            }
            else if(!weakSelf.isdownImage){
                [header.rightBtn setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
            }
        }
    } headerSizeBack:^(NSInteger section, PackageConfig *config) {
        config.headerHeight = 45;
    } orFooterBack:nil footerSizeBack:nil];
}

-(void)changeImage:(UIButton*)sender{
    _isSort = YES;
    _isdownImage = !_isdownImage;
    if (_isdownImage) {
        [sender setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
    }
    else {
        [sender setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
    }
}

@end
