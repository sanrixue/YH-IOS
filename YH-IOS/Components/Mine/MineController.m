//
//  MineController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//


#import "MineController.h"
#import "MineInfoViewController.h"
#import "YHInstituteController.h"
#import "NoticeTableViewController.h"
#import "UIButton+NewBadge.h"
#import "YHWarningNoticeController.h"
#import "MineControllerHeaderView.h"

#import "ScrollControllersVc.h"

@interface MineController ()//<UIScrollViewDelegate>

//@property (nonatomic, strong) UIView *titlesView;
//@property (nonatomic, strong) UIView *indicatorview;
//
//// 当前选中按钮
//
//@property (nonatomic, strong) UIButton *selectedButton;
//@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) MineControllerHeaderView* headerView;
@property (nonatomic, strong) ScrollControllersVc* scrollVc;
@property (nonatomic, strong) YHWarningNoticeController* warningVc;
@property (nonatomic, strong) YHInstituteController* instituteVc;
@property (nonatomic, strong) MineInfoViewController* mineInfoVc;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view sd_addSubviews:@[self.headerView,self.scrollVc.view]];
    [self.scrollVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
//    [self setupCotentView];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

////-(void)viewDidAppear:(BOOL)animated {
////    [super viewDidAppear:YES];
////    [self.navigationController.navigationBar setHidden:YES];
////    self.navigationController.navigationBar.translucent = YES;
////    self.automaticallyAdjustsScrollViewInsets = NO;
////    self.tabBarController.tabBar.translucent = YES;
////    [self.tabBarController.tabBar setHidden:NO];
////}
//
////-(void)viewDidDisappear:(BOOL)animated {
////    [super viewDidDisappear:YES];
////    self.automaticallyAdjustsScrollViewInsets = NO;
////}
//
//
//-(void)setupChildViewController{
//    
//    YHWarningNoticeController *noticeView = [[YHWarningNoticeController alloc]init];
//    noticeView.title = @"公告预警";
//    [self addChildViewController:noticeView];
//    
//    InstituteViewController *instituteView = [[InstituteViewController alloc]init];
//    instituteView.title = @"数据学院";
//    [self addChildViewController:instituteView];
//    
//    MineInfoViewController *mineInfoView = [[MineInfoViewController alloc]init];
//    mineInfoView.title = @"个人信息";
//    [self addChildViewController:mineInfoView];
//    
//}
//
//
//-(void)setupTitlesView {
//    
//    // 标题图
//    UIView *bgView = [[UIView alloc]init];
//    bgView.frame = CGRectMake(0, 20, SCREEN_WIDTH,44.0);
//    [self.view addSubview:bgView];
//    
//    // 标签
//    
//    UIView *titlesView = [[UIView alloc]init];
//    titlesView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0);
//    [bgView addSubview:titlesView];
//    bgView.backgroundColor = [UIColor whiteColor];
//    titlesView.backgroundColor = [UIColor whiteColor];
//    self.titlesView = titlesView;
//    
//    // 顶部绿色指示器
//    UIView *indicatorView = [[UIView alloc]init];
//    indicatorView.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
//    indicatorView.height = 2;
//    indicatorView.mj_y = 41;
//    indicatorView.tag = -1;
//    self.indicatorview = indicatorView;
//    
//    //顶部分割线
//    UIView *topSepLine = [[UIView alloc]init];
//    topSepLine.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
//    topSepLine.height = 1;
//    topSepLine.mj_y = 43;
//    
//    
//    NSUInteger count = self.childViewControllers.count;
//    CGFloat width = titlesView.width/count;
//    CGFloat height = titlesView.height - 3;
//    
//    for(int index = 0; index<count;index++){
//        UIButton *button = [[UIButton alloc]init];
//        button.mj_y = 0;
//        button.height = height;
//        button.width = width;
//        button.mj_x = index*width;
//        button.tag = index;
//        button.badgeBGColor = [UIColor colorWithHexString:@"#6aa657"];
//        button.badgeValue = @" ";
//        button.badgeMinSize = 2;
//        [button.badge setHidden:YES];
//        if (button.tag == 0) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenIcon:) name:@"mineTopHiddenIocn1" object:nil];
//        }
//        if (button.tag == 1) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenIcon:) name:@"mineTopHiddenIocn2" object:nil];
//        }
//        if (button.tag == 2) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenIcon:) name:@"mineTopHiddenIocn3" object:nil];
//        }
//        
//        UIViewController *vc = self.childViewControllers[index];
//        [button setTitle:vc.title forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button setTitleColor:[UIColor colorWithHexString:@"#000"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
//        [titlesView addSubview:button];
//        
//        if (index == 0) {
//            [button setUserInteractionEnabled:NO];
//            self.selectedButton = button;
//            [button.titleLabel sizeToFit];
//            indicatorView.width = button.titleLabel.width;
//            indicatorView.centerX = button.centerX;
//        }
//        
//    }
//    topSepLine.width=SCREEN_WIDTH;
//    [titlesView addSubview:indicatorView];
//    [titlesView addSubview:topSepLine];
//    
//}
//
//-(void)hiddenIcon:(UIButton*)sendser{
//    [sendser.badge setHighlighted:YES];
//}
//
//-(void)titleClick:(UIButton*)button {
//    [self.selectedButton setUserInteractionEnabled:YES];
//    [button setUserInteractionEnabled:NO];
//    self.selectedButton = button;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.indicatorview.width = self.selectedButton.titleLabel.width;
//        self.indicatorview.centerX = self.selectedButton.centerX;
//    }];
//    
//    CGPoint offset = [self.contentView contentOffset];
//    offset.x = button.tag * self.contentView.width;
//    [self.contentView setContentOffset:offset];
//    [self scrollViewDidEndScrollingAnimation:self.contentView];
//}
//
//
//-(void)setupCotentView {
//    self.automaticallyAdjustsScrollViewInsets  =NO;
//    UIScrollView *contentView = [[UIScrollView alloc]init];
//    contentView.frame = self.view.bounds;
//    contentView.delegate =self;
//    contentView.contentSize = CGSizeMake(contentView.width * 3, 0);
//    [contentView setPagingEnabled:YES];
//    [self.view insertSubview:contentView atIndex:0];
//    self.contentView =contentView;
//    [self scrollViewDidEndScrollingAnimation:contentView];
//}
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    
//    int index = scrollView.contentOffset.x/scrollView.width;
//    UIViewController *vc= self.childViewControllers[index];
//    vc.view.mj_x = scrollView.contentOffset.x;
//    vc.view.mj_y = 0;
//    vc.view.height = scrollView.height;
//    [scrollView addSubview:vc.view];
//    
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//    int index = scrollView.contentOffset.x/scrollView.width;
//    UIButton *button = self.titlesView.subviews[index];
//    [self titleClick:button];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - lazy init

- (MineControllerHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineControllerHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _headerView.btn1.selected = true;
        MJWeakSelf;
        _headerView.clickBack = ^(UIButton* item) {
            [weakSelf.scrollVc scrollWithIndex:item.tag-1];
        };
    }
    return _headerView;
}

- (ScrollControllersVc *)scrollVc{
    if (!_scrollVc) {
        _scrollVc = [[ScrollControllersVc alloc] initWithControllers:@[self.warningVc,self.instituteVc,self.mineInfoVc]];
        _scrollVc.view.frame = self.view.bounds;
        MJWeakSelf;
        _scrollVc.scaleBack = ^(NSNumber* item) {
//            DLog(@"%f",item.floatValue);
            [weakSelf.headerView updateWithScale:item.floatValue];
        };
        _scrollVc.selectBack = ^(NSNumber* item) {
            for (UIButton* button in weakSelf.headerView.btns) {
                button.selected = button.tag == item.integerValue+1;
            }
        };
    }
    return _scrollVc;
}

- (YHWarningNoticeController *)warningVc{
    if (!_warningVc) {
        _warningVc = [[YHWarningNoticeController alloc] init];
    }
    return _warningVc;
}

- (YHInstituteController *)instituteVc{
    if (!_instituteVc) {
        _instituteVc = [[YHInstituteController alloc] init];
    }
    return _instituteVc;
}

- (MineInfoViewController *)mineInfoVc{
    if (!_mineInfoVc) {
        _mineInfoVc = [[MineInfoViewController alloc] init];
    }
    return _mineInfoVc;
}

@end
