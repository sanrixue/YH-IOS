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
#import "JYClickableLineView.h"
#import "JYCompareSaleView.h"

@interface JYDemoViewController ()

@end

@implementation JYDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeff1"];
    
    [self addFallsView];
    //[self addClickableLineView];
    //[self addCompareSaleView];
}

- (void)addCompareSaleView {
    JYCompareSaleView *saleView = [[JYCompareSaleView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYVCWidth, JYVCWidth * 0.4)];
    //saleView.backgroundColor = JYColor_ArrowColor_Green;
    [self.view addSubview:saleView];
}

- (void)addClickableLineView {
    
    JYClickableLineView *line = [[JYClickableLineView alloc] initWithFrame:CGRectMake(0, 64 + JYDefaultMargin, JYVCWidth, 300)];
    line.backgroundColor = JYColor_ArrowColor_Green;
    [self.view addSubview:line];
}


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
