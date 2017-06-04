//
//  SuperChartMainModel.m
//  YH-IOS
//
//  Created by li hao on 17/5/4.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SuperChartMainModel.h"
#import "User.h"
#import "HttpResponse.h"
#import "HttpUtils.h"
#import "APIHelper.h"

//NSString *json = @"{\"name\":\"销售额\",\"config\":{\"color\":[\"#686868\",\"#E21717\",\"#000080\",\"#51aa38\",\"#91c941\",\"#f57658\"],\"filter\":[{\"name\":\"区域\",\"items\":[{\"value\":\"区域A\",\"index\":1},{\"value\":\"区域B\",\"index\":2},{\"value\":\"区域C\",\"index\":3}]},{\"name\":\"销量\",\"items\":[{\"value\":\"过滤条件A\",\"index\":1},{\"value\":\"过滤条件B\",\"index\":1},{\"value\":\"过滤条件C\",\"index\":1}]}]},\"table\":{\"head\":[{\"value\":\"门店\",\"show\":true},{\"value\":\"区域\",\"show\":false},{\"value\":\"销量\",\"show\":true},{\"value\":\"目标销量\",\"show\":true},{\"value\":\"销量 vs 目标\",\"show\":true},{\"value\":\"去年同期\",\"show\":true},{\"value\":\"销量 vs 去年同期\",\"show\":true},{\"value\":\"上月同期\",\"show\":true},{\"value\":\"销量 vs 上月\",\"show\":true},{\"value\":\"毛利\",\"show\":true},{\"value\":\"上月毛利\",\"show\":true}],\"main_data\":[[{\"value\":\"上海\",\"color\":0,\"index\":0},{\"value\":\"区域A\",\"color\":1,\"index\":0},{\"value\":\"70,714\",\"color\":2,\"index\":0},{\"value\":\"58,291\",\"color\":3,\"index\":0},{\"value\":\"-24%\",\"color\":4,\"index\":0},{\"value\":\"37,924\",\"color\":5,\"index\":0},{\"value\":\"9%\",\"color\":5,\"index\":0},{\"value\":\"63,400\",\"color\":4,\"index\":0},{\"value\":\"-19%\",\"color\":3,\"index\":0},{\"value\":\"61,936\",\"color\":2,\"index\":0},{\"value\":\"87,862\",\"color\":1,\"index\":0}]]}}";

@implementation SuperChartMainModel

NSString *json3 = @"{\"name\":\"销售额\",\"config\":{\"color\":[\"#686868\",\"#E21717\",\"#000080\",\"#51aa38\",\"#91c941\",\"#f57658\"],\"filter\":[{\"name\":\"区域\",\"items\":[{\"value\":\"区域A\",\"index\":0},{\"value\":\"区域B\",\"index\":2},{\"value\":\"区域C\",\"index\":1}]},{\"name\":\"销量\",\"items\":[{\"value\":\"过滤条件A\",\"index\":1},{\"value\":\"过滤条件B\",\"index\":1},{\"value\":\"过滤条件C\",\"index\":1}]}]},\"table\":{\"head\":[{\"value\":\"门店\",\"show\":true},{\"value\":\"区域\",\"show\":false},{\"value\":\"销量\",\"show\":true},{\"value\":\"目标销量\",\"show\":true},{\"value\":\"销量 vs 目标\",\"show\":true},{\"value\":\"去年同期\",\"show\":true},{\"value\":\"销量 vs 去年同期\",\"show\":true},{\"value\":\"上月同期\",\"show\":true},{\"value\":\"销量 vs 上月\",\"show\":true},{\"value\":\"毛利\",\"show\":true},{\"value\":\"上月毛利\",\"show\":true}],\"main_data\":[[{\"value\":\"上海\",\"color\":2,\"index\":0},{\"value\":\"区域A\",\"color\":1,\"index\":0},{\"value\":\"89,862\",\"color\":3,\"index\":0},{\"value\":\"58,491\",\"color\":3,\"index\":0},{\"value\":\"-89%\",\"color\":4,\"index\":0},{\"value\":\"37,924\",\"color\":5,\"index\":0},{\"value\":\"9%\",\"color\":5,\"index\":0},{\"value\":\"63,400\",\"color\":4,\"index\":0},{\"value\":\"-19%\",\"color\":3,\"index\":0},{\"value\":\"61,936\",\"color\":2,\"index\":0},{\"value\":\"89,862\",\"color\":1,\"index\":0}],[{\"value\":\"广州\",\"color\":1,\"index\":1},{\"value\":\"区域A\",\"color\":1,\"index\":1},{\"value\":\"70,714\",\"color\":2,\"index\":1},{\"value\":\"58,491\",\"color\":2,\"index\":1},{\"value\":\"-2%\",\"color\":4,\"index\":1},{\"value\":\"37,924\",\"color\":5,\"index\":1},{\"value\":\"9%\",\"color\":5,\"index\":1},{\"value\":\"64,400\",\"color\":4,\"index\":1},{\"value\":\"-19%\",\"color\":3,\"index\":1},{\"value\":\"61,936\",\"color\":2,\"index\":1},{\"value\":\"87,862\",\"color\":1,\"index\":1}],[{\"value\":\"北京\",\"color\":3,\"index\":2},{\"value\":\"区域A\",\"color\":1,\"index\":2},{\"value\":\"78,862\",\"color\":1,\"index\":2},{\"value\":\"58,491\",\"color\":1,\"index\":2},{\"value\":\"-29%\",\"color\":4,\"index\":2},{\"value\":\"37,924\",\"color\":5,\"index\":2},{\"value\":\"9%\",\"color\":5,\"index\":2},{\"value\":\"66,400\",\"color\":4,\"index\":2},{\"value\":\"-19%\",\"color\":3,\"index\":2},{\"value\":\"61,936\",\"color\":2,\"index\":2},{\"value\":\"88,862\",\"color\":1,\"index\":2}]]}}";

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             
             };
}

+ (instancetype)testModel:(NSString *)urlString{
    //return [SuperChartModel mj_objectWithKeyValues:json1];
    NSString *newjson;
    User* user = [[User alloc]init];
    NSString* jsonURL;
    NSString *baseString;
    if ([urlString hasPrefix:@"http"]) {
        baseString = [NSString stringWithFormat:urlString,user.groupID];
        jsonURL = [NSString stringWithFormat:@"%@",baseString];
    }
    else{
        NSArray *urlArray = [urlString componentsSeparatedByString:@"/"];
        baseString = [NSString stringWithFormat:@"/api/v1/group/%@/template/%@/report/%@/jzip",user.groupID,urlArray[6],urlArray[8]];
        jsonURL = [NSString stringWithFormat:@"%@%@",kBaseUrl,baseString];
    }
   // HttpResponse *reponse = [HttpUtils httpGet:jsonURL];
    NSArray *urlArray = [urlString componentsSeparatedByString:@"/"];

    NSString *filePath = [APIHelper getJsonDataWithZip:user.groupID templateID:urlArray[6] reportID:urlArray[8]];
    //newjson = json3;
    newjson = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
   // BOOL isYes = [NSJSONSerialization isValidJSONObject:newjson];
    //return [SuperChartModel mj_objectWithKeyValues:json1];
    return [SuperChartMainModel mj_objectWithKeyValues:newjson];
}

@end

@implementation ChartBaseConfig

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"filter":@"TableDataBaseModel",
             @"color":@"NSString"
             };
}

-(void)mj_keyValuesDidFinishConvertingToObject {
    self.color = @[@"#F2836B",@"#F2836B",@"#F2E1AC",@"#F2E1AC",@"#63A69F",@"#63A69F"];
}

@end

@implementation TableDataBaseItemModel



- (NSMutableArray *)showData{
    if (!_showData) {
        _showData = [NSMutableArray array];
    }
    return _showData;
}

- (void)mj_keyValuesDidFinishConvertingToObject{
    NSMutableArray *data = [NSMutableArray array];
    for (NSString* string in self.data) {
        TableDataBaseItemModel* item = [[TableDataBaseItemModel alloc] init];
        item.value = string;
        [data addObject:item];
    }
    self.data = data;
}

@end


@implementation TableDataBaseModel

- (NSMutableArray *)selectSet{
    if (!_selectSet) {
        _selectSet = [NSMutableArray array];
    }
    return _selectSet;
}

- (NSMutableArray *)selectRowSet{
    if (!_selectRowSet) {
        _selectRowSet = [NSMutableArray array];
    }
    return _selectRowSet;
}

- (NSMutableArray *)dataSet{
    if (!_dataSet) {
        _dataSet = [NSMutableArray array];
    }
    return _dataSet;
}


- (NSArray*)showData {
    NSMutableArray * modelArray= [NSMutableArray array];
    NSMutableArray* array=  [TableDataBaseItemModel mj_objectArrayWithKeyValuesArray:self.main_data];
   // [self mj_objectArrayWithKeyValuesArray];
    for (int i=0; i < array.count; i++) {
        NSMutableArray* insideArray = [[NSMutableArray alloc]initWithArray:array[i]];
        NSMutableArray* modelArraytest = [[NSMutableArray alloc]init];
        [modelArraytest removeAllObjects];
        for (NSNumber* number in _selectSet) {
            TableDataBaseItemModel *item = insideArray[number.integerValue];
            item.lineTag = i;
            [modelArraytest addObject:item];
        }
        [modelArray addObject:modelArraytest];
    }
    NSMutableArray *sortArray = [NSMutableArray array];
    [sortArray removeAllObjects];
    for (NSNumber *number in self.dataSet) {
        [sortArray addObject:modelArray[number.integerValue]];
    }
    
    return sortArray;
}

- (NSArray<TableDataBaseItemModel*>*)showAllItem{
    NSMutableArray* array=  [TableDataBaseItemModel mj_objectArrayWithKeyValuesArray:self.main_data];
    
    NSMutableArray* lineArray =[[NSMutableArray alloc]init];
    [lineArray removeAllObjects];
    for (NSNumber* number in _dataSet) {
        [lineArray addObject:array[number.integerValue]];
    }
    return lineArray;
}

- (NSArray<TableDataBaseItemModel*>*)showAllData{
    NSMutableArray* array=  [TableDataBaseItemModel mj_objectArrayWithKeyValuesArray:self.main_data];
    
    NSMutableArray* lineArray =[[NSMutableArray alloc]init];
    [lineArray removeAllObjects];
    for (NSNumber* number in _dataSet) {
        [lineArray addObject:array[number.integerValue]];
    }
    NSMutableArray* modelArraytest = [[NSMutableArray alloc]init];
    [modelArraytest removeAllObjects];
    // [self mj_objectArrayWithKeyValuesArray];
    for (int i=0; i < lineArray.count; i++) {
        NSMutableArray* insideArray = [[NSMutableArray alloc]initWithArray:array[i]];
        for (NSNumber* number in _selectSet) {
            TableDataBaseItemModel *item = insideArray[number.integerValue];
            [modelArraytest addObject:item];
        }
    }
    return modelArraytest;
}

- (void)mj_keyValuesDidFinishConvertingToObject{ //初始化一些配置
    [self.selectSet removeAllObjects];
    for (int i=0; i<self.head.count; i++) { // 默认全部选择列
        self.head[i].select = YES;
        TableDataBaseItemModel *item = _head[i];
        if (item.show) {
            [self.selectSet addObject:@(i)];
        }
    }
    
    [self.dataSet removeAllObjects];
    for (int i=0; i<self.main_data.count; i++) { // 默认全部行
       /* for (TableDataBaseItemModel* item in self.main_data[i] ) {
            item.select = YES;
        }*/
        [self.dataSet addObject:@(i)];
    }
    
    TableDataBaseItemModel* key = [NSArray getObjectInArray:self.head keyPath:@"isKey" equalValue:@(YES)];
    if (!key&&self.head.count) {
        key = self.head[0];
        key.isKey = YES;
    }
    self.keyHead = key;
}


- (NSArray<TableDataBaseItemModel *> *)showhead{
    NSMutableArray* array = [NSMutableArray array];
    for (NSNumber* number in _selectSet) {
        TableDataBaseItemModel *item = _head[number.integerValue];
        [array addObject:item];
    }
    return array;
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"head":@"TableDataBaseItemModel",
             @"items":@"TableDataBaseItemModel",
             @"main_data":@"TableDataBaseItemModel"
             };
}

@end

