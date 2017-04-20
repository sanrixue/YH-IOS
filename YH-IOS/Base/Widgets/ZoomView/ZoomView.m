//
//  ZoomView.m
//  Chart
//
//  Created by lin.tk on 2016/11/2.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "ZoomView.h"
#import "UIImage+Category.h"

@interface ZoomView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation ZoomView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加控件
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imgView];
        //添加单机手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallTap:)];
        [tap setNumberOfTapsRequired:1];
        [self.scrollView addGestureRecognizer:tap];
        //添加双击手势
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [self.scrollView addGestureRecognizer:doubleTapGestureRecognizer];
        //单双击兼容
        [tap requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    }
    return self;
}

/** 设置图片 */
-(void)setZoomImageView:(UIImageView *)zoomImageView{
    _zoomImageView = zoomImageView;
    _imgView.image = self.zoomImageView.image;
    
}

/** 单击 */
- (void)smallTap:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = NO;
        [self removeFromSuperview];
    }];
}


/** 双击 */
- (void)doubleTap:(UITapGestureRecognizer *)tap{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    if (scrollView.zoomScale < 3.0) {
        scrollView.zoomScale = 3.0;
    }else{
        scrollView.zoomScale = 1.0;
    }
    
}


#pragma mark  UIScrollViewDelegated代理
/** 缩放的控件 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _imgView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat delta_x= scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    
    CGFloat delta_y= scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    
    _imgView.center=CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
    
}


#pragma mark 创建控件
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.backgroundColor = [UIColor blackColor];
        [_scrollView setAlpha:1];
    }
    return _scrollView;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
        
    }
    return _imgView;
}


#pragma mark 布局控件
-(void)layoutSubviews{
    CGFloat y,width,height;
    
    CGSize size = [_zoomImageView.image imageWithMaxWidth:120 * SCREEN_SCALE];
    
    y = ([UIScreen mainScreen].bounds.size.height - size.height * [UIScreen mainScreen].bounds.size.width /size.width) * 0.5;
    //宽度为屏幕宽度
    width = [UIScreen mainScreen].bounds.size.width;
    //高度 根据图片宽高比设置
    height = size.height * [UIScreen mainScreen].bounds.size.width / size.width;
   
    [_imgView setFrame:CGRectMake(0, y, width, height)];
}



@end
