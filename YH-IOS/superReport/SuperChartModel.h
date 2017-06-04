//
//  SuperChartModel.h
//  SwiftCharts
//
//  Created by CJG on 17/4/19.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChartConfig;
@class TableDataModel;
@class SuperChartModel;
@class TableDataItemModel;

@interface SuperChartModel : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) ChartConfig* config;
@property (nonatomic, strong) TableDataModel* table;

+ (instancetype)testModel;

- (NSArray<NSString*>*)showColors;

@end

@interface ChartConfig : NSObject
@property (nonatomic, strong) NSArray<TableDataModel*>* filter;
@property (nonatomic, strong) NSArray<TableDataModel*>* area_filter;
@property (nonatomic, strong) NSArray<TableDataModel*>* sale_filter;
@property (nonatomic, strong) NSArray<NSString*>* color;
@end

@interface TableDataModel : NSObject
@property (nonatomic, strong) NSArray<TableDataItemModel*>* head;
@property (nonatomic, strong) NSArray<TableDataItemModel*>* main_data;
@property (nonatomic, strong) NSArray<TableDataItemModel*>* items;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, strong) NSString* filter_name;

@property (nonatomic, strong) NSMutableArray* selectSet; // 头部选中列的集合

@property (nonatomic, strong) NSMutableArray* dataSet; // 地区选中行的集合

@property (nonatomic, strong) TableDataItemModel* keyHead;

- (NSArray<TableDataItemModel*>*)showData;
- (NSArray<TableDataItemModel*>*)showhead;

@end

@interface TableDataItemModel : NSObject
@property (nonatomic, strong) NSString* district;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray<TableDataItemModel*>* data; // 原始数据
@property (nonatomic, strong) NSMutableArray<TableDataItemModel*>* showData; // 展示数据
@property (nonatomic, strong) NSArray<NSString*>* color;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSString* value;
@property (nonatomic, assign) BOOL isKey; // 是否关键列
@property (nonatomic, assign) SortType sortType;
@property (nonatomic, strong) TableDataItemModel* superTableDataItem;
@end
