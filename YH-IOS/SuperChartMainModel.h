//
//  SuperChartMainModel.h
//  YH-IOS
//
//  Created by li hao on 17/5/4.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChartBaseConfig;
@class TableDataBaseModel;
@class TableDataBaseItemModel;
@class SuperChartMainModel;

@interface SuperChartMainModel : NSObject

@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) ChartBaseConfig* config;
@property(nonatomic, strong) TableDataBaseModel* table;

+ (instancetype)testModel:(NSString *)urlString;

@end

@interface ChartBaseConfig : NSObject

@property (nonatomic, strong) NSArray<TableDataBaseModel*>* filter;
@property (nonatomic, strong) NSArray<TableDataBaseModel*>* area_filter;
@property (nonatomic, strong) NSArray<TableDataBaseModel*>* sale_filter;
@property (nonatomic, strong) NSArray<NSString*>* color;

@end

@interface TableDataBaseModel : NSObject

@property(nonatomic, strong) NSMutableArray<TableDataBaseItemModel*>* head;
@property(nonatomic, strong) NSArray*  main_data;
@property(nonatomic, strong) NSArray<TableDataBaseItemModel*>* items;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSString* filter_name;

@property (nonatomic, strong) NSMutableArray* selectSet;//头关键列
@property (nonatomic, strong) NSMutableArray* selectRowSet;//表关键列
@property (nonatomic, strong) NSMutableArray* dataSet; // 地区选中行的集合

@property (nonatomic, strong) TableDataBaseItemModel* keyHead;
@property (nonatomic, strong) NSMutableArray* rowLength;

- (NSArray<TableDataBaseItemModel*>*)showAllItem;
- (NSArray*)showData;
- (NSArray<TableDataBaseItemModel*>*)showhead;
- (NSArray<TableDataBaseItemModel*>*)showAllData;

@end


@interface TableDataBaseItemModel:NSObject

@property (nonatomic, strong) NSString* district;
@property (nonatomic, strong) NSString* value;
@property (nonatomic, strong) NSString* color;
@property (nonatomic, strong) NSNumber* index;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) BOOL isKey;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, assign) int lineTag;
@property (nonatomic, strong) NSArray<TableDataBaseItemModel*>* data; // 原始数据
@property (nonatomic, strong) NSMutableArray<TableDataBaseItemModel*>* showData; // 展示数据

@property (nonatomic, assign) SortType sortType;
@property (nonatomic, strong) TableDataBaseItemModel* superTableDataItem;

@end
