//
//  HomeIndexVC.h
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHBaseViewController.h"
#import "HomeIndexModel.h"

@interface HomeIndexVC : YHBaseViewController
@property(nonatomic,strong)NSString* dataLink;

- (void)setWithHomeIndexArray:(NSArray *)array;

- (void)setWithHomeIndexModel:(HomeIndexModel *)model animation:(BOOL)animation;


@end
