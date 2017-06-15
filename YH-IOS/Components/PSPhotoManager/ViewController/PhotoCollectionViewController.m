//
//  PhotoCollectionViewController.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoNavigationController.h"
#import "PhotoCell.h"
#import "BottomToolbar.h"
#import "PhotoDetailController.h"

static CGFloat const kToolbarHeight = 42.f;
static NSString *const reUse = @"reUse";

@interface PhotoCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BottomToolbar *toolbar;
@property (nonatomic, strong) NSMutableArray <ALAsset *>*dataArray;
@property (nonatomic, assign) NSInteger lastSelectIndex;

@end

@implementation PhotoCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildingParams];
    [self configureUI];
    [self loadPhotos];
    [self addNotification];
}

- (void)buildingParams {
    self.dataArray = [NSMutableArray array];
    self.lastSelectIndex = 0;
}

- (void)configureUI {
    self.title = [self.photoGroup valueForProperty:ALAssetsGroupPropertyName];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // right barButtonItem
    [self rightBarButton:@"取消" selector:@selector(cancelBarButtonItemAction:)];

    // add to self.view
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolbar];
    
    // register cell
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:reUse];
}

- (void)leftBarButtonItemAction:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBarButtonItemAction:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAssetsUpdate:) name:kSelectAssetsUpdateNotification object:nil];
}

#pragma mark -
#pragma mark - load photos
- (void)loadPhotos {
    WeakSelf(self)
    [_photoGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [weakSelf.dataArray addObject:result];
        } else {
            [weakSelf.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

#pragma mark -
#pragma mark - collectionView protocol methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUse forIndexPath:indexPath];
    ALAsset *asset = self.dataArray[indexPath.row];
    [cell resetSelected:NO];
    if ([[PhotoSelectManager selectedAssets] containsObject:asset]) {
        [cell resetSelected:YES];
    }
    [cell reloadDataWithAsset:asset index:indexPath.row];
    WeakSelf(self)
    [cell getPhotoSelectedIndexWithBlock:^(NSInteger selectedIndex) {
        weakSelf.lastSelectIndex = selectedIndex;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    PhotoDetailController *photoDetailVC = [[PhotoDetailController alloc] init];
    photoDetailVC.dataArray = self.dataArray;
    photoDetailVC.index = indexPath.row;
    [self.navigationController pushViewController:photoDetailVC animated:YES];
}

#pragma mark -
#pragma mark - kSelectAssetsUpdateNotification
- (void)selectedAssetsUpdate:(NSNotification *)notification {
    if ([PhotoSelectManager selectedAssets].count > 0) {
        [self.toolbar resetPreviewButtonEnable:YES];
        [self.toolbar resetSelectPhotosNumber:[PhotoSelectManager selectedAssets].count];
        [self.toolbar resetFinishedButtonEnable:YES];
    } else {
        [self.toolbar resetPreviewButtonEnable:NO];
        [self.toolbar resetSelectPhotosNumber:0];
        [self.toolbar resetFinishedButtonEnable:NO];
    }
}

#pragma mark -
#pragma mark - getter methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat kPadding = 3.f;
        CGFloat kWidth = (kScreenWidth - 5 * kPadding) / 4;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWidth, kWidth);
        layout.sectionInset = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
        layout.minimumInteritemSpacing = kPadding;
        layout.minimumLineSpacing = kPadding;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXCOLOR(0xffffff);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;        
    }
    return _collectionView;
}

- (BottomToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[BottomToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - kToolbarHeight, kScreenWidth, kToolbarHeight)];
        
        WeakSelf(self)
        // handle click callback
        [_toolbar handlePreviewButtonWithBlock:^{
            PhotoDetailController *photoDetailVC = [[PhotoDetailController alloc] init];
            photoDetailVC.dataArray = weakSelf.dataArray;
            photoDetailVC.index = weakSelf.lastSelectIndex;
            [self.navigationController pushViewController:photoDetailVC animated:YES];
        }];
        
        [_toolbar handleFinishedButtonWithBlock:^{
            [weakSelf handleSelectedFinished];
        }];
        
        // collectionView edgeInsets
        UIEdgeInsets insets = _collectionView.contentInset;
        insets.bottom = kToolbarHeight;
        _collectionView.contentInset = insets;
    }
    return _toolbar;
}

#pragma mark -
#pragma mark - dealloc
- (void)dealloc {
    [PhotoSelectManager removeAllAssets];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSelectAssetsUpdateNotification object:nil];
}

#pragma mark -
#pragma mark - selected action finished
- (void)handleSelectedFinished {
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
