//
//  SuperChartVc.h
//  SwiftCharts
//
//  Created by CJG on 17/4/18.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "UMSocialControllerService.h"

@interface SuperChartVc : YHBaseViewController<UMSocialUIDelegate>

@property(nonatomic,strong)NSString* dataLink;
@property(nonatomic, strong)NSString* bannerTitle;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSNumber *objectID;

@end
