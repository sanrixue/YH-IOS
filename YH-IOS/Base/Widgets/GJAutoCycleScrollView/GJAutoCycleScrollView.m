//
//  GJAutoCycleScrollView.m
//  GJAutoCycleScrollViewSample
//
//  Created by devgj on 15/5/3.
//  Copyright (c) 2015年 devgj. All rights reserved.

#import "GJAutoCycleScrollView.h"
#import "AppColor.h"


@interface GJImageItem : UICollectionViewCell

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) UIImageView *imageView;

/*** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImage* placeHolder;
@end

@implementation GJImageItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        self.backgroundView = imageView;
        _imageView = imageView;
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    imageUrl = [imageUrl removeString:@"(null)"];
    _imageUrl = imageUrl;
    if (!(imageUrl && imageUrl.length > 0)) {
        _imageView.image = self.placeHolder;
        return;
    }
    if ([imageUrl hasPrefix:@"http"]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:_placeHolder];
        
    } else {
        _imageView.image = [UIImage imageNamed:imageUrl];
        DLog(@"_imageView ================ %@",_imageView.image);
    }
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    [self configureTitleLabel];
    _titleLabel.text = [NSString stringWithFormat:@" %@", title];
}


- (void)configureTitleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        titleLabel.backgroundColor = [UIColor clearColor];

        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_titleLabel) {
        CGFloat titleLabelH = 30;
        _titleLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - titleLabelH, CGRectGetWidth(self.bounds), titleLabelH);
    }
    _imageView.frame = self.bounds;
}
@end

NSString * const itemID = @"itemID";

@interface GJAutoCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL timerIsStop;

@end

@implementation GJAutoCycleScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _timeIntervalForAutoScroll = 3.0;
    _autoScroll = YES;
    [self configureImageView];
    [self configurePageControl];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeIntervalForAutoScroll = 1.0;
        _autoScroll = YES;
        [self configureImageView];
        [self configurePageControl];
    }
    return self;
}

- (void)setPageControllBGColor:(UIColor *)pageControllBGColor
{
    _pageControl.currentPageIndicatorTintColor = pageControllBGColor;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#e6e6e6"];
}

- (void)dealloc
{
    DLog(@"GJAutoCycleScrollView 销毁了");
}

- (void)configurePageControl
{
    UIPageControl *pageControll = [[UIPageControl alloc] init];
    /** 设置小点点颜色 */
    pageControll.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#00bc5d"];
    pageControll.pageIndicatorTintColor = [UIColor colorWithHexString:@"#c7c7c7"];
    
//    /** 自定义pageControl背景图 */
//    [pageControll setValue:[UIImage imageNamed:@"fanye2"] forKeyPath:@"pageImage"];
//    [pageControll setValue:[UIImage imageNamed:@"fanye1"] forKeyPath:@"currentPageImage"];
    
    [self addSubview:pageControll];
    _pageControl = pageControll;
}


- (void)configureTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeIntervalForAutoScroll target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)fireTimer
{
    [self configureTimer];
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (!_autoScroll) {
        [self invalidateTimer];
    } else {
        [self configureTimer];
    }
}

- (void)configureImageView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
     UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerClass:[GJImageItem class] forCellWithReuseIdentifier:itemID];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    _collectionView.frame = self.bounds;
    _flowLayout.itemSize = size;
    
    CGSize pageControlSize = [_pageControl sizeForNumberOfPages:_dataCount];
    if ([_dataSource respondsToSelector:@selector(autoCycleScrollView:titleAtIndex:)]) {
        CGFloat w = pageControlSize.width;
        CGFloat h = pageControlSize.height;
        if (w > 0) {
//            _pageControl.frame = CGRectMake(size.width - 8 - w, size.height - 15 - h * 0.5, w, h);
            _pageControl.frame = CGRectMake(self.center.x-w/2.0, size.height - 15 - h * 0.5, w, h);

        }
    } else {
//        _pageControl.center = CGPointMake(size.width * 0.5, size.height - 15);
        _pageControl.center = CGPointMake(self.center.x, size.height - 15);
          _pageControl.bounds = (CGRect){CGPointZero, pageControlSize};
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _dataCount = [_dataSource numberOfPagesInAutoCycleScrollView:self];
    if (_dataCount == 1) {
        _itemCount = _dataCount;
    } else if (_dataCount > 10) {
        _itemCount = _dataCount * 10;
    } else {
        _itemCount = _dataCount * (12 - _dataCount) * 10;
        
    }
    return _itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GJImageItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    NSInteger index = indexPath.item % _dataCount;
    item.placeHolder=self.placeholderImage;
    item.imageUrl = [_dataSource autoCycleScrollView:self imageUrlAtIndex:index];
    if ([_dataSource respondsToSelector:@selector(autoCycleScrollView:titleAtIndex:)]) {
        item.title = [_dataSource autoCycleScrollView:self titleAtIndex:index];
    }
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(autoCycleScrollView:didSelectPageAtIndex:)]) {
        NSInteger index = indexPath.item % _dataCount;
        [_delegate autoCycleScrollView:self didSelectPageAtIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5);
    page %= _dataCount;
    if (_pageControl.currentPage != page) {
        _pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (!_timerIsStop) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_timerIsStop) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(activeTimer) object:nil];
        [self performSelector:@selector(activeTimer) withObject:nil afterDelay:_timeIntervalForAutoScroll];
    }
}

- (void)activeTimer
{
    _timerIsStop = NO;
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
    _timerIsStop = YES;
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)reloadData
{
    [_collectionView reloadData];
    
    [self performSelector:@selector(setupInitLocation) withObject:self afterDelay:0.1];
}

- (void)scrollImage
{
    if (_itemCount == 0) {
        return;
    }
    NSInteger currentPage = _collectionView.contentOffset.x / _flowLayout.itemSize.width;
    NSInteger desPage = currentPage + 1;
    if (desPage == _itemCount) {
        [self scrollToMiddle];
    } else {
        [self scrollToItemAtIndex:desPage animated:YES];
    }
}

- (void)setupInitLocation
{
    _pageControl.numberOfPages = _dataCount;
    [self setNeedsLayout];
    if (_dataCount > 1) {
        _pageControl.hidden = NO;
        if (_autoScroll) {
            [self configureTimer];
        }
        [self scrollToMiddle];
    } else {
        [self invalidateTimer];
        _pageControl.hidden = YES;
    }
}

- (void)scrollToMiddle
{
    [self scrollToItemAtIndex:_itemCount * 0.5 animated:NO];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (void)setDataSource:(id<GJAutoCycleScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

@end
