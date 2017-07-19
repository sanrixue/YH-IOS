//
//  JYSubSheetView.h
//  各种报表
//
//  Created by niko on 17/5/18.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYSheetModel.h"


@interface JYSubSheetView : UIView

@property (nonatomic, strong) JYSheetModel *sheetModel;

- (void)showSubSheetView;

@end
