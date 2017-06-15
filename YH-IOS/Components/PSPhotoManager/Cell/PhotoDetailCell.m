//
//  PhotoDetailCell.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoDetailCell.h"
#import "PhotoManagerConfig.h"

static CGFloat const kMaxScale = 4.f;
static CGFloat const kMinScale = 1.f;

@interface PhotoDetailCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) CGFloat currentScale;

@end

@implementation PhotoDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentScale = kMinScale;
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)handleDoubleTapAction:(UITapGestureRecognizer *)sender {
    // 平均倍数
    CGFloat averageScale = (kMaxScale + kMinScale) / 2;

    if (self.currentScale == kMaxScale) {
        // 当前倍数等于最大放大倍数
        // 双击默认缩小为原图
        self.currentScale = kMinScale;
    } else if (self.currentScale == kMinScale) {
        // 当前等于最小放大倍数
        // 双击默认放大到最大倍数
        self.currentScale = kMaxScale;
    } else if (self.currentScale >= averageScale) {
        // 当前倍数大于平均倍数
        // 双击默认为放大到最大倍数
        self.currentScale = kMaxScale;
    } else {
        // 当前倍数小于平均倍数
        // 双击默认为放大到最小倍数
        self.currentScale = kMinScale;
    }
    [self.scrollView setZoomScale:self.currentScale animated:YES];
}

- (void)reloadDataWithAsset:(ALAsset *)asset {
    self.asset = asset;
    ALAssetRepresentation *representation = [self.asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
    if (image.size.width < kScreenWidth/* && image.size.height < kScreenHeight */) {
        _imageView.contentMode = UIViewContentModeScaleToFill;
    } else {
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.imageView.width = kScreenWidth;
    self.imageView.height = kScreenWidth * image.size.height / image.size.width;
    self.imageView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.imageView.image = image;
    // 每次滚动后重设为显示原图
    [self.scrollView setZoomScale:1.f animated:YES];
}

#pragma mark -
#pragma mark - scrollView protocol methods
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.currentScale = scale;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark -
#pragma mark - getter methods
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = YES;
        _scrollView.minimumZoomScale = kMinScale;
        _scrollView.maximumZoomScale = kMaxScale;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

@end
