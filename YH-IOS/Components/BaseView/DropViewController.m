//
//  DropViewController.m
//  YH-IOS
//
//  Created by li hao on 16/9/14.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "DropViewController.h"

@interface DropViewController ()

@end

@implementation DropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30) style:UITableViewStylePlain];
    self.dropTableView.scrollEnabled  = NO;
    self.dropTableView.backgroundColor = [UIColor clearColor];
    self.dropTableView.separatorColor = [UIColor whiteColor];
    self.dropTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.dropTableView.layoutMargins  = UIEdgeInsetsZero;
    self.dropTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.dropTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
