//
//  JYRootScrollViewCell.h
//  JYRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYRootScrollView;

@interface JYRootScrollViewCell : UIView

@property (nonatomic, copy) NSString *identifier;

+ (instancetype)cellWithRootScrollView:(JYRootScrollView *)rootScrollView;
- (void)setpageViewInCell:(UIView *)pageView;

@end
