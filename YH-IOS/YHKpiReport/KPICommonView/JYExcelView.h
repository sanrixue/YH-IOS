//
//  JYExcelView.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYExcelView;

@protocol JYExcelViewDelegate <NSObject>

@optional
- (void)excelView:(JYExcelView *)landscapeBarView didSelectedAtIndex:(NSInteger)idx data:(id)data;


@end


@interface JYExcelView : UIView

@property (nonatomic, assign) id<JYExcelViewDelegate> delegate;

@end
