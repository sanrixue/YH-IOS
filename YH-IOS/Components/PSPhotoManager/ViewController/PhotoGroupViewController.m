//
//  PhotoGroupViewController.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoGroupViewController.h"
#import "PhotoGroupCell.h"
#import "PhotoCollectionViewController.h"

static NSString *const reUse = @"reUse";

@interface PhotoGroupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray <ALAssetsGroup *>*dataArray;

@end

@implementation PhotoGroupViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self buildingParams];
    [self configureUI];
    [self loadPhotoGroup];
}

- (void)buildingParams {
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.dataArray = [NSMutableArray array];
}

#pragma mark -
#pragma mark - configureUI
- (void)configureUI {
    // navigationItem
    self.title = @"照片";
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self rightBarButton:@"取消" selector:@selector(cancelBarButtonItemAction:)];
    
    // add subview to self.view
    [self.view addSubview:self.tableView];
        
    // register cell
    [self.tableView registerClass:[PhotoGroupCell class] forCellReuseIdentifier:reUse];
}

- (void)cancelBarButtonItemAction:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - load photos
- (void)loadPhotoGroup {
    // iOS 9
    //    PHPhotoLibrary
    WeakSelf(self)
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([group numberOfAssets] > 0) {
            [weakSelf.dataArray addObject:group];
        } else {
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark - tableView protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PhotoGroupCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:reUse forIndexPath:indexPath];
    ALAssetsGroup *group = self.dataArray[indexPath.row];
    UIImage *image = [[UIImage alloc] initWithCGImage:[group posterImage]];
    NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
    NSInteger numberOfAssets = [group numberOfAssets];
    [cell reloadDataWithImage:image groupName:groupName photoNumber:numberOfAssets];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // push to next view controller
    PhotoCollectionViewController *photoCollectionVC = [[PhotoCollectionViewController alloc] init];
    photoCollectionVC.photoGroup = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:photoCollectionVC animated:YES];
}

#pragma mark -
#pragma mark - getter methods
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
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
