//
//  JYFallsView.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDashboardModel.h"

@class JYFallsView;

@protocol JYFallsViewDelegate <NSObject>

- (void)fallsView:(JYFallsView *)fallsView refreshHeight:(CGFloat)height;
- (void)fallsView:(JYFallsView *)fallsView didSelectedItemAtIndex:(NSInteger)idx data:(id)data;

@end

@interface JYFallsView : UIView

@property (nonatomic, weak) id <JYFallsViewDelegate> delegate;
@property (nonatomic, copy) NSArray <NSArray<JYDashboardModel *> *> *dataSource;

@end
