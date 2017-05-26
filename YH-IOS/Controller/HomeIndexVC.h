//
//  HomeIndexVC.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "HomeIndexModel.h"
#import "UMSocialControllerService.h"

@interface HomeIndexVC : YHBaseViewController<UMSocialUIDelegate>
@property(nonatomic,strong)NSString* dataLink;
@property(nonatomic, strong)NSString* bannerTitle;
@property (assign, nonatomic) CommentObjectType commentObjectType;
@property (strong, nonatomic) NSNumber *objectID;

- (void)setWithHomeIndexArray:(NSArray *)array;

- (void)setWithHomeIndexModel:(HomeIndexModel *)model animation:(BOOL)animation;


@end
