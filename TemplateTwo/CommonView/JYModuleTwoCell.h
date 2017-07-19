//
//  JYModuleTwoCell.h
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYModuleTwoBaseView.h"


@class JYModuleTwoCell;
@protocol JYModuleTwoCellDelegate <NSObject>

- (void)moduleTwoCell:(JYModuleTwoCell *)moduleTwoCell didSelectedAtBaseView:(JYModuleTwoBaseView *)baseView Index:(NSInteger)idx data:(id)data;

@end



@interface JYModuleTwoCell : UITableViewCell

@property (nonatomic, strong) JYModuleTwoBaseModel *viewModel;

@property (nonatomic, weak) id<JYModuleTwoCellDelegate>delegate;

- (CGFloat)cellHeightWithModel:(JYModuleTwoBaseModel *)model;


@end

