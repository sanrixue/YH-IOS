//
//  JYClickableLine.h
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

@class JYClickableLine;
@protocol JYClickableLineDelegate <NSObject>

- (void)clickableLine:(JYClickableLine *)clickableLine didSelected:(NSInteger)index data:(id)data;

@end

/*
 根据lineParms传入的数据来决定显示几条折线，
 */
@interface JYClickableLine : JYBaseComponentView

/*
 存储显示折线的数据，包括折线条数、折线颜色、折线关键点列表，传入字典类型
 @{
 line0:@{color:color, data:data}
 line1:@{color:color, data:data}
 }
*/
@property (nonatomic, strong) NSDictionary <NSString *, NSDictionary *> *lineParms;
@property (nonatomic, assign) id <JYClickableLineDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *points;// 视图中关键点最多的一条折线的数据


// 返回值为NO时说明已尽到了最大值了无法显示，
- (BOOL)showFlagPointAtIndex:(NSInteger)index;

@end
