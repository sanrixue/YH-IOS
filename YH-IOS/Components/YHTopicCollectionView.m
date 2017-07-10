//
//  YHTopicCollectionView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/16.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHTopicCollectionView.h"
#import "YHTopicCollectionViewCell.h"
#import "YHTopicCollectionHeaderView.h"
#import "YHTopicFooterCollectionReusableView.h"
#import "JHCollectionViewFlowLayout.h"
#import "ListPage.h"
#import "YHToptopicHeaderCollectionReusableView.h"

static NSString *resusedCell = @"reusedCell";
static NSString *resusedHeaderCell = @"reusedHeader";
static NSString *resusedFooterCell = @"reusedFooter";
static NSString *resusedtopHeaderCell = @"reusedtopHeader";

@interface YHTopicCollectionView()<JHCollectionViewDelegateFlowLayout>


@end

@implementation YHTopicCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSInteger,id info))selectIndex
{
    if (self == [super initWithFrame:frame]) {
       /* if (data.count == 0) {
            return self;
        }*/
        
        _block = selectIndex;
       /* UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 23.0f;*/
        JHCollectionViewFlowLayout *jhFlowLayout = [[JHCollectionViewFlowLayout alloc] init];
        jhFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        jhFlowLayout.itemSize = CGSizeMake(64, 63);
        jhFlowLayout.minimumInteritemSpacing = (SCREEN_WIDTH-16-64*4-56)/3;
        jhFlowLayout.minimumLineSpacing = 20;
        jhFlowLayout.sectionInset = UIEdgeInsetsMake(20, 29, 0, 29);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, frame.size.height) collectionViewLayout:jhFlowLayout];
        [self.collectionView registerNib:[UINib nibWithNibName:@"YHTopicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resusedCell];
        [self.collectionView registerNib:[UINib nibWithNibName:@"YHTopicCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resusedHeaderCell];
        [self.collectionView registerNib:[UINib nibWithNibName:@"YHToptopicHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resusedtopHeaderCell];
        [self.collectionView registerNib:[UINib nibWithNibName:@"YHTopicFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:resusedFooterCell];
        [self addSubview:self.collectionView];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f7fef5"];
        self.allData = [data copy];
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)reloadData{
    [self.collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allData[section].listData.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _allData.count;
}

/*
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (SCREEN_WIDTH-16-65*4-56)/3;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(65, 93);
}
*/
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        YHTopicFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:resusedFooterCell forIndexPath:indexPath];
        return footerView;
    }
    else{
        if (indexPath.section == 0) {
            YHToptopicHeaderCollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resusedtopHeaderCell forIndexPath:indexPath];
            headerview.backgroundColor = [UIColor whiteColor];
            headerview.titleLable.text = _allData[indexPath.section].group_name;
            //headerview.rightLabel.text = @"等于什么呢";
            return headerview;
        }
        else{
        YHTopicCollectionHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resusedHeaderCell forIndexPath:indexPath];
        headerview.backgroundColor = [UIColor whiteColor];
        headerview.rightLabel.text = _allData[indexPath.section].group_name;
        //headerview.rightLabel.text = @"等于什么呢";
        return headerview;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resusedCell forIndexPath:indexPath];
   // UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_bg_ab"]];
   // cell.backgroundView = bgImageView;
    ListItem *item = _allData[indexPath.section].listData[indexPath.row];
    //[cell.topImage sd_setImageWithURL:[NSURL URLWithString:item.icon_link]];
    NSString *imagestring =item.icon_link;
    imagestring =[imagestring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *imageurl =[NSURL URLWithString:imagestring];
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:cell.frame];
    bgImageView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = bgImageView;
    cell.topImage.contentMode = UIImageRenderingModeAlwaysOriginal;
    cell.titleLabel.text = item.listName;
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [cell.topImage sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"icon-default"]];
    //cell.backgroundColor = [UIColor whiteColor];
    //cell.titleLabel.text = @"好吧很多人";
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH-16, 34);
}


- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section
{
    return [UIColor whiteColor];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH-16, 10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets inset = UIEdgeInsetsMake(2, 28, 10, 28);
    return inset;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ListItem *menu =_allData[indexPath.section].listData[indexPath.row];
    void (^select)(NSInteger left,id info) = self.block;
    select(indexPath.row,menu);
}


@end
