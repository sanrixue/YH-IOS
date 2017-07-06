//
//  TreeTableView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Node;

@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (Node *)node;

@end

@interface TreeTableView : UITableView

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data withDeep:(int )deep;
@property (nonatomic, assign) int allDataDeep;

@end
