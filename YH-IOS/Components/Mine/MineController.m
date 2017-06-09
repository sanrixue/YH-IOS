//
//  MineController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//


#import "MineController.h"
#import "MineInfoViewController.h"
#import "InstituteViewController.h"
#import "NoticeTableViewController.h"

@interface MineController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) UIView *indicatorview;

// 当前选中按钮

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildViewController];
    [self setupTitlesView];
    [self setupCotentView];
    // Do any additional setup after loading the view.
}

-(void)setupChildViewController{
    
    NoticeTableViewController *noticeView = [[NoticeTableViewController alloc]init];
    noticeView.title = @"公告预警";
    [self addChildViewController:noticeView];
    
    InstituteViewController *instituteView = [[InstituteViewController alloc]init];
    instituteView.title = @"数据学院";
    [self addChildViewController:instituteView];
    
    MineInfoViewController *mineInfoView = [[MineInfoViewController alloc]init];
    mineInfoView.title = @"个人信息";
    [self addChildViewController:mineInfoView];
    
}


-(void)setupTitlesView {
    
    // 标题图
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 20, SCREEN_WIDTH,35.0);
    [self.view addSubview:bgView];
    
    // 标签
    
    UIView *titlesView = [[UIView alloc]init];
    titlesView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35.0);
    [bgView addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 顶部绿色指示器
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor greenColor];
    indicatorView.height = 2;
    indicatorView.mj_y = 33;
    indicatorView.tag = -1;
    self.indicatorview = indicatorView;
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat width = titlesView.width/count;
    CGFloat height = titlesView.height - 2;
    
    for(int index = 0; index<count;index++){
        UIButton *button = [[UIButton alloc]init];
        button.mj_y = 0;
        button.height = height;
        button.width = width;
        button.mj_x = index*width;
        button.tag = index;
        
        UIViewController *vc = self.childViewControllers[index];
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor colorWithHexString:@"#000"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        if (index == 0) {
            [button setUserInteractionEnabled:NO];
            self.selectedButton = button;
            [button.titleLabel sizeToFit];
            indicatorView.width = button.titleLabel.width;
            indicatorView.centerX = button.centerX;
        }
        
    }
    
    [titlesView addSubview:indicatorView];
    
}

-(void)titleClick:(UIButton*)button {
    [self.selectedButton setUserInteractionEnabled:YES];
    [button setUserInteractionEnabled:NO];
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorview.width = self.selectedButton.titleLabel.width;
        self.indicatorview.centerX = self.selectedButton.centerX;
    }];
    
    CGPoint offset = [self.contentView contentOffset];
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset];
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}


-(void)setupCotentView {
    self.automaticallyAdjustsScrollViewInsets  =NO;
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.delegate =self;
    contentView.contentSize = CGSizeMake(contentView.width * 3, 0);
    [contentView setPagingEnabled:YES];
    [self.view insertSubview:contentView atIndex:0];
    self.contentView =contentView;
    [self scrollViewDidEndScrollingAnimation:contentView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x/scrollView.width;
    UIViewController *vc= self.childViewControllers[index];
    vc.view.mj_x = scrollView.contentOffset.x;
    vc.view.mj_y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    int index = scrollView.contentOffset.x/scrollView.width;
    UIButton *button = self.titlesView.subviews[index];
    [self titleClick:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
