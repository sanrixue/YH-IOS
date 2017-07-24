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

@interface YHWarningNoticeController () <UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) RefreshTool* reTool;

@property (nonatomic, strong) NSMutableArray* dataList;

@property (nonatomic, assign) NSInteger page;

@end

@implementation YHWarningNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _page = 1;
    [self.reTool beginDownPull];
}

- (void)getData:(BOOL)needLoding isDownPull:(BOOL)downPull{
    if (needLoding) {
        // to do show loading
    }
    NSInteger page = _page + 1;
    if (downPull) {
        page = 0;
    }
    [YHHttpRequestAPI yh_getNoticeWarningListWithTypes:@[@"1",@"2"] page:page finish:^(BOOL success, NoticeWarningModel* model, NSString *jsonObjc) {
        // to do hideLoding
        if ([BaseModel handleResult:model]) {
            if (downPull) {
                _page = 0;
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


#pragma mark - lazy

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




@end
