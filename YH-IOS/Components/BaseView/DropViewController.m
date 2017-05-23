//
//  DropViewController.m
//  YH-IOS
//
//  Created by li hao on 16/9/14.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "DropViewController.h"
#import "Constant.h"

@interface DropViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dropTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30) style:UITableViewStylePlain];
    self.dropTableView.scrollEnabled  = NO;
    self.dropTableView.delegate =self;
    self.dropTableView.dataSource  =self;
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.view.backgroundColor = [UIColor colorWithHexString:kDropViewColor];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource numberOfPagesIndropView:self];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_dataSource dropView:self cellForPageAtIndex:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150/4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate dropView:self didTapPageAtIndex:indexPath];
}


@end
