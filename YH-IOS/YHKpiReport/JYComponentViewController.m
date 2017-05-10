//
//  ViewController.m
//  各种报表
//
//  Created by niko on 17/4/24.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYComponentViewController.h"

/* 模块一元组件 */
#import "JYBlockButton.h"
#import "JYCircleProgressView.h"
#import "JYHistogram.h"
#import "JYLineChartView.h"
#import "JYCurveLineView.h"
#import "JYNotifyView.h"
#import "JYPagedFlowView.h"

/* 模块二元组件 */
#import "JYExcelView.h"
#import "JYLandscapeBarView.h"
#import "JYPortraitBarView.h"


@interface JYComponentViewController () <JYModuleTwoBaseViewDelegate, JYNotifyDelegate, PagedFlowViewDelegate, PagedFlowViewDataSource>

@property (nonatomic, strong) NSArray *pages;

@end

@implementation JYComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加模块一的元组件
    [self addFirstMuduleComponentView];
    
    // 添加模块二的元组件
//    [self addSecondModuleComponentView];
}

/*－－－－－－－－－－－－－－－－－－ 添加模块二元组件 －－－－－－－－－－－－－－－－－－*/
- (void)addSecondModuleComponentView {
    
//    [self addExcelView];
    [self addLandscapeBar];
    [self addPortraitBarView];
}

- (void)addExcelView {
    
    JYExcelView *excelView = [[JYExcelView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYScreenWidth, JYScreenHeight / 3.0)];
    excelView.tag = -100000;
    [self.view addSubview:excelView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 64 + JYDefaultMargin + JYScreenHeight / 3.0, JYVCWidth - 8 * 2, 30);
    btn.tag = -100001;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)close:(UIButton *)sender {
    [[self.view viewWithTag:sender.tag + 1] removeFromSuperview];
}

- (void)addPortraitBarView {
    
    JYPortraitBarView *barView = [[JYPortraitBarView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYScreenWidth, 0.9 * JYScreenWidth)];
    barView.delegate = self;
    //barView.backgroundColor = JYColor_LightGray_White;
    [self.view addSubview:barView];
}

- (void)addLandscapeBar {
    
    JYLandscapeBarView *landscapeBarView = [[JYLandscapeBarView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin + 0.9 * JYScreenWidth, JYVCWidth, 300)];
    //landscapeBarView.backgroundColor = JYColor_ArrowColor_Red;
    landscapeBarView.delegate = self;
    [self.view addSubview:landscapeBarView];
    
}

#pragma mark - <JYModuleTwoBaseViewDelegate>
- (void)moduleTwoBaseView:(JYModuleTwoBaseView *)moduleTwoBaseView didSelectedAtIndex:(NSInteger)idx data:(id)data {
    NSLog(@"didSelected :%@", data);
}







/**************************** 添加模块一的元组件 *****************************/
- (void)addFirstMuduleComponentView {
    
//    [self addCircleProgress];
    [self addHistogram];
//    [self addLineView];
//    [self addCurveLineView];
//    [self addNotification];
//    [self addPageFlowView];
}

- (void)addPageFlowView {
    JYPagedFlowView *pageView = [[JYPagedFlowView alloc] initWithFrame:CGRectMake(8, 64 * 6 + 8, 320, 300)];
    pageView.delegate = self;
    pageView.dataSource = self;
    pageView.minimumPageAlpha = 0.3;
    pageView.minimumPageScale = 0.9;
    [self.view addSubview:pageView];
}

- (NSArray *)pages {
    if (!_pages) {
        _pages = [NSArray array];
        NSMutableArray *tempAry = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:(random() % 255) / 255.0 green:(random() % 255) / 255.0 blue:(random() % 255) / 255.0 alpha:1];
            [tempAry addObject:view];
        }
        _pages = [tempAry copy];
    }
    return _pages;
}

- (void)addNotification {

    NSArray *nts = @[@"黄岩岛搁浅渔船残骸已被我方清除", @"北京西站，一场骗局下的众生相", @"美国龙虾泛滥愁人 中国吃货分分钟替你解决"];
    JYNotifyView *nt = [[JYNotifyView alloc] initWithFrame:CGRectMake(8, 64 * 5 + 8, 320, 30)];
    nt.notifications = nts;
    nt.delegate = self;
    nt.interval = 1;
    nt.notifyColor = [UIColor whiteColor];
    nt.backgroundColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00];
    nt.closeBtnColor = [UIColor colorWithRed:0.84 green:0.30 blue:0.19 alpha:1.00];
    [self.view addSubview:nt];
    
    JYBlockButton *btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 64 * 5 + 8, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setHandler:^(BOOL isSelected) {
        [nt removeFromSuperview];
    }];
    [self.view addSubview:btn];
}

- (void)addCurveLineView {
    JYCurveLineView *lineView = [[JYCurveLineView alloc] initWithFrame:CGRectMake(8 * 2 + 150, 64 * 3 + 8, 150, 100)];
    lineView.backgroundColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00];
//    lineView.dataSource = @[@"20", @"0", @"7", @"3", @"23", @"12", @"20"];
    lineView.lineColor = [UIColor redColor];
    lineView.interval = 2.0;
    [self.view addSubview:lineView];
    
    JYBlockButton *btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8 * 2 + 150, 64 * 3 + 8, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setHandler:^(BOOL isSelected) {
        [lineView removeFromSuperview];
    }];
    [self.view addSubview:btn];

}

- (void)addLineView {
    JYLineChartView *lineView = [[JYLineChartView alloc] initWithFrame:CGRectMake(8, 64 * 3 + 8, 150, 100)];
    lineView.backgroundColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00];
    lineView.dataSource = @[@"2", @"5", @"7", @"3", @"33", @"12", @"10"];
    lineView.interval = 2.0;
    [self.view addSubview:lineView];
    
    JYBlockButton *btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 64 * 3 + 8, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setHandler:^(BOOL isSelected) {
        [lineView removeFromSuperview];
    }];
    [self.view addSubview:btn];

}

- (void)addHistogram {
    JYHistogram *histogram = [[JYHistogram alloc] initWithFrame:CGRectMake(8 * 2 + 150, 64 + 8, 150, 100)];
    histogram.dataSource = @[@"2", @"5", @"7", @"3", @"33", @"12", @"10"];
    histogram.backgroundColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00];
    histogram.lastBarColor = [UIColor orangeColor];
    histogram.barColor = [UIColor whiteColor];
    histogram.interval = 1;
    [self.view addSubview:histogram];
    
    JYBlockButton *btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8 * 2 + 150, 64 + 8, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setHandler:^(BOOL isSelected) {
        [histogram removeFromSuperview];
    }];
    [self.view addSubview:btn];

}

- (void)addCircleProgress {
    
    JYCircleProgressView *circleView = [[JYCircleProgressView alloc] initWithFrame:CGRectMake(8, 64 + 8, 150, 100)];
    circleView.backgroundColor = [UIColor colorWithRed:0.42 green:0.60 blue:0.85 alpha:1.00];
    circleView.progressWidth = 8;
    circleView.progressColor = [UIColor whiteColor];
    circleView.percent = 0.5;
    circleView.interval = 1;
    [self.view addSubview:circleView];
    
    JYBlockButton *btn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 64 + 8, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setHandler:^(BOOL isSelected) {
        [circleView removeFromSuperview];
    }];
    [self.view addSubview:btn];
}

#pragma mark - <JYNotifyDelegate>
- (void)closeNotifyView:(JYNotifyView *)notify {
    
}

- (void)notifyView:(JYNotifyView *)notify didSelected:(NSInteger)idx selectedData:(id)data {
    NSLog(@"%@", data);
}

#pragma mark - <PagedFlowViewDataSource>

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(JYPagedFlowView *)flowView;{
    return CGSizeMake(280, 200);
}

- (void)flowView:(JYPagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
    NSLog(@"Scrolled to page # %ld", (long)index);
}

- (void)flowView:(JYPagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index{
    NSLog(@"Tapped on page # %ld", (long)index);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(JYPagedFlowView *)flowView{
    return [self.pages count];
}

//返回给某列使用的View
- (UIView *)flowView:(JYPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    return self.pages[index];
}
@end
