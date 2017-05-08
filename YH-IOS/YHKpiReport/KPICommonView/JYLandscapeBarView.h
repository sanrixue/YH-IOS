//
//  JYLandscapeBarView.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYLandscapeBarView;

@protocol JYLandscapeBarViewDelegate <NSObject>

- (void)landscapeBarView:(JYLandscapeBarView *)landscapeBarView didSelectedAtIndex:(NSInteger)idx data:(id)data;


@end

@interface JYLandscapeBarView : UIView

@property (nonatomic, assign) id<JYLandscapeBarViewDelegate> delegate;

@end
