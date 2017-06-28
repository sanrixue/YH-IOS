//
//  GuidePageViewController.m
//  YH-IOS
//
//  Created by li hao on 16/12/13.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#define mSCREEN [[UIScreen mainScreen]bounds]
#define mWIDTH  mSCREEN.size.width
#define mHEIGHT  mSCREEN.size.height
#define mVIEWWIDTH self.view.frame.size.width
#define mVIEWHEIGHT self.view.frame.size.height

#import "GuidePageViewController.h"
#import "UIColor+Hex.h"
#import "LoginViewController.h"


@interface GuidePageViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong) NSMutableArray *imageViews;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *registerButton;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UILabel *detailLabel;


@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.images = @[@"guide-one", @"guide-two", @"guide-three",@"guide-four"];
    _imageViews = [NSMutableArray new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(40, mHEIGHT - mHEIGHT / 4.5, mWIDTH - 80, 40)];
    self.loginButton.layer.cornerRadius = 5.0f;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor whiteColor];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(jumpToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatWelcomeView];
}


#pragma mark -显示图片
- (void)showImge:(UIImage *)showImage atImageView :(UIImageView *)image {
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(mWIDTH / 2 - 75, mHEIGHT / 4.5, 150, 150)];
    titleImage.image = showImage;
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
   // [image addSubview:titleImage];
}

#pragma mark 创建引导页
- (void)creatWelcomeView {
    _scrollview = [[UIScrollView alloc] initWithFrame:mSCREEN];
    _scrollview.pagingEnabled = YES;
    _scrollview.contentSize = CGSizeMake(mWIDTH * _images.count, mHEIGHT);
    _scrollview.delegate = self;
    _scrollview.bounces = NO;
    _scrollview.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_scrollview];
    for (int i = 0; i < _images.count; i++) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_images objectAtIndex:i]]];
        _imageView.frame = CGRectMake(i * mWIDTH, 0, mWIDTH, mHEIGHT);
        _imageView.userInteractionEnabled = YES;
        [_imageView setTag:100 + i];
        [_scrollview addSubview:_imageView];
        if (_imageView.tag == 100) {
           // [_imageView addSubview:self.loginButton];
           // [self showImge:[UIImage imageNamed:@"logo"] atImageView:_imageView];
        }
        [_imageViews addObject:_imageView];
    }
    
    // 添加分页控制
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, mHEIGHT-mHEIGHT / 3, mWIDTH, mWIDTH / 5)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = _images.count;
    _pageControl.tintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"4c8ba7"];
    [_pageControl addTarget:self action:@selector(pageControlClicked) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.loginButton];
    //[self.view addSubview:self.registerButton];
   // [self.view addSubview:self.lineView];
  //  [self.view addSubview:_pageControl];
}

#pragma mark 点击登录按钮事件
- (void)jumpToLogin {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    [[[UIApplication sharedApplication] keyWindow]  setRootViewController:initViewController];
    [[[UIApplication sharedApplication] keyWindow] makeKeyAndVisible];
}

#pragma mark -page标记转换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = (scrollView.contentOffset.x - scrollView.frame.size.width / 2) / self.view.frame.size.width + 1;
    if (_pageControl.currentPage == 3) {
        [self jumpToLogin];
    }
    if (page > _pageControl.currentPage) {
        [_scrollview scrollRectToVisible:CGRectMake(page * mVIEWWIDTH, 0, mVIEWWIDTH, mVIEWHEIGHT) animated:YES];
    }
    else {
        [_scrollview scrollRectToVisible:CGRectMake(page * mVIEWWIDTH, 0, mVIEWWIDTH, mVIEWHEIGHT) animated:YES];
    }
    _pageControl.currentPage = page;
}


#pragma mark -分页控制点击事件
- (void)pageControlClicked {
    [_scrollview scrollRectToVisible:CGRectMake(_pageControl.currentPage * mVIEWWIDTH, 0, mVIEWWIDTH, mVIEWHEIGHT) animated:YES];
}

#pragma mark -滚动试图改变颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = mWIDTH;
    int page = floor(_scrollview.contentOffset.x / pageWidth) ;
    if (page == 0) {
        self.loginButton.backgroundColor = [UIColor whiteColor];
        [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.lineView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (page == 1) {
        self.loginButton.backgroundColor = [UIColor colorWithHexString:@"4c8ba7"];
        [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.lineView.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    if (page == 2) {
        self.loginButton.backgroundColor = [UIColor colorWithHexString:@"4c8ba7"];
        [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.lineView.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
