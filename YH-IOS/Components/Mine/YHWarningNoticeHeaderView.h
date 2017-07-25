//
//  YHWarningNoticeHeaderView.h
//  YH-IOS
//
//  Created by cjg on 2017/7/25.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface YHWarningNoticeHeaderView : UIView

@property (nonatomic, strong) CommonBack clickBlock;

- (void)setWithBaseModels:(NSArray<BaseModel*>*)array;

@end
