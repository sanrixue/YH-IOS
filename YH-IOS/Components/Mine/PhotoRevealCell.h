//
//  PhotoRevealCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/11.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoRevealCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

- (void)reloadDataWithImage:(UIImage *)image;
- (void)reloadDataWithString:(NSString *)imagestring;

@end
