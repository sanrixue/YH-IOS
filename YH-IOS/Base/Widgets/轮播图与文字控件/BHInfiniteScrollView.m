//
//  BHInfiniteScrollView.m
//  BHInfiniteScrollView
//
//  Created by libohao on 16/3/6.
//  Copyright © 2016年 libohao. All rights reserved.
//
/*
 *********************************************************************************
 *
 * 如果您使用轮播图库的过程中遇到Bug,请联系我,我将会及时修复Bug，为你解答问题。
 * QQ讨论群 :  206177395 (BHInfiniteScrollView讨论群)
 * Email:  375795423@qq.com
 * GitHub: https://github.com/qylibohao
 *
 *
 *********************************************************************************
 */

#import "BHInfiniteScrollView.h"
#import "BHInfiniteScrollViewCell.h"

@interface BHInfiniteScrollView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _multiple;
    NSInteger _totalPageCount;
    BHInfiniteScrollViewCell* _currentCell;
    
}
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, weak) NSTimer *timer;


@end

@implementation BHInfiniteScrollView

#pragma mark - Init Method

+ (instancetype)infiniteScrollViewWithFrame:(CGRect)frame Delegate:(id<BHInfiniteScrollViewDelegate>)delegate ImagesArray:(NSArray *)images {
    BHInfiniteScrollView *infiniteScrollView = [[self alloc] initWithFrame:frame];
    infiniteScrollView.delegate = delegate;
    infiniteScrollView.imagesArray = [NSMutableArray arrayWithArray:images];
    return infiniteScrollView;
}

+ (instancetype)infiniteScrollViewWithFrame:(CGRect)frame Delegate:(id<BHInfiniteScrollViewDelegate>)delegate
                                ImagesArray:(NSArray *)images PlageHolderImage:(UIImage*)placeHolderImage {
    BHInfiniteScrollView *infiniteScrollView = [BHInfiniteScrollView infiniteScrollViewWithFrame:frame Delegate:delegate ImagesArray:images];
    infiniteScrollView.placeholderImage = placeHolderImage;
    return infiniteScrollView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self addSubview:self.collectionView];
        [self addSubview:self.titleView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
    [self addSubview:self.collectionView];
    [self addSubview:self.titleView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.flowLayout.itemSize = self.frame.size;
    if (_needPageControl) {
        [self setupPageControl];
    }
    
    [self updateTitleView];
    
    //scroll to middle postion
    if (self.imagesArray.count) {
        if (self.scrollDirection == BHInfiniteScrollViewScrollDirectionHorizontal) {
            CGFloat middlePageX = _flowLayout.itemSize.width * self.imagesArray.count * _multiple;
            [self.collectionView scrollRectToVisible:CGRectMake(middlePageX,0, _flowLayout.itemSize.width, _flowLayout.itemSize.height) animated:NO];
        }else {
            CGFloat middlePageY = _flowLayout.itemSize.height * self.imagesArray.count * _multiple;
            [self.collectionView scrollRectToVisible:CGRectMake(0, middlePageY, _flowLayout.itemSize.width, _flowLayout.itemSize.height) animated:NO];
        }
        
    }
    
    
}

- (void)dealloc {
    [self resetTimer];
}

- (void)initialize {
    _multiple = 1000;
    _scrollTimeInterval = 3.2;
    _autoScrollToNextPage = YES;
    _scrollDirection = BHInfiniteScrollViewScrollDirectionHorizontal;
    _reverseDirection = NO;
    _pageViewContentMode = UIViewContentModeScaleAspectFill;

    _pageControlAlignmentH =  BHInfiniteScrollViewPageControlAlignHorizontalCenter;
    _pageControlAlignmentV = BHInfiniteScrollViewPageControlAlignVerticalButtom;
    
    if (_scrollDirection == BHInfiniteScrollViewScrollDirectionVertical) {
        _pageControlAlignmentOffset = CGSizeMake(20, 0);
    }else {
        _pageControlAlignmentOffset = CGSizeMake(0, 20);
    }
}

- (void)setupPageControl {
    if (_pageControl) {
        [self.pageControl removeFromSuperview];
    }
    
    if (self.imagesArray.count <= 1) {
        return;
    }
    
    FXPageControl *pageControl = [[FXPageControl alloc] init];
    pageControl.numberOfPages = self.imagesArray.count;
    pageControl.selectedDotColor = [UIColor whiteColor];
    pageControl.dotSize = 10;
    pageControl.dotColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.userInteractionEnabled = NO;
    pageControl.hidesForSinglePage = YES;
    pageControl.vertical = _scrollDirection == BHInfiniteScrollViewScrollDirectionVertical ? YES : NO;
    [self addSubview:pageControl];
    _pageControl = pageControl;

    
    
    [self updatePageControl];

}

- (void)updatePageControl {
    if (!self.imagesArray.count) {
        return;
    }
    
    CGSize size = [self.pageControl sizeForNumberOfPages:self.imagesArray.count];
    
    if (self.scrollDirection == BHInfiniteScrollViewScrollDirectionHorizontal) {
        size = CGSizeMake(size.width * 1.1, size.height);
    }else {
        size = CGSizeMake(size.width, size.height * 1.1);
    }
    
    CGFloat x = 0.0, y = 0.0;
    
    if (self.pageControlAlignmentH == BHInfiniteScrollViewPageControlAlignHorizontalRight) {

        x = CGRectGetWidth(self.frame) - size.width - self.pageControlAlignmentOffset.width;

    }else if (self.pageControlAlignmentH == BHInfiniteScrollViewPageControlAlignHorizontalCenter) {

        x = CGRectGetWidth(self.frame) * 0.5 - size.width*0.5;

    }else if (self.pageControlAlignmentH == BHInfiniteScrollViewPageControlAlignHorizontalLeft) {

        x = self.pageControlAlignmentOffset.width;

    }

    if (self.pageControlAlignmentV == BHInfiniteScrollViewPageControlAlignVerticalButtom) {

        y = CGRectGetHeight(self.frame) - size.height - self.pageControlAlignmentOffset.height;

    }else if (self.pageControlAlignmentV == BHInfiniteScrollViewPageControlAlignVerticalTop) {

        y = self.pageControlAlignmentOffset.height;

    }else if (self.pageControlAlignmentV == BHInfiniteScrollViewPageControlAlignVerticalCenter) {

        y = CGRectGetHeight(self.frame)*0.5 - size.height*0.5;

    }

    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
}

- (void)updateTitleView {
    if (self.currentPageIndex < self.titlesArray.count) {
        self.titleView.titleText = self.titlesArray[self.currentPageIndex];
    }
    
}

#pragma mark - setter

- (void)setImagesArray:(NSArray *)imageUrlsArray {
    

    _imagesArray = imageUrlsArray;
    _totalPageCount = imageUrlsArray.count * _multiple * 2;
    if (imageUrlsArray.count > 1) {
        self.collectionView.scrollEnabled = YES;
        
        [self setAutoScrollToNextPage:_autoScrollToNextPage];
    }else {
        self.collectionView.scrollEnabled = NO;
    }
}

- (void)setScrollDirection:(BHInfiniteScrollViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection == BHInfiniteScrollViewScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;;
}

- (void)setScrollTimeInterval:(NSTimeInterval)scrollTimeInterval {
    _scrollTimeInterval = scrollTimeInterval;
    
    [self resetTimer];
    
    if (_autoScrollToNextPage) {
        [self setupTimer];
    }
    
}

- (void)setAutoScrollToNextPage:(BOOL)autoScrollToNextPage {
    _autoScrollToNextPage = autoScrollToNextPage;
    [self resetTimer];
    
    if (_autoScrollToNextPage) {
        [self setupTimer];
    }
}

- (void)setReverseDirection:(BOOL)reverseDirection {
    _reverseDirection = reverseDirection;
    [self resetTimer];
    
    if (_autoScrollToNextPage) {
        [self setupTimer];
    }
}

#pragma mark - timer func

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)resetTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollToNextPage {
    if(self.imagesArray.count == 0 ) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL hasScrollAnimation = YES;
    
        if (self.scrollDirection == BHInfiniteScrollViewScrollDirectionHorizontal) {
            CGFloat nextPageX ;
            if (self.reverseDirection) {
                nextPageX = self.collectionView.contentOffset.x - _flowLayout.itemSize.width;
                if (nextPageX < 0) {
                    nextPageX = _flowLayout.itemSize.width * self.imagesArray.count * _multiple;
                    hasScrollAnimation = NO;
                }
            }else {
                nextPageX = self.collectionView.contentOffset.x + _flowLayout.itemSize.width;
                if (nextPageX > _flowLayout.itemSize.width * self.imagesArray.count * _multiple * 2) {
                    nextPageX = _flowLayout.itemSize.width * self.imagesArray.count * _multiple;
                    hasScrollAnimation = NO;
                }
            }
            
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(nextPageX,_flowLayout.itemSize.height * 0.5)];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:hasScrollAnimation];
            
        }else {
            CGFloat nextPageY ;
            if (self.reverseDirection) {
                nextPageY = self.collectionView.contentOffset.y - _flowLayout.itemSize.height;
                if (nextPageY < 0) {
                    nextPageY = _flowLayout.itemSize.height * self.imagesArray.count * _multiple;
                    hasScrollAnimation = NO;
                }
            }else {
                nextPageY = self.collectionView.contentOffset.y + _flowLayout.itemSize.height;
                if (nextPageY > _flowLayout.itemSize.height * self.imagesArray.count * _multiple * 2) {
                    nextPageY = _flowLayout.itemSize.height * self.imagesArray.count * _multiple;
                    hasScrollAnimation = NO;
                }
            }
            
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(_flowLayout.itemSize.width * 0.5, nextPageY)];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:hasScrollAnimation];
        }
    });
}

- (void)scrollToPageAtIndex:(NSUInteger)pageIndex Animation:(BOOL)animation {
    if(self.imagesArray.count == 0 ) return;
    
    if (pageIndex < self.imagesArray.count) {
        NSInteger middleNum =  _multiple * self.imagesArray.count;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:middleNum + pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animation];
        
        self.pageControl.currentPage = pageIndex;
        
        if (pageIndex < self.titlesArray.count) {
            self.titleView.titleText = self.titlesArray[pageIndex];
        }
        
        if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didScrollToIndex:)]) {
            [self.delegate infiniteScrollView:self didScrollToIndex:pageIndex];
        }
        
    }
}

#pragma mark - Property

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = self.scrollDirection == BHInfiniteScrollViewScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = self.frame.size;
        _flowLayout = flowLayout;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[BHInfiniteScrollViewCell class] forCellWithReuseIdentifier:BHInfiniteScrollViewCellIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}

- (BHInfiniteScrollViewTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[BHInfiniteScrollViewTitleView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 20, CGRectGetWidth(self.frame), 20)];
    }
    return _titleView;
}

- (NSInteger)currentPageIndex {
    if (!self.imagesArray.count) return 0;

    NSInteger page;
    if (_scrollDirection == BHInfiniteScrollViewScrollDirectionHorizontal) {
        page = self.collectionView.contentOffset.x / _flowLayout.itemSize.width;
    }else {
        page = self.collectionView.contentOffset.y / _flowLayout.itemSize.height;
    }
    
    NSInteger index = page % self.imagesArray.count;
    
    return index;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BHInfiniteScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BHInfiniteScrollViewCellIdentifier forIndexPath:indexPath];
    cell.contentMode = self.pageViewContentMode;
    _currentCell = cell;
    if (_isContentStringMode) {
        NSInteger index = indexPath.row % self.imagesArray.count;
        NSString * contentLabelString = [self.contentStringArray objectAtIndex:index];
        [cell setUpWithText:contentLabelString];
        
    }else{
        if (self.imagesArray.count) {
            NSInteger index = indexPath.row % self.imagesArray.count;
            NSObject* object = [self.imagesArray objectAtIndex:index];
            if ([object isKindOfClass:[NSString class]]) {
                if ([(NSString*)object hasPrefix:@"http://"]) {
                    [cell setupWithUrlString:(NSString*)object placeholderImage:self.placeholderImage];
                }else {
                    [cell setupWithImageName:(NSString*)object placeholderImage:self.placeholderImage];
                }
                
            }else if ([object isKindOfClass:[UIImage class]]) {
                [cell setupWithImage:(UIImage*)object placeholderImage:self.placeholderImage];
            }
        }
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectItemAtIndex:)]) {
        [self.delegate infiniteScrollView:self didSelectItemAtIndex:self.currentPageIndex];
    }
    
    if (self.scrollViewDidSelectBlock) {
        self.scrollViewDidSelectBlock(self,self.currentPageIndex);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScrollToNextPage) {
        [self resetTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScrollToNextPage) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.currentPageIndex;
    
    if (self.currentPageIndex < self.titlesArray.count) {
        self.titleView.titleText = self.titlesArray[self.currentPageIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didScrollToIndex:)]) {
        [self.delegate infiniteScrollView:self didScrollToIndex:self.currentPageIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagesArray.count) return;

    self.pageControl.currentPage = self.currentPageIndex;
    //NSLog(@"%ld",index);
    
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didScrollToIndex:)]) {
        [self.delegate infiniteScrollView:self didScrollToIndex:self.currentPageIndex];
    }
    
    if (self.currentPageIndex < self.titlesArray.count) {
        self.titleView.titleText = self.titlesArray[self.currentPageIndex];
    }
    
}

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com