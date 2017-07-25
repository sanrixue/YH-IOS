//
//  ViewController.m
//  
//
//  Created by CJG on 16/7/25.
//  Copyright © 2016年 CJG. All rights reserved.
//


#import "ScrollControllersVc.h"
#import "UIColor+Utilities.h"
#import <YYKit/YYKit.h>

#define LableH _lableH
#define LableW _lableW

@interface ScrollControllersVc ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* titleScrollView;
@property (nonatomic, strong) UIScrollView* controllersScrollView;
@property (nonatomic, strong) NSArray* controllers;
@property (nonatomic, strong) NSArray* titles;
@property (nonatomic, strong) UIView* hightLightView;
@end

@implementation ScrollControllersVc

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setLableW:100];
        [self setLableH:45];
        _curIndex = 0;
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray*)controllers titles:(NSArray *)titles{
    self = [super init];
    if (self) {
        self.controllers = controllers;
        self.titles = titles;
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray *)controllers{
    self = [self init];
    if (self) {
        self.controllers = controllers;
        NSMutableArray *titles = [NSMutableArray new];
        for (int i=0; i<controllers.count ;i++ ) {
            [titles addObject:@" "];
        }
        self.titleScrollView.hidden = YES;
        self.titles = titles;
        self.lableH = 0.1;
        self.lableW = 0.1;
        
    }
    return self;
}

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] init ];//WithFrame:CGRectMake(0, 0, self.view.mj_w, LableH)];
        _titleScrollView.backgroundColor = [UIColor whiteColor];
        _titleScrollView.clipsToBounds = YES;
        [self.view addSubview:_titleScrollView];
    }
    return _titleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addScrollView];
    [self addControllers];
    [self addTitles];
    [self scrollWithIndex:_curIndex];
    [self scrollViewDidScroll:self.controllersScrollView];
}

- (void)updateTitles:(NSArray *)titles{
    _titles = titles;
    [self addTitles];
    [self scrollWithScrollView:_controllersScrollView];
}

- (void)updateControllers:(NSArray *)controllers titles:(NSArray *)titles{
    for (UIView* view in self.view.subviews) {
        [view removeFromSuperview];
    }
    for (UIViewController* vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    self.controllers = controllers;
    [self addControllers];
    _curIndex = 0;
    self.titles = titles;
    [self addScrollView];
    [self addTitles];
    [self scrollWithIndex:_curIndex];
//    [self scrollViewDidScroll:self.controllersScrollView];
}

- (void)addScrollView{
    _controllersScrollView = [[UIScrollView alloc] init];//WithFrame:CGRectMake(0, LableH, self.view.mj_w, self.view.mj_h-LableH)];
    _controllersScrollView.bounces = NO;
    _controllersScrollView.showsHorizontalScrollIndicator = NO;
    _controllersScrollView.delegate = self;
//    _controllersScrollView.backgroundColor = [UIColor blueColor];
    
    _hightLightView = [[UIView alloc] initWithFrame:CGRectMake((_lableW-16)/2.0, _lableH-3, 45, 3)];
    _hightLightView.backgroundColor = [UIColor colorWithHexString:@"#00a4e9"];
    [self.titleScrollView addSubview:_hightLightView];
    [self.view addSubview:_controllersScrollView];
    
    _titleScrollView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).widthIs(self.view.width_sd).heightIs(_lableH);
    _controllersScrollView.sd_layout.topSpaceToView(_titleScrollView, 0).leftEqualToView(self.view).rightEqualToView(self.view).widthIs(self.view.width_sd).bottomSpaceToView(self.view, 0);
    
}

- (void)addControllers{
    for (int i = 0; i<_controllers.count; i++) {
        [self addChildViewController:_controllers[i]];
    }
    _controllersScrollView.contentSize = CGSizeMake(self.view.width_sd*self.childViewControllers.count, 0);
}

- (void)setLableH:(CGFloat)lableH{
    _lableH = lableH;
    if (_titleScrollView.superview) {
        self.titleScrollView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).widthIs(self.view.width_sd).heightIs(lableH);
        //    _titleScrollView.fixedHeight = @(_lableH);
        _hightLightView.centerX = _curIndex*LableW + 0.5*LableW;
        _hightLightView.bottom = lableH;
        _hightLightView.width = 45;
        [self addTitles];
        [self scrollWithIndex:_curIndex];
    }

}

- (void)setLableW:(CGFloat)lableW{
    _lableW = lableW;
    _hightLightView.centerX = _curIndex*LableW + 0.5*LableW;
    _hightLightView.bottom = LableH;
    _hightLightView.width = 45;
    [self addTitles];
    [self scrollWithIndex:_curIndex];
}

- (void)addTitles{
    for (UILabel* lable in _titleScrollView.subviews) {
        if ([lable isKindOfClass:[UILabel class]]) {
            [lable removeFromSuperview];
        }
    }
    for (int i=0; i<self.childViewControllers.count; i++) {
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lableOnclic:)];
        UILabel *lable            = [[UILabel alloc] initWithFrame:CGRectMake(i*LableW, 0, LableW, LableH)];
        lable.tag                    = i+1;
        lable.text                   = _titles[i];
        lable.backgroundColor        = [UIColor whiteColor];
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setUserInteractionEnabled:YES];
        [lable addGestureRecognizer:tap];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = UIColorHex(979797);
        [self.titleScrollView addSubview:lable];
    }
    [_titleScrollView bringSubviewToFront:_hightLightView];
    _titleScrollView.contentSize = CGSizeMake(self.childViewControllers.count*LableW, 0);
}

- (void)lableOnclic:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    [self scrollWithIndex:index-1];
}

- (void)scrollWithIndex:(NSInteger)index{
    if (index >= self.controllers.count) { return; }
    _curIndex = index;
    CGFloat offset_x = LableW*index - self.view.width_sd*0.5+LableW*0.5;
    if (offset_x>0 && offset_x<(_titleScrollView.contentSize.width-self.view.width_sd)) {
        [_titleScrollView setContentOffset:CGPointMake(offset_x, 0) animated:YES];
    }else if (offset_x<0){
        [_titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [_titleScrollView setContentOffset:CGPointMake(_titleScrollView.contentSize.width-self.view.width_sd, 0) animated:YES];
    }
    
    UILabel *nowLabel = [_titleScrollView viewWithTag:index+1];
    for (UILabel *lable in self.titleScrollView.subviews) {
        if ([lable isKindOfClass:[UILabel class]]) {
            if (lable != nowLabel) {
                lable.textColor =  UIColorHex(616161);
                lable.font = [UIFont systemFontOfSize:13];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        nowLabel.textColor = UIColorHex(00a4e9);
        nowLabel.font = [UIFont systemFontOfSize:15];
    }];
    
    UIViewController *vc = self.childViewControllers[index];
    [_controllersScrollView setContentOffset:CGPointMake((index)*self.view.width_sd, 0) animated:YES];
        
    if (![vc isViewLoaded] || vc.view.superview != self.controllersScrollView) {
        [self.controllersScrollView addSubview:vc.view];
        vc.view.sd_layout.topEqualToView(_controllersScrollView).leftEqualToView(_controllersScrollView).offset(self.view.width_sd*index).widthIs(self.view.width_sd).bottomEqualToView(_controllersScrollView);
        }
    }
    if (self.selectBack) {
        self.selectBack(@(index));
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   CGFloat scale = scrollView.contentOffset.x/scrollView.width;
    if (scale>=0 && scale<=self.controllers.count-1) {
        _hightLightView.centerX = 0.5*LableW + scale*LableW;
        if (self.scaleBack) {
            self.scaleBack(@(scale));
        }
    }
//    if (scale<0) {
//        scale = 0.0; // 处理边缘
//    }
//    if (scale>self.controllers.count) {
//        scale = self.controllers.count;
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollWithScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGFloat offx = scrollView.contentOffset.x;
    CGFloat width = self.view.frame.size.width;
    NSInteger index = -1;
    if (offx<0) {
        index = 0;
    }else if (offx>self.childViewControllers.count*width - width){
        index = self.childViewControllers.count -1;
    }else{
        if (offx - _curIndex*width<0 && _curIndex>0) {
            index = _curIndex-1;
        }else{
            if (_curIndex<self.controllers.count-1 && offx!=0) {
                index = _curIndex+1;
            }
        }
    }
    if (index>-1) {
        [self scrollWithIndex:index];
    }
    
}

- (void)scrollWithScrollView:(UIScrollView*)scrollView{
    NSInteger index;
    CGPoint offset = scrollView.contentOffset;
    if (offset.x<=0) {
        index = 0;
    }else if (offset.x >= (scrollView.contentSize.width)){
        index = self.childViewControllers.count -1;
    }else{
        index =(int)offset.x/self.view.width_sd;
        CGFloat x = offset.x - index*self.view.width_sd;
        if (x>self.view.width_sd*0.5) {
            index++;
        }
    }
    
    [self scrollWithIndex:index];
}

- (void)dealloc{
    NSLog(@"循环滚动控制器 ====== 销毁了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
