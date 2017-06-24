//
//  JYFallsView.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDashboardModel.h"
#import "YHKPIModel.h"

@class JYFallsView;

@protocol JYFallsViewDelegate <NSObject>

- (void)fallsView:(JYFallsView *)fallsView refreshHeight:(CGFloat)height;
- (void)fallsView:(JYFallsView *)fallsView didSelectedItemAtIndex:(NSInteger)idx data:(id)data;

@end

@interface JYFallsView : UIView

@property (nonatomic, strong) NSMutableArray* titleArray;
@property (nonatomic, weak) id <JYFallsViewDelegate> delegate;
@property (nonatomic, copy) NSArray <YHKPIModel *> *dataSource;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end
