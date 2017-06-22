//
//  ListPage.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/16.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListPage;
@class ListItem;

@interface ListPageList : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSArray<ListPage *> *listpage;

@end

@interface ListPage : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSArray<ListItem*> *listData;

@end

@interface ListItem : MTLModel<MTLJSONSerializing>

@property (nonatomic,assign) int itemID;
@property (nonatomic,strong) NSString *listName;
@property (nonatomic,strong) NSString *linkPath;
@property (nonatomic,strong) NSString *icon_link;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,assign) int group_id;
@property (nonatomic,assign) int health_value;
@property (nonatomic,assign) int item_order;
@property (nonatomic,assign) int group_order;
@property (nonatomic,assign) NSString *created_at;

@end
