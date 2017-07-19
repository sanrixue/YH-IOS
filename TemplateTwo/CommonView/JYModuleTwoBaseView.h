//
//  JYModuleTwoBaseView.h
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYModuleTwoBaseModel.h"

@class JYModuleTwoBaseView;

@protocol JYModuleTwoBaseViewDelegate <NSObject>

@optional
- (void)moduleTwoBaseView:(JYModuleTwoBaseView *)moduleTwoBaseView didSelectedAtIndex:(NSInteger)idx data:(id)data;

@end

@interface JYModuleTwoBaseView : UIView


@property (nonatomic, strong) JYModuleTwoBaseModel *moduleModel;
@property (nonatomic, weak) id <JYModuleTwoBaseViewDelegate> delegate;

- (void)refreshSubViewData;


- (CGFloat)estimateViewHeight:(JYModuleTwoBaseModel *)model;



@end
