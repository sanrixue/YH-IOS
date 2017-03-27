//
//  ApplicationViewController.m
//  YH-IOS
//
//  Created by li hao on 17/3/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ApplicationViewController.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.browser.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.browser.frame = [[UIScreen mainScreen]bounds];
    [self.view addSubview:self.browser];
    self.title = @"应用";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
