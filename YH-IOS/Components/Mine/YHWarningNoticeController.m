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

@end

@implementation YHWarningNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.reTool beginDownPull];
}

- (void)getData:(BOOL)needLoding{
    if (needLoding) {
        // to do show loading
    }
    [YHHttpRequestAPI yh_getNoticeWarningListWithTypes:@[@"1",@"2"] page:0 finish:^(BOOL success, id model, NSString *jsonObjc) {
        
        [_reTool endRefreshDownPullEnd:YES topPullEnd:YES reload:YES noMore:YES];
    }];
    
}

- (void)refreshToolBeginDownRefreshWithScrollView:(UIScrollView *)scrollView tool:(RefreshTool *)tool{
    [self getData:NO];
}

#pragma mark - 列表代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHWarningNoticeCell *cell = [YHWarningNoticeCell cellWithTableView:tableView needXib:YES];
    [cell setupAutoHeightWithBottomView:cell.bottomLab bottomMargin:15];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count + 5;
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
