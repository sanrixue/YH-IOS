//
//  JYItemManager.h
//  JYScrollNavBar
//
//  Created by haha on 15/7/16.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYScrollNavBar.h"
#import "JYSortItemView.h"

@interface JYItemManager : NSObject

@property (nonatomic, weak) JYScrollNavBar *scrollNavBar;
@property (nonatomic, weak) JYSortItemView *sortItemView;

+ (id)shareitemManager;

- (void)setItemTitles:(NSMutableArray *)titles;
- (void)removeTitle:(NSString *)title;
- (void)printTitles;
@end
