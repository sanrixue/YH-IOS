//
//  BHInfiniteScrollViewCell.h
//  BHInfiniteScrollView
//
//  Created by libohao on 16/3/6.
//  Copyright © 2016年 libohao. All rights reserved.
//
#import <UIKit/UIKit.h>

#define BHInfiniteScrollViewCellIdentifier @"BHInfiniteScrollViewCellIdentifier"

@interface BHInfiniteScrollViewCell : UICollectionViewCell

- (void)setupWithUrlString:(NSString*)url placeholderImage:(UIImage*)placeholderImage;
- (void)setupWithImageName:(NSString*)imgName placeholderImage:(UIImage*)placeholderImage;
- (void)setupWithImage:(UIImage*)img placeholderImage:(UIImage*)placeholderImage;
-(void)setUpWithText:(NSString *)text;

@property (nonatomic, assign) UIViewContentMode contentMode;
@property(nonatomic,strong)UILabel * contentLabel;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com