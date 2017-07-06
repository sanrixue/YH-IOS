//
//  PhotoNavigationController.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoNavigationController.h"
#import "PhotoGroupViewController.h"
#import "PhotoSelectManager.h"
#import "PhotoCollectionViewController.h"

// 默认最大选择数量
static NSInteger const kDefaultMaxSelectedCount = 3;

@interface PhotoNavigationController ()

@property (nonatomic, copy, readwrite) GetPhotosBlock block;

@end

@implementation PhotoNavigationController

#pragma mark -
#pragma mark - init methods
- (instancetype)init {
    PhotoGroupViewController *photoGroupViewController = [[PhotoGroupViewController alloc] init];
    self = [super initWithRootViewController:photoGroupViewController];
    if (self) {
        
//        PhotoCollectionViewController *photoCollectionVC = [[PhotoCollectionViewController alloc] init];
//        photoCollectionVC.photoGroup = self.dataArray[indexPath.row];
//        [self.navigationController pushViewController:photoCollectionVC animated:YES];

        self.maxSelectedCount = kDefaultMaxSelectedCount;
        [self setNavigationBarColor];
    }
    return self;
}

- (instancetype)initWithMaxSelectedCount:(NSInteger)maxSelectedCount {
    PhotoGroupViewController *photoGroupViewController = [[PhotoGroupViewController alloc] init];
    self = [super initWithRootViewController:photoGroupViewController];
    if (self) {
        self.maxSelectedCount = maxSelectedCount;
        [self setNavigationBarColor];
    }
    return self;
}

- (void)setNavigationBarColor {
    [self.navigationBar leo_setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
}

- (void)getSelectedPhotosWithBlock:(GetPhotosBlock)block {
    self.block = block;
}

#pragma mark -
#pragma mark - reset status barStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark - getter methods
- (void)setMaxSelectedCount:(NSInteger)maxSelectedCount {
    [PhotoSelectManager setMaxSelectedCount:maxSelectedCount];
}

- (NSInteger)maxSelectedCount {
    return [PhotoSelectManager maxSelectedCount];
}

- (void)dealloc {
    [PhotoSelectManager removeAllAssets];
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
