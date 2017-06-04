//
//  SuperChartVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "SuperChartVc.h"
#import "UIBarButtonItem+Category.h"
#import "CommonMenuView.h"
#import "SelectListVc.h"
#import "FormScrollView.h"
#import "SuperChartModel.h"
#import "ChangeLineSpaceVc.h"
#import "FilterSuperChartVc.h"
#import "DoubleClickSuperChartVc.h"
#import "SuperChartMainModel.h"
#import "UMSocial.h"
#import "APIHelper.h"
#import "DropTableViewCell.h"
#import "DropViewController.h"
#import "CommentViewController.h"

const static CGFloat lineHeight = 40; //一行的高度

@interface SuperChartVc () <FDelegate,FDataSource,DropViewDelegate,DropViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) NSArray* menuArray;
@property (nonatomic, assign) NSInteger curLineNum;
@property (nonatomic, strong) CommonMenuView* menuView;
@property (nonatomic, strong) FormScrollView* formView;
@property (nonatomic, strong) NSArray* data; //报表数据
@property (nonatomic, strong) NSArray* headerData; //头部数据
@property (nonatomic, strong) SuperChartModel* superModel;
@property (nonatomic, strong) SuperChartMainModel *mainmeode;
@property (nonatomic, strong) NSArray* colorArray;
@property (nonatomic, assign) BOOL isdownImage;
@property (nonatomic, assign) NSInteger clickBtn;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, strong)  UIView *bgView;
@property (strong, nonatomic) NSArray *dropMenuTitles;
@property (strong, nonatomic) NSArray *dropMenuIcons;
@property (nonatomic, assign) NSInteger rowNum;

@end

@implementation SuperChartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSort = NO;
    _isdownImage = YES;
    _clickBtn = -1;
   // _superModel = [SuperChartModel testModel];
   // [self setForSuperChartModel:_mainmeode];
    //[self setForSuperChartModel:_superModel];
    self.title = self.bannerTitle;
    [self formView];
    [CommonMenuView clearMenu]; // 清除window菜单; //重新生成菜单
    _curLineNum = 2;
    [self initDropMenu];
    [self getSuperChartData];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.allowRotation = YES;
}

- (void)setForSuperChartModel:(SuperChartMainModel*)superModel{
   // _superModel = superModel;
   // _headerData = [superModel.table showhead];
   // _data = [superModel.table showData];
    _headerData = [_mainmeode.table showhead];
    _data = [_mainmeode.table showData];
    _colorArray = [NSArray  arrayWithArray:_mainmeode.config.color];
    [self.formView reloadData];
}

- (void)getSuperChartData{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview: _bgView];
    _bgView.backgroundColor = [UIColor clearColor];
    [MRProgressOverlayView showOverlayAddedTo:_bgView title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      _mainmeode = [SuperChartMainModel testModel:_dataLink];
        dispatch_async(dispatch_get_main_queue(), ^{
                [MRProgressOverlayView dismissAllOverlaysForView:_bgView animated:YES];
            [_bgView setHidden:YES];
                [self setForSuperChartModel:_mainmeode];
        });
    });
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.formView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Banner-Setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(dropTableView:)];
    self.title = self.bannerTitle;
}
/** 展示菜单 */
- (void)showMenu:(UIButton*)sender{
    self.menuView = nil;
    self.menuArray = [self getMymenuArray];
    [CommonMenuView showMenuAtPoint:CGPointMake(sender.centerX, sender.bottom)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}


#pragma 下拉菜单功能块
- (void)initDropMenu {
    NSMutableArray *tmpTitles = [NSMutableArray array];
    NSMutableArray *tmpIcons = [NSMutableArray array];
    [tmpTitles addObject:@"选列"];
    [tmpIcons addObject:@"选列"];
    [tmpTitles addObject:@"筛选"];
    [tmpIcons addObject:@"筛选"];
    [tmpTitles addObject:@"行高"];
    [tmpIcons addObject:@"行高"];
    if(kSubjectShare) {
        [tmpTitles addObject:kDropShareText];
        [tmpIcons addObject:@"Subject-Share"];
    }
    if(kSubjectComment) {
        [tmpTitles addObject:kDropCommentText];
        [tmpIcons addObject:@"Subject-Comment"];
    }
    [tmpTitles addObject:kDropRefreshText];
    [tmpIcons addObject:@"Subject-Refresh"];

    self.dropMenuTitles = [NSArray arrayWithArray:tmpTitles];
    self.dropMenuIcons = [NSArray arrayWithArray:tmpIcons];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
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
            [self getSuperChartData];
        }
        else if ([itemName isEqualToString:@"选列"]) {
            [self selectList];
        }
        else if ([itemName isEqualToString:@"行高"]) {
            [self selectLineSpace];
        }
        else if ([itemName isEqualToString:@"筛选"]) {
            [self FilterAction];
        }
    }];
    
}

- (void)actionWriteComment{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentViewController *subjectView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    subjectView.bannerName = self.bannerTitle;
    subjectView.objectID =self.objectID;
    subjectView.commentObjectType = self.commentObjectType;
    UINavigationController *commentCtrl = [[UINavigationController alloc]initWithRootViewController:subjectView];
    [self.navigationController presentViewController:commentCtrl animated:YES completion:nil];
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

#pragma  列表

- (void)selectList{ // 选择列表
    SelectListVc* vc = [[SelectListVc alloc] init];
   // [vc setWithTableData:_superModel.table];
    [vc setWithTableData:_mainmeode.table];
  //  __weak typeof(vc) weakVc = vc;
    vc.usedBack = ^(id item){
        [self setForSuperChartModel:_mainmeode];
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:vc animated:YES completion:nil];
    });
}

- (void)selectLineSpace{ // 选择行距
    ChangeLineSpaceVc* vc = [[ChangeLineSpaceVc alloc] init];
    vc.curLineNum = _curLineNum;
    vc.usedBack = ^(ChangeLineSpaceVc* item){
        self.curLineNum = item.curLineNum;
        [self.formView removeFromSuperview]; // 先删除报表
        self.formView = nil;
        [self.formView reloadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

/** 过滤 */
- (void)FilterAction{
    FilterSuperChartVc* vc = [[FilterSuperChartVc alloc] init];
    vc.superModel = _mainmeode;
    vc.usedBack = ^(FilterSuperChartVc* item){
       [self setForSuperChartModel:_mainmeode];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 表格代理
- (FTopLeftHeaderView *)topLeftHeadViewForForm:(FormScrollView *)formScrollView {
    FTopLeftHeaderView *view = [formScrollView dequeueReusableTopLeftView];
    if (view == NULL) {
        view = [[FTopLeftHeaderView alloc] initWithSectionTitle:@"行数" columnTitle:@"列数"];
        UILabel* lab = [[UILabel alloc] init];
        lab.backgroundColor = [UIColor whiteColor];
        TableDataBaseItemModel* model = _headerData[0];
        lab.text = model.value;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [AppColor app_3color];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);//.insets(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
    }
    [view setBorderColor:[AppColor app_9color] width:0.5];
    return view;
}

- (NSInteger)numberOfSection:(FormScrollView *)formScrollView {
    return _data.count;
}
- (NSInteger)numberOfColumn:(FormScrollView *)formScrollView {
    return _headerData.count-1;
}
- (CGFloat)heightForSection:(FormScrollView *)formScrollView {
    return lineHeight+((_curLineNum-1)*14);
}
- (CGFloat)heightForSectionHeader:(FormScrollView *)formScrollView{
    return lineHeight + 10;
   // return 0;
}


- (CGFloat)widthForColumn:(FormScrollView *)formScrollView {
    return 100;
}

- (CGFloat)widthForColumnHeader:(FormScrollView *)formScrollView{
    return 120;
}

- (FormSectionHeaderView *)form:(FormScrollView *)formScrollView sectionHeaderAtSection:(NSInteger)section {
    FormSectionHeaderView *header = [formScrollView dequeueReusableSectionWithIdentifier:@"Section"];
    if (header == NULL) {
        header = [[FormSectionHeaderView alloc] initWithIdentifier:@"Section"];
    }
    TableDataBaseItemModel* model;
    NSMutableArray *inModelArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _data.count; i++) {
        NSArray *modelArray = _data[i];
        [inModelArray addObject:modelArray[0]];
    }
    model = inModelArray[section];
   // header.titleLabel.adjustsFontSizeToFitWidth = YES;
    header.titleLabel.font = [UIFont systemFontOfSize:12];
    //int numer = (short)_curLineNum;
    header.titleLabel.numberOfLines = _curLineNum;
    [header setTitleColor:[AppColor app_3color] forState:UIControlStateNormal];
    [header setTitle:[NSString stringWithFormat:@"%@", model.value] forState:UIControlStateNormal];
    return header;
}

/*- (FormColumnHeaderView *)form:(FormScrollView *)formScrollView columnHeaderAtColumn:(NSInteger)column {
    FormColumnHeaderView *header = [formScrollView dequeueReusableColumnWithIdentifier:@"Column"];
    if (header == NULL) {
        header = [[FormColumnHeaderView alloc] initWithIdentifier:@"Column"];
        header.clipsToBounds = YES;
        header.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        header.contentEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 3);
    }
    TableDataItemModel* model = _headerData[column];
    [header setTitle:[NSString stringWithFormat:@"%@",model.value] forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont systemFontOfSize:12];
    [header setTitleColor:[AppColor app_3color] forState:UIControlStateNormal];
    [header setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
    [header layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [header layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
    });
    return header;
}
*/
- (FormColumnHeaderView *)form:(FormScrollView *)formScrollView columnHeaderAtColumn:(NSInteger)column {
    FormColumnHeaderView*  header = [[FormColumnHeaderView alloc] initWithIdentifier:@"Column"];
    header.clipsToBounds = YES;
    header.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    header.contentEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 3);
    header.userInteractionEnabled = YES;
    TableDataBaseItemModel* model = _headerData[column+1];
    if (_clickBtn < 0) {

        [header setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
    }
    else  {
        if ((column != _clickBtn)) {
            
            [header setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
        }
        else {
            if (_isdownImage) {
                [header setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
            }
            else {
                [header setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
            }
        }
    }
    [header addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
   // TableDataBaseItemModel* model = _headerData[column+1];
    [header setTitle:[NSString stringWithFormat:@"%@",model.value] forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont systemFontOfSize:12];
    header.titleLabel.numberOfLines = 2;
    [header setTitleColor:[AppColor app_3color] forState:UIControlStateNormal];
   // [header setImage:@"icongray_array".imageFromSelf forState:UIControlStateNormal];
    [header layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [header layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
    });
    return header;
}

-(void)changeImage:(UIButton*)sender{
    if (_isdownImage) {
         [sender setImage:@"icon_array".imageFromSelf forState:UIControlStateNormal];
    }
    else {
       [sender setImage:@"icondown_array".imageFromSelf forState:UIControlStateNormal];
    }
    //[sender removeAllTargets];
}

- (FormCell *)form:(FormScrollView *)formScrollView cellForColumnAtIndexPath:(FIndexPath *)indexPath {
    FormCell *cell = [formScrollView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"%@", cell);
    if (cell == NULL) {
        cell = [[FormCell alloc] initWithIdentifier:@"Cell"];
        static int i=0;
        i++;
        NSLog(@"%d--%ld", i, (long)indexPath.section);
    }
        TableDataBaseItemModel* model;
        NSArray *modelArray = _data[indexPath.section];
        model = modelArray[indexPath.column+1];
        NSString* value = model.value;
        cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        [cell setTitle:value forState:UIControlStateNormal];
      // cell.width = 12*[value length];
        cell.titleLabel.font = [UIFont systemFontOfSize:12];
      int colorNum ;
      if ([model.color intValue] && [model.color intValue] < 6) {
         colorNum= [model.color intValue];
           NSString *colorString = _colorArray[colorNum];
           [cell setTitleColor:[UIColor colorWithHexString:colorString] forState:UIControlStateNormal];
      }
      else {
           [cell setTitleColor:[AppColor app_3color] forState:UIControlStateNormal];
      }
       // [cell setTitleColor:[UIColor colorWithHexString:colorString] forState:UIControlStateNormal];
   // TableDataBaseItemModel* model = _data[indexPath.section];
    /*[cell setBackgroundColor:[UIColor yellowColor]];*/
    return cell;
}

- (void)form:(FormScrollView *)formScrollView didSelectCellAtIndexPath:(FIndexPath *)indexPath{ // 单击

}

- (void)form:(FormScrollView *)formScrollView didDoubleClickCellAtIndexPath:(FIndexPath *)indexPath{ //双击
    DoubleClickSuperChartVc* vc = [[DoubleClickSuperChartVc alloc] init];
    TableDataBaseItemModel* model = _headerData[0];
    vc.bannerName = self.bannerTitle;
    vc.titleString = model.value;
    vc.isdownImage = _isdownImage;
    vc.isSort = _isSort;
    vc.lineNumber = _curLineNum;
   // vc.isdownImage = _isdownImage;
    __weak typeof(vc) weakVc = vc;
    [vc setWithSuperModel:_mainmeode column:indexPath.column+1];
    vc.sortBack = ^(id item){
        [self form:formScrollView didSelectColumnAtIndex:indexPath.column];
        [weakVc setWithSuperModel:_mainmeode column:indexPath.column+1];
    };
    [self pushViewController:vc animation:YES hideBottom:YES];
}

- (void)form:(FormScrollView *)formScrollView didSelectSectionAtIndex:(NSInteger)section{
    DLog(@"section index == %zd",section);
}

- (void)form:(FormScrollView *)formScrollView didSelectColumnAtIndex:(NSInteger)column{ //排序
    DLog(@"column index == %zd",column);
    _clickBtn = column;
    _isSort = YES;
    NSMutableArray* sortArray = [NSMutableArray array];
    for (NSArray *array in _data) {
        TableDataBaseItemModel *item = array[column+1];
        [sortArray addObject:item];
    }
    _isdownImage = !_isdownImage;
    TableDataItemModel* head = _headerData[column];
    if (_isdownImage) {
        head.sortType = 0;
    }
    else{
        head.sortType = 1;
    }
    [_bgView setHidden:NO];
    sortArray = [NSArray sortArray:sortArray key:@"value" down:head.sortType];
    [MRProgressOverlayView showOverlayAddedTo:_bgView title:@"加载中" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *datasetArray = [NSMutableArray arrayWithArray:_mainmeode.table.dataSet];
        //[_mainmeode.table.dataSet removeAllObjects];
        [datasetArray removeAllObjects];
        for (TableDataBaseItemModel* item in sortArray) {
            int index = item.lineTag;
            [datasetArray addObject:@(index)];
       }
        _mainmeode.table.dataSet = [datasetArray copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MRProgressOverlayView dismissAllOverlaysForView:_bgView animated:YES];
            [_bgView setHidden:YES];
            [self setForSuperChartModel:_mainmeode];
        });
    });
}

#pragma mark - lazy init-UI
- (void)addSubViews{
//    [self.view addSubview:self.formView];
//    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
}

- (NSArray *)getMymenuArray{
      //  NSDictionary *dict1 = @{@"imageName" : @"icon_sound",
          //                      @"itemName" : @"语音播报"
        //                        };
        //NSDictionary *dict2 = @{@"imageName" : @"筛选",
          //                      @"itemName" : @"筛选"
            //                    };
        NSDictionary *dict3 = @{@"imageName" : @"选列",
                                @"itemName" : @"选列"
                                };
        NSDictionary *dict4 = @{@"imageName" : @"筛选",
                                @"itemName" : @"筛选"
                                };
        NSDictionary *dict5 = @{@"imageName" : @"行高",
                                @"itemName" : @"行高"
                                };
        _menuArray = @[dict3,dict5,dict4];
    return _menuArray;
}


- (FormScrollView *)formView{
    if (!_formView) {
        _formView = [[FormScrollView alloc] initWithFrame:self.view.bounds];
        _formView.fDelegate = self;
        _formView.fDataSource = self;
        [self.view addSubview:_formView];
        [self.formView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _formView;
}

@end
