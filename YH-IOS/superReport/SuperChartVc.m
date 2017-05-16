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

const static CGFloat lineHeight = 40; //一行的高度

@interface SuperChartVc () <FDelegate,FDataSource>
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
@end

@implementation SuperChartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSort = NO;
    _isdownImage = YES;
    _clickBtn = -1;
     self.menuArray = [self getMymenuArray];
      self.menuView = [self getMymenuView];
   // _superModel = [SuperChartModel testModel];
   // [self setForSuperChartModel:_mainmeode];
    //[self setForSuperChartModel:_superModel];
    self.title = self.bannerTitle;
    [self formView];
    [CommonMenuView clearMenu]; // 清除window菜单
    [self getMymenuView]; //重新生成菜单
    _curLineNum = 1;
    [self getSuperChartData];
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
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"加载中" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      _mainmeode = [SuperChartMainModel testModel:_dataLink];
        dispatch_async(dispatch_get_main_queue(), ^{
                [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
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
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 70, 40)];
    UIImage *imageback = [UIImage imageNamed:@"Banner-Back"];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7, 15, 25)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addSubview:bakImage];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 50, 25)];
    backLabel.text = @"返回";
    backLabel.textColor = [UIColor whiteColor];
    [backBtn addSubview:backLabel];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:@"nav_more" target:self action:@selector(showMenu:)];
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

#pragma mark - 处理菜单点击
- (void)menuActionTitle:(NSString*)title{
    [CommonMenuView hidden];
    if ([title isEqualToString:@"选列"]) {
        [self selectList];
    }
    if ([title isEqualToString:@"行距"]) {
        [self selectLineSpace];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
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
    vc.superModel = _superModel;
    vc.usedBack = ^(FilterSuperChartVc* item){
       // [self setForSuperChartModel:_superModel];
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
    return lineHeight*_curLineNum;
}
- (CGFloat)heightForSectionHeader:(FormScrollView *)formScrollView{
    return lineHeight;
   // return 0;
}
- (CGFloat)widthForColumn:(FormScrollView *)formScrollView {
    return 120;
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
    header.titleLabel.numberOfLines = 0;
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
    vc.titleString = model.value;
    vc.isdownImage = _isdownImage;
    vc.isSort = _isSort;
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
    sortArray = [NSArray sortArray:sortArray key:@"value" down:head.sortType];
    [_mainmeode.table.dataSet removeAllObjects];
    for (TableDataBaseItemModel* item in sortArray) {
        int index = item.lineTag;
        [_mainmeode.table.dataSet addObject:@(index)];
    }
    [self setForSuperChartModel:_mainmeode];
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
       /* NSDictionary *dict4 = @{@"imageName" : @"过滤",
                                @"itemName" : @"过滤"
                                };*/
        NSDictionary *dict5 = @{@"imageName" : @"行距",
                                @"itemName" : @"行距"
                                };
        _menuArray = @[dict3,dict5];
    return _menuArray;
}

- (CommonMenuView *)getMymenuView{
    self.menuArray = [self getMymenuArray];
        MJWeakSelf;
        _menuView = [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:self.menuArray itemsClickBlock:^(NSString *str, NSInteger tag) {
            [weakSelf menuActionTitle:str];
        } backViewTap:^{
            
        }];
    _menuView.backgroundColor = [UIColor colorWithHexString:kThemeColor];
    return _menuView;
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
