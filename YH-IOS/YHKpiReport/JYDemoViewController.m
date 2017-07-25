//
//  JYDemoViewController.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYDemoViewController.h"
#import "JYModuleTwoModel.h"
#import "JYModuleTwoView.h"


@interface JYDemoViewController ()  {
    
    UITableView *_tableView;
    JYModuleTwoView *moduleTwoView;
    
}

@property (nonatomic, strong) JYModuleTwoModel *moduleTwoModel;

@end

@implementation JYDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeff1"];
    
    [self moduleTwoList];
}

- (JYModuleTwoModel *)moduleTwoModel {
    if (!_moduleTwoModel) {
        // 数据准备
        NSString *path = [[NSBundle mainBundle] pathForResource:@"report_v24" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *arraySource = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        _moduleTwoModel = [JYModuleTwoModel modelWithParams:arraySource[0]];
    }
    return _moduleTwoModel;
}

- (void)moduleTwoList {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    moduleTwoView = [[JYModuleTwoView alloc] initWithFrame:CGRectMake(0,JYDefaultMargin, JYVCWidth, JYVCHeight+64)];
    moduleTwoView.moduleModel = self.moduleTwoModel;
    [self.view addSubview:moduleTwoView];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.view removeAllSubviews];
}


@end
