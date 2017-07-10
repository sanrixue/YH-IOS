//
//  YHMutileveMenu.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/15.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHMutileveMenu.h"
#import "YHTopImageCollectionViewCell.h"
#import "YHMutileveHeaderView.h"
#import "JHCollectionViewFlowLayout.h"
#import "YHReportLeftTextTableViewCell.h"


#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


static NSString *mutileresuedHeader = @"mutilresuedheaderCell";
static NSString *mutileresuedLeftCell = @"mutilresuedLeftCell";
@interface YHMutileveMenu()

@property (strong, nonatomic) UITableView *leftTable;


@property (assign, nonatomic) BOOL isReturnLastOffset;
@property (strong, nonatomic) UIView *sepView;
@property (strong, nonatomic) UIView *noteSepView;

@end

@implementation YHMutileveMenu


-(id)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSInteger, NSInteger, ListItem*))selectIndex{
    if (self == [self initWithFrame:frame]) {

        _block = selectIndex;
        self.leftSelectBgColor=[UIColor whiteColor];
        self.leftBgColor=[UIColor whiteColor];
        self.leftSeparatorColor=UIColorFromRGB(0xE5E5E5);
        self.leftUnSelectBgColor=UIColorFromRGB(0xF3F4F6);
        
        self.leftUnSelectColor=[UIColor blackColor];
        _selectIndex = 0;
        _allData = data;
        
        // 左边的视图
        self.leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kLeftWidth-2,frame.size.height)];
        self.leftTable.dataSource  = self;
        self.leftTable.delegate = self;
        [self.leftTable registerNib:[UINib nibWithNibName:@"YHReportLeftTextTableViewCell" bundle:nil] forCellReuseIdentifier:mutileresuedLeftCell];
        self.leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.leftTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:self.leftTable];
        self.leftTable.backgroundColor = self.leftBgColor;
        if ([self.leftTable respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTable.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTable respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTable.separatorInset=UIEdgeInsetsZero;
        }
        NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
        if (data.count != 0) {
            [self.leftTable selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
        self.sepView = [[UIView alloc]initWithFrame:CGRectMake(kLeftWidth-2, 0,1, frame.size.height)];
        self.sepView.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [self addSubview:_sepView];
        // 右边的视图
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.minimumLineSpacing = 0.f;
        
        float leftMargin = 0;
        self.rightCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(kLeftWidth +leftMargin, 0, SCREEN_WIDTH-kLeftWidth- leftMargin*2,SCREEN_HEIGHT-49- 64) collectionViewLayout:flowLayout];
        [self.rightCollection registerNib:[UINib nibWithNibName:@"YHTopImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
        [self.rightCollection registerNib:[UINib nibWithNibName:@"YHMutileveHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mutileresuedHeader];
        self.rightCollection.delegate =self;
        self.rightCollection.dataSource = self;
        [self addSubview:self.rightCollection];
        self.rightCollection.alwaysBounceVertical = YES;
        
        self.isReturnLastOffset = YES;
        self.rightCollection.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
        //self.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
        
    }
    
    return self;
}

-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTable.backgroundColor=leftBgColor;
    
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
   // self.rightCollection.backgroundColor=leftSelectBgColor;
    
   // self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTable.separatorColor=leftSeparatorColor;
}

-(void)reloadData {
     [self.leftTable reloadData];
     NSIndexPath *ip=[NSIndexPath indexPathForRow:_selectIndex inSection:0];
        [self.leftTable selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.rightCollection reloadData];
}

// 左侧 tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    YHReportLeftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mutileresuedLeftCell];
    if (!cell) {
        cell = [[YHReportLeftTextTableViewCell alloc]init];
    }
    cell.contentLabel.text =_allData[indexPath.row].category;
    cell.contentLabel.font = [UIFont systemFontOfSize:14];
    cell.bottomSepLine.backgroundColor = [UIColor clearColor];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
    bgView.image = [UIImage imageNamed:@"left_list_bg"];
    cell.selectedBackgroundView = bgView;
    cell.contentLabel.highlightedTextColor = [UIColor colorWithHexString:@"#6aa657"];
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    //cell.selectedBackgroundView.layer.borderWidth = 1;
    //cell.selectedBackgroundView.layer.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
   // cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    //cell.contentLabel.highlightedTextColor = [UIColor colorWithHexString:@"#6aa657"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex = indexPath.row;
  //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#6aa657"];
   /* if (self.noteSepView) {
        [self.noteSepView removeFromSuperview];
    }
    self.noteSepView = [[UIView alloc]initWithFrame:CGRectMake(kLeftWidth-2, cell.frame.origin.y, 2, cell.frame.size.height)];
    self.noteSepView.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    [self addSubview:self.noteSepView];*/
   // cell.backgroundColor = [UIColor whiteColor];
    [self.rightCollection reloadData];
}


// 右侧 collection 代理

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _allData[_selectIndex].listpage.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allData[_selectIndex].listpage[section].listData.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-100-20)/3, 85);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(kScreenWidth-100-20, 30);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 0, 10);
    return inset;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YHMutileveHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:mutileresuedHeader forIndexPath:indexPath];
        headerView.titleLabel.text =_allData[_selectIndex].listpage[indexPath.section].group_name;
        return headerView;
    }
    else{
        return nil;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHTopImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:@"user_ava"];
    NSString *imagestring =_allData[_selectIndex].listpage[indexPath.section].listData[indexPath.row].icon_link;
    imagestring =[imagestring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *imageurl =[NSURL URLWithString:imagestring];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"icon-default"]];
    UIImageView *bgImageView;
    if (_allData[_selectIndex].listpage[indexPath.section].listData.count == 1) {
      bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_ab"]];
    }
    else if (_allData[_selectIndex].listpage[indexPath.section].listData.count ==2){
        if (indexPath.row == 0) {
            bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_a"]];
        }
        else{
            bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_aaa"]];
        }
    }
    else if(_allData[_selectIndex].listpage[indexPath.section].listData.count > 2){
        if ((indexPath.row+1) % 3 == 0) {
            bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_aaa"]];
        }
        else if (((indexPath.row+1) % 3 == 1 && indexPath.row > 3) || indexPath.row+1 == 1){
            bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_a"]];
        }
        else if ((indexPath.row+1) % 3 == 1){
            bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_ab"]];
        }
        else{
            bgImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_aa"]];
        }
    }
    cell.titleLabel.text = _allData[_selectIndex].listpage[indexPath.section].listData[indexPath.row].listName;
    cell.backgroundView = bgImageView;
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ListItem* menu = _allData[_selectIndex].listpage[indexPath.section].listData[indexPath.row];
    void (^select)(NSInteger left,NSInteger right,id info) = self.block;
    select(self.selectIndex,indexPath.row,menu);
}

#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.rightCollection]) {
        
        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.rightCollection]) {
        self.isReturnLastOffset=NO;
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollection]) {
        
        self.isReturnLastOffset=NO;
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.rightCollection] && self.isReturnLastOffset) {
        
        
    }
}


@end
