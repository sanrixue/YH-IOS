//
//  JYSortItemView.h
//  JYScrollNavBar
//
//  Created by haha on 15/7/6.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYSortButton;
@interface JYSortItemView : UIView

@property (nonatomic, copy) NSString *selectButtonTitle;
@property (nonatomic, strong) NSMutableArray *itemKeys;
@property (nonatomic, assign) BOOL isScareing;

- (void)itemsScare;
- (void)itemsStopScare;
- (void)layoutItemsAfterDeletItem:(JYSortButton *)item;

@end
