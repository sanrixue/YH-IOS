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

const static CGFloat lineHeight = 40; //一行的高度

@interface SuperChartVc () <FDelegate,FDataSource>
@property (nonatomic, strong) NSArray* menuArray;
@property (nonatomic, assign) NSInteger curLineNum;
@property (nonatomic, strong) CommonMenuView* menuView;
@property (nonatomic, strong) FormScrollView* formView;
@property (nonatomic, strong) NSArray* data; //报表数据
@property (nonatomic, strong) NSArray* headerData; //头部数据
@property (nonatomic, strong) SuperChartModel* superModel;
@end

@implementation SuperChartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _superModel = [SuperChartModel testModel];
    [self setForSuperChartModel:_superModel];
    self.title = _superModel.name;
    [self formView];
    [CommonMenuView clearMenu]; // 清除window菜单
    [self menuView]; //重新生成菜单
    _curLineNum = 1;
    [self.formView reloadData];
}

- (void)setForSuperChartModel:(SuperChartModel*)superModel{
    _superModel = superModel;
    _headerData = [superModel.table showhead];
    _data = [superModel.table showData];
    [self.formView reloadData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.formView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithImage:@"nav_more" target:self action:@selector(showMenu:)];
}
/** 展示菜单 */
- (void)showMenu:(UIButton*)sender{
    [CommonMenuView showMenuAtPoint:CGPointMake(sender.centerX, sender.bottom)];
}

#pragma mark - 处理菜单点击
- (void)menuActionTitle:(NSString*)title{
    [CommonMenuView hidden];
    if ([title isEqualToString:@"语音播报"]) {
        
    }
    if ([title isEqualToString:@"列表"]) {
        [self selectList];
    }
    if ([title isEqualToString:@"行距"]) {
        [self selectLineSpace];
    }
    if ([title isEqualToString:@"过滤"]) {
        [self FilterAction];
    }
}

- (void)selectList{ // 选择列表
    SelectListVc* vc = [[SelectListVc alloc] init];
    [vc setWithTableData:_superModel.table];
//    __weak typeof(vc) weakVc = vc;
    vc.usedBack = ^(id item){
        [self setForSuperChartModel:_superModel];
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
        [self setForSuperChartModel:_superModel];
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
        lab.text = _superModel.name;
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
    return _headerData.count;
}
- (CGFloat)heightForSection:(FormScrollView *)formScrollView {
    return lineHeight*_curLineNum;
}
- (CGFloat)heightForSectionHeader:(FormScrollView *)formScrollView{
    return lineHeight;
}
- (CGFloat)widthForColumn:(FormScrollView *)formScrollView {
    return 80;
}
- (CGFloat)widthForColumnHeader:(FormScrollView *)formScrollView{
    return 120;
}
- (FormSectionHeaderView *)form:(FormScrollView *)formScrollView sectionHeaderAtSection:(NSInteger)section {
    FormSectionHeaderView *header = [formScrollView dequeueReusableSectionWithIdentifier:@"Section"];
    if (header == NULL) {
        header = [[FormSectionHeaderView alloc] initWithIdentifier:@"Section"];
    }
    TableDataItemModel* model = _data[section];
    header.titleLabel.font = [UIFont systemFontOfSize:12];
    [header setTitleColor:[AppColor app_3color] forState:UIControlStateNormal];
    [header setTitle:[NSString stringWithFormat:@"%@", model.name] forState:UIControlStateNormal];
    return header;
}
- (FormColumnHeaderView *)form:(FormScrollView *)formScrollView columnHeaderAtColumn:(NSInteger)column {
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
- (FormCell *)form:(FormScrollView *)formScrollView cellForColumnAtIndexPath:(FIndexPath *)indexPath {
    FormCell *cell = [formScrollView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"%@", cell);
    if (cell == NULL) {
        cell = [[FormCell alloc] initWithIdentifier:@"Cell"];
        static int i=0;
        i++;
        NSLog(@"%d--%ld", i, (long)indexPath.section);
    }
    TableDataItemModel* model = _data[indexPath.section];
    NSString* value = model.showData[indexPath.column].value;
    [cell setTitle:value forState:UIControlStateNormal];
    cell.titleLabel.font = [UIFont systemFontOfSize:12];
    [cell setTitleColor:[AppColor app_3color] forState:UIControlStateNormal];
    /*[cell setBackgroundColor:[UIColor yellowColor]];*/
    return cell;
}
- (void)form:(FormScrollView *)formScrollView didSelectCellAtIndexPath:(FIndexPath *)indexPath{ // 单击

}

- (void)form:(FormScrollView *)formScrollView didDoubleClickCellAtIndexPath:(FIndexPath *)indexPath{ //双击
    DoubleClickSuperChartVc* vc = [[DoubleClickSuperChartVc alloc] init];
    __weak typeof(vc) weakVc = vc;
    [vc setWithSuperModel:_superModel column:indexPath.column];
    vc.sortBack = ^(id item){
        [self form:formScrollView didSelectColumnAtIndex:indexPath.column];
        [weakVc setWithSuperModel:_superModel column:indexPath.column];
    };
    [self pushViewController:vc animation:YES hideBottom:YES];
}

- (void)form:(FormScrollView *)formScrollView didSelectSectionAtIndex:(NSInteger)section{
    DLog(@"section index == %zd",section);
}

- (void)form:(FormScrollView *)formScrollView didSelectColumnAtIndex:(NSInteger)column{ //排序
    DLog(@"column index == %zd",column);
    
    NSMutableArray* sortArray = [NSMutableArray array];
    for (TableDataItemModel* item in _data) {
        item.showData[column].superTableDataItem = item;
        [sortArray addObject:item.showData[column]];
    }
    
    TableDataItemModel* head = _headerData[column];
    head.sortType = head.sortType==SortTypeUp? SortTypeDown:SortTypeUp;
    sortArray = [NSArray sortArray:sortArray key:@"value" down:head.sortType];
    
    [_superModel.table.dataSet removeAllObjects];
    for (TableDataItemModel* item in sortArray) {
        NSInteger index = [_superModel.table.main_data indexOfObject:item.superTableDataItem];
        [_superModel.table.dataSet addObject:@(index)];
    }
    [self setForSuperChartModel:_superModel];
}

#pragma mark - lazy init-UI
- (void)addSubViews{
//    [self.view addSubview:self.formView];
//    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
}

- (NSArray *)menuArray{
    if (!_menuArray) {
        NSDictionary *dict1 = @{@"imageName" : @"icon_sound",
                                @"itemName" : @"语音播报"
                                };
        NSDictionary *dict2 = @{@"imageName" : @"筛选",
                                @"itemName" : @"筛选"
                                };
        NSDictionary *dict3 = @{@"imageName" : @"选列",
                                @"itemName" : @"列表"
                                };
        NSDictionary *dict4 = @{@"imageName" : @"过滤",
                                @"itemName" : @"过滤"
                                };
        NSDictionary *dict5 = @{@"imageName" : @"行距",
                                @"itemName" : @"行距"
                                };
        _menuArray = @[dict1,dict2,dict3,dict4,dict5];
    }
    return _menuArray;
}

- (CommonMenuView *)menuView{
    if (!_menuView) {
        MJWeakSelf;
        _menuView = [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:self.menuArray itemsClickBlock:^(NSString *str, NSInteger tag) {
            [weakSelf menuActionTitle:str];
        } backViewTap:^{
            
        }];
    }
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
