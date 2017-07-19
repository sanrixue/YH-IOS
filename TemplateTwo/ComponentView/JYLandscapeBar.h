//
//  JYLandscapeBar.h
//  各种报表
//
//  Created by niko on 17/5/4.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"


@class JYLandscapeBar;
@protocol JYLandscapeBarDelegate <NSObject>

// 其它视图可根据子高高度进行相应的调整
- (void)landscapeBar:(JYLandscapeBar *)bar refreshHeight:(CGFloat)height;

@end

/* 该view高度可以自适应(在绘制完柱状后，根据柱状的多少进行自适应)
 * 需要注意，自适应后通过delegate向外发出通知，其它视图应在收到通知后进行相应调整
 */
@interface JYLandscapeBar : JYBaseComponentView

@property (nonatomic, assign) id <JYLandscapeBarDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *pionts;




@end
