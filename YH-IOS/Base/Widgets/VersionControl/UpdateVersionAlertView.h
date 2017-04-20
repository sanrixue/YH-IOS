//
//  UpdateVersionAlertView.h
//  Haitao
//
//  Created by Guava on 16/4/5.
//  Copyright © 2016年 YongHui. All rights reserved.
//

#import "CommonPopupView.h"

@interface UpdateVersionAlertView : CommonPopupView

@property (nonatomic, strong) NSString *updateUrl;
@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, strong) NSString *content;

+ (CGFloat)calculateHeightOfViewWithContent:(NSString *)content;

@end
