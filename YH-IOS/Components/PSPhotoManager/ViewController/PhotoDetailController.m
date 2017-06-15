//
//  PhotoDetailController.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoDetailController.h"
#import "PhotoSelectButton.h"
#import "PhotoDetailCell.h"
#import "BottomToolbar.h"
#import "PhotoNavigationController.h"

static CGFloat const kToolbarHeight = 42.f;
static NSString *const reUse = @"reUse";

@interface PhotoDetailController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PhotoSelectButton *selectButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BottomToolbar *bottomToolbar;

@end

@implementation PhotoDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomToolbar.bottom = kScreenHeight;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUI];
}

- (void)configureUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // add subviews
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomToolbar];
    self.bottomToolbar.top = kScreenHeight;

    // tap action
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    // register cell
    [self.collectionView registerClass:[PhotoDetailCell class] forCellWithReuseIdentifier:reUse];
    [self.collectionView reloadData];

    // set default contentOffset
    [self.collectionView setContentOffset:CGPointMake(self.index * self.collectionView.width, 0) animated:NO];
    // set select photos count
    [self.bottomToolbar resetSelectPhotosNumber:[PhotoSelectManager selectedAssets].count];
    ALAsset *asset = self.dataArray[self.index];
    if ([[PhotoSelectManager selectedAssets] containsObject:asset]) {
        self.selectButton.selected = YES;
    }
}

- (void)dealloc {

}

#pragma mark -
#pragma mark - collectionView protocol methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUse forIndexPath:indexPath];
    [cell reloadDataWithAsset:self.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = round(scrollView.contentOffset.x / scrollView.width);
    ALAsset *asset = self.dataArray[self.index];
    if ([[PhotoSelectManager selectedAssets] containsObject:asset]) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
}

#pragma mark -
#pragma mark - getter methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat kLineSpacing = 20;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, kLineSpacing);
        layout.minimumLineSpacing = kLineSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth + kLineSpacing, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;        
    }
    return _collectionView;
}

#pragma mark -
#pragma mark - getter methods
- (BottomToolbar *)bottomToolbar {
    if (!_bottomToolbar) {
        _bottomToolbar = [[BottomToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - kToolbarHeight, kScreenWidth, kToolbarHeight)];
        _bottomToolbar.barStyle = UIBarStyleBlack;
        [_bottomToolbar hiddenPreviewButton];
        [_bottomToolbar resetFinishedButtonEnable:YES];
        
        WeakSelf(self)
        // handle click callback
        [_bottomToolbar handlePreviewButtonWithBlock:^{
            
        }];
        
        [_bottomToolbar handleFinishedButtonWithBlock:^{
            [weakSelf handleSelectedFinished];
        }];
    }
    return _bottomToolbar;
}

- (PhotoSelectButton *)selectButton {
    if (!_selectButton) {
        CGFloat kSelectButtonWidth = 38;
        
        _selectButton = [PhotoSelectButton buidingSelectButton];
        _selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        _selectButton.size = CGSizeMake(kSelectButtonWidth, kSelectButtonWidth);
        _selectButton.left = 20;
        
        WeakSelf(self)
        // handle click
        [_selectButton handleSelectButtonClickWithBlock:^(PhotoSelectButton *selectButton, BOOL isSelected) {
            if ([PhotoSelectManager selectedAssets].count >= [PhotoSelectManager maxSelectedCount]) {
                [PSMessageDialog showMessageDialog:@"您选择的图片数量已达到上限"];
                selectButton.selected = NO;
                return;
            }
            if (isSelected) {
                [ScaleAnimation addScaleAnimation:selectButton];
                [PhotoSelectManager addAsset:weakSelf.dataArray[weakSelf.index]];
            } else {
                [PhotoSelectManager removeAsset:weakSelf.dataArray[weakSelf.index]];
            }
            [self.bottomToolbar resetSelectPhotosNumber:[PhotoSelectManager selectedAssets].count];
        }];
    }
    return _selectButton;
}

#pragma mark -
#pragma mark - handle click action
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTapAction:(UITapGestureRecognizer *)sender {
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomToolbar.bottom = kScreenHeight;
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomToolbar.top = kScreenHeight;
        }];
    }
}

#pragma mark -
#pragma mark - selected action finished
- (void)handleSelectedFinished {
    if (![PhotoSelectManager selectedAssets].count) {
        [PSMessageDialog showMessageDialog:@"您还没有选择相片"];
        return;
    }
    // 传值回调
    PhotoNavigationController *navigationController = (PhotoNavigationController *)self.navigationController;
    Block_exe(navigationController.block, [PhotoSelectManager selectedAssets])
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
