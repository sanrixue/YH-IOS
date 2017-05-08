//
//  JYPortraitBarView.h
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPortraitBarView;

@protocol JYPortraitBarViewDelegate <NSObject>

- (void)portraitBarView:(JYPortraitBarView *)portraitBarView didSelectedAtIndex:(NSInteger)idx data:(id)data;

@end


@interface JYPortraitBarView : UIView

@property (nonatomic, assign) id<JYPortraitBarViewDelegate> delegate;

@end
