//
//  YHWarningNoticeController.m
//  YH-IOS
//
//  Created by cjg on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHWarningNoticeController.h"
#import "RefreshTool.h"
#import "YHWarningNoticeCell.h"
#import "SDAutoLayout.h"
#import "YHHttpRequestAPI.h"
#import "NoticeWarningModel.h"
#import "YHWarningNoticeHeaderView.h"

@interface YHWarningNoticeController () <UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YHWarningNoticeHeaderView* headerView;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSMutableArray* dataList;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray<BaseModel*>* typesArray;

@end

@implementation YHWarningNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.estimatedRowHeight = 120; //防止reload的时候闪烁
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _page = 1;
    [self.reTool beginDownPull];
}

- (void)setupUI{
    [self.view sd_addSubviews:@[self.headerView]];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}

- (void)getData:(BOOL)needLoding isDownPull:(BOOL)downPull{
    if (needLoding) {
        // to do show loading
    }
    NSInteger page = _page + 1;
    if (downPull) {
        page = 1;
    }
    NSMutableArray* types = [NSMutableArray array];
    for (BaseModel* type in self.typesArray) {
        if (type.isSelected) {
            [types addObject:type.identifier];
        }
    }
    [YHHttpRequestAPI yh_getNoticeWarningListWithTypes:types page:page finish:^(BOOL success, NoticeWarningModel* model, NSString *jsonObjc) {
        // to do hideLoding
        [self.reTool endRefreshDownPullEnd:true topPullEnd:true reload:false noMore:false];
        if ([BaseModel handleResult:model]) {
            if (downPull) {
                _page = 1;
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:model.data];
            }else{
                _page++;
                [self.dataList addObjectsFromArray:model.data];
            }
            [_reTool endRefreshDownPullEnd:YES topPullEnd:YES reload:YES noMore:[(BaseModel*)model isNoMore]];
        }
    }];
    
}

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:NO isDownPull:YES];
}

- (void)refreshToolBeginUpRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:NO isDownPull:NO];
}

#pragma mark - 列表代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHWarningNoticeCell *cell = [YHWarningNoticeCell cellWithTableView:tableView needXib:YES];
    [cell setNoticeWarningModel:_dataList[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - lazy

- (YHWarningNoticeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YHWarningNoticeHeaderView alloc] init];
        [_headerView setWithBaseModels:self.typesArray];
        MJWeakSelf;
        _headerView.clickBlock = ^(UIButton* item) {
            BaseModel* type = weakSelf.typesArray[item.tag-1];
            type.isSelected = !type.isSelected;
            [weakSelf.headerView setWithBaseModels:weakSelf.typesArray];
            [weakSelf.reTool beginDownPull];
        };
    }
    return _headerView;
}

- (RefreshTool *)reTool{
    if (!_reTool) {
        _reTool = [[RefreshTool alloc] initWithScrollView:self.tableView delegate:self down:YES top:YES];
    }
    return _reTool;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSArray<BaseModel *> *)typesArray{
    if (!_typesArray) {
        BaseModel* model1 = [[BaseModel alloc] init];
        model1.identifier = @"0";
        model1.message = @"系统公告";
        BaseModel* model2 = [[BaseModel alloc] init];
        model2.identifier = @"1";
        model2.message = @"业务公告";
        BaseModel* model3 = [[BaseModel alloc] init];
        model3.identifier = @"2";
        model3.message = @"预警公告";
        BaseModel* model4 = [[BaseModel alloc] init];
        model4.identifier = @"3";
        model4.message = @"报表评论";
        _typesArray = @[model1,model2,model3,model4];
    }
    return _typesArray;
}


@end
