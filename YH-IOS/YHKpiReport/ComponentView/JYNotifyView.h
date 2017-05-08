//
//  JYNotifyView.h
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

@class JYNotifyView;

@protocol JYNotifyDelegate <NSObject>

- (void)closeNotifyView:(JYNotifyView *)notify;
- (void)notifyView:(JYNotifyView *)notify didSelected:(NSInteger)idx selectedData:(id)data;

@end

/**
 * 页面顶部滚动通知栏，使用ScrollView，集成时关闭ViewController automaticallyAdjustsScrollViewInsets功能
 */
@interface JYNotifyView : JYBaseComponentView <JYBaseComponentViewProtocal>

@property (nonatomic, weak) id <JYNotifyDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *notifications;

@property (nonatomic, strong) UIColor *notifyColor;
@property (nonatomic, strong) UIColor *closeBtnColor;

@property (nonatomic, assign) BOOL drawable; // 拖拽支持

@end
