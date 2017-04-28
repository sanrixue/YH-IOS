//
//  TableViewAndCollectionPackage.m
//  JinXiaoEr
//
//  Created by cjg on 16/11/22.
//
//

#import "TableViewAndCollectionPackage.h"
#import "GifRefreshHeader.h"

@implementation PackageConfig


@end

@interface TableViewAndCollectionPackage () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



/** tableView和collection共用的block */
@property (nonatomic, strong) CellBack cellBack; // cell实例
@property (nonatomic, strong) CellSizeBack cellSizeBack; // cell大小回调
@property (nonatomic, strong) CellNumBack cellNumBack; // cell数量回调
@property (nonatomic, strong) SelectedBack selectedBack; // 选中cell回调
@property (nonatomic, strong) SectionNumBack sectionNumBack;
@property (nonatomic, strong) HeaderBack headerBack;
@property (nonatomic, strong) FooterBack footerBack;
@property (nonatomic, strong) HeaderSizeBack headerSizeBack;
@property (nonatomic, strong) FooterSizeBack footerSizeBack;


@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UICollectionView* collection;
@property (nonatomic, strong) PackageConfig* packageConfig;
@end

@implementation TableViewAndCollectionPackage


#pragma mark - puclic方法
+ (instancetype)instanceWithScrollView:(UIScrollView *)scrollView delegate:(id<TableViewAndCollectionPackageDelegate>)delegate cellBack:(CellBack)cellback sectionNumBack:(SectionNumBack)sectionNumBack cellSizeBack:(CellSizeBack)cellSizeBack cellNumBack:(CellNumBack)cellNumBack selectedBack:(SelectedBack)selectedBack{
    TableViewAndCollectionPackage *package = [[TableViewAndCollectionPackage alloc] init];
    package.delegate = delegate;
    package.cellBack = cellback;
    package.cellSizeBack = cellSizeBack;
    package.cellNumBack = cellNumBack;
    package.sectionNumBack = sectionNumBack;
    package.selectedBack = selectedBack;
    package.scrollView = scrollView;
    if (package.tableView) {
        package.tableView.delegate = package;
        package.tableView.dataSource = package;
    }
    if (package.collection) {
        package.collection.delegate = package;
        package.collection.dataSource = package;
    }
    return package;
}

+ (instancetype)instantWithScrollView:(UIScrollView *)scrollView delegate:(id<TableViewAndCollectionPackageDelegate>)delegate{
    TableViewAndCollectionPackage *package = [[TableViewAndCollectionPackage alloc] init];
    package.delegate = delegate;
    package.scrollView = scrollView;
    return package;
}

- (void)addHeaderBack:(HeaderBack)headerBack headerSizeBack:(HeaderSizeBack)headerSizeBack orFooterBack:(FooterBack)footerBack footerSizeBack:(FooterSizeBack)footerSizeBack{
    self.headerBack = headerBack;
    self.headerSizeBack = headerSizeBack;
    self.footerBack = footerBack;
    self.footerSizeBack = footerSizeBack;
}

#pragma mark - 私有方法
- (PackageConfig *)packageConfig{
    if (!_packageConfig) {
        _packageConfig = [[PackageConfig alloc] init];
    }
    return _packageConfig;
}

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.tableView = (UITableView*)scrollView;
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.collection = (UICollectionView*)scrollView;
    }
    __WEAKSELF;
    if (_delegate && [_delegate respondsToSelector:@selector(upRefesh)]) {
        scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.delegate upRefesh];
        }];
        _refresh_footer = scrollView.mj_footer;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(downRefresh)]) {
        scrollView.mj_header = [GifRefreshHeader instanceWithTarget:_delegate selector:@selector(downRefresh)];
        _refresh_header = scrollView.mj_header;
    }
}

- (void)reloadData{
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.collection) {
        [self.collection reloadData];
    }
}

- (void)beginRefresh{
    [self.scrollView.mj_header beginRefreshing];
}

- (void)setNoMoreData:(BOOL)noMore{
    [self reloadData];
    if (noMore) {
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.scrollView.mj_footer resetNoMoreData];
    }
}

- (void)endRefresh{
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __WEAKSELF;
    self.cellBack(indexPath, weakSelf.packageConfig);
    UITableViewCell *cell = (UITableViewCell*)self.packageConfig.cell;
    if (self.packageConfig.notSelectionStyle) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.cellNumBack) {
        __WEAKSELF;
        self.cellNumBack(section, weakSelf.packageConfig);
    }
    return self.packageConfig.cellNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellSizeBack) {
        __WEAKSELF;
        self.cellSizeBack(indexPath, weakSelf.packageConfig);
    }
    return self.packageConfig.rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.packageConfig.sectionNum = 1;
    if (self.sectionNumBack) {
        __WEAKSELF;
        self.sectionNumBack(weakSelf.packageConfig);
    }
    return self.packageConfig.sectionNum;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedBack) {
        self.selectedBack(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.packageConfig.estimateHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.headerBack) {
        __WEAKSELF;
        self.headerBack(section, weakSelf.packageConfig);
    }
    return self.packageConfig.header? self.packageConfig.header:[UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.headerSizeBack) {
        __WEAKSELF;
        self.headerSizeBack(section, weakSelf.packageConfig);
    }
    return self.packageConfig.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.footerBack) {
        __WEAKSELF;
        self.footerBack(section, weakSelf.packageConfig);
    }
    UIView *view = self.packageConfig.footer;
    if (!view) {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.footerSizeBack) {
        __WEAKSELF;
        self.footerSizeBack(section, weakSelf.packageConfig);
    }
    return self.packageConfig.footerHeight;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __WEAKSELF;
    self.cellBack(indexPath, weakSelf.packageConfig);
    UICollectionViewCell *cell = (UICollectionViewCell*)self.packageConfig.cell;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    self.packageConfig.itemSize = CGSizeZero;
    if (self.cellSizeBack) {
        __WEAKSELF;
        self.cellSizeBack(indexPath, weakSelf.packageConfig);
    }
    return self.packageConfig.itemSize;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.sectionNumBack) {
        __WEAKSELF;
        self.sectionNumBack(weakSelf.packageConfig);
    }
    NSInteger count = 1;
    if (self.packageConfig.sectionNum>1) {
        count = self.packageConfig.sectionNum;
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.cellNumBack) {
        __WEAKSELF;
        self.cellNumBack(section, weakSelf.packageConfig);
    }
    return self.packageConfig.cellNum;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedBack) {
        self.selectedBack(indexPath);
    }
}


@end


