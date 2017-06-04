//
//  JYDemoViewController.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYDemoViewController.h"
#import "JYFallsView.h"
#import "JYDashboardModel.h"
//
///* 模块二元组件 */
//#import "JYClickableLineView.h"
//#import "JYCompareSaleView.h"
//#import "JYExcelView.h"
//#import "JYLandscapeBarView.h"
//#import "JYPortraitBarView.h"
#import "JYModuleTwoCell.h"

@interface JYDemoViewController () <UITableViewDelegate, UITableViewDataSource, JYModuleTwoCellDelegate> {
//    UIScrollView *scVeiw;
    
//    JYCompareSaleView *saleView;
//    JYClickableLineView *line;
//    JYPortraitBarView *barView;
//    JYLandscapeBarView *landscapeBarView;
//    JYExcelView *excelView;
    
}

@property (nonatomic, strong) JYModuleTwoCell *moduleTwoCell;
@property (nonatomic, strong) NSArray *viewModelList;

@end

@implementation JYDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeff1"];
    
    //[self addFallsView];
    
//    [self addModuleTwoSC];
//    [self addCompareSaleView];
//    [self addClickableLineView];
//    [self addExcelView];
//    [self addLandscapeBar];
//    [self addPortraitBarView];
    
    [self moduleTwoList];
}

- (JYModuleTwoCell *)moduleTwoCell {
    if (!_moduleTwoCell) {
        _moduleTwoCell = [[JYModuleTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JYModuleTwoCell"];
    }
    return _moduleTwoCell;
}

- (NSArray *)viewModelList {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *typeList = @[@"tables#v3", @"chart", @"single_value", @"bargraph", @"line"];
    for (int i = 0; i < 5; i++) {
        JYModuleTwoBaseModel *viewModule = [JYModuleTwoBaseModel modelWithParams:@{@"data": @{@"data" : @[@"0.9", @"0.9", @"0.9", @"0.8", @"0.1", @"0.169", @"0.23", @"0.283"]}, @"type" : typeList[i]}];
        [arr addObject:viewModule];
    }
    return [arr copy];
}

- (void)moduleTwoList {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[JYModuleTwoCell class] forCellReuseIdentifier:@"JYModuleTwoCell"];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYModuleTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYModuleTwoCell" forIndexPath:indexPath];
    cell.viewModel = self.viewModelList[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.moduleTwoCell cellHeightWithModel:self.viewModelList[indexPath.section]];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return JYDefaultMargin;
}

#pragma mark - <JYModuleTwoCellDelegate>
- (void)moduleTwoCell:(JYModuleTwoCell *)moduleTwoCell didSelectedAtBaseView:(JYModuleTwoBaseView *)baseView Index:(NSInteger)idx data:(id)data {
    NSLog(@"data %@", data);
}




//- (void)addModuleTwoSC {
//    scVeiw = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scVeiw.contentSize = CGSizeMake(JYVCWidth, JYVCHeight * 5);
//    [self.view addSubview:scVeiw];
//}
//
//- (void)addCompareSaleView {
//    saleView = [[JYCompareSaleView alloc] initWithFrame:CGRectMake(0, JYDefaultMargin, JYVCWidth, JYVCWidth * 0.4)];
//    saleView.delegate = self;
//    saleView.backgroundColor = JYColor_LightGray_White;
//    [scVeiw addSubview:saleView];
//}
//
//- (void)addClickableLineView {
//    
//    line = [[JYClickableLineView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYVCWidth, 300)];
//    line.delegate = self;
//    line.backgroundColor = JYColor_ArrowColor_Green;
//    [scVeiw addSubview:line];
//}
//
//- (void)addPortraitBarView {
//    
//    barView = [[JYPortraitBarView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYScreenWidth, 0.5 * JYScreenWidth)];
//    barView.delegate = self;
//    //barView.backgroundColor = JYColor_LightGray_White;
//    [scVeiw addSubview:barView];
//}
//
//- (void)addLandscapeBar {
//    
//    landscapeBarView = [[JYLandscapeBarView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin + 0.9 * JYScreenWidth, JYVCWidth, 300)];
//    //landscapeBarView.backgroundColor = JYColor_ArrowColor_Red;
//    landscapeBarView.delegate = self;
//    [scVeiw addSubview:landscapeBarView];
//    
//}
//
//- (void)addExcelView {
//    
//    excelView = [[JYExcelView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYScreenWidth, JYScreenHeight / 3.0)];
//    excelView.tag = -100000;
//    excelView.delegate = self;
//    [scVeiw addSubview:excelView];
//    
//}


- (void)addFallsView {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kpi_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:arraySource.count];
    [arraySource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYDashboardModel *model = [JYDashboardModel modelWithParams:obj];
        [arr addObject:model];
    }];
    
    JYFallsView *fallsView = [[JYFallsView alloc] initWithFrame:CGRectMake(0, 0, JYVCWidth, JYVCHeight)];
    fallsView.dataSource = arr;
    [self.view addSubview:fallsView];
}




@end
