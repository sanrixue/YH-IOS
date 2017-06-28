//
//  SuperChartModel.m
//  SwiftCharts
//
//  Created by CJG on 17/4/19.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "SuperChartModel.h"
#import "User.h"
#import "HttpResponse.h"
#import "HttpUtils.h"

NSString* json = @"{\"name\":\"销售额\",\"config\":{\"color\":[\"#686868\",\"#E21717\",\"#000080\",\"#51aa38\",\"#91c941\",\"#f57658\"],\"filter\":[{\"filter_name\":\"区域\",\"items\":[{\"value\":\"区域A\"},{\"value\":\"区域B\"},{\"value\":\"区域C\"}]}]},\"table\":{\"head\":[{\"value\":\"销量\"},{\"value\":\"目标销量\"},{\"value\":\"销量vs目标\"},{\"value\":\"去年同期\"},{\"value\":\"销量vs去年同期\"},{\"value\":\"上月同期\"},{\"value\":\"销量vs上月\"},{\"value\":\"毛利\"},{\"value\":\"上月毛利\"}],\"main_data\":[{\"name\":\"上海\",\"district\":\"区域A\",\"data\":[\"70,714\",\"58,291\",\"-24%\",\"37,924\",\"9%\",\"63,400\",\"-19%\",\"61,936\",\"87,862\"],\"color\":[0,1,0,1,2,3,5,1,0]},{\"name\":\"新疆\",\"district\":\"区域A\",\"data\":[\"3,470\",\"50,897\",\"-9%\",\"81,886\",\"9%\",\"99,239\",\"36%\",\"9,112\",\"15,592\"],\"color\":[0,0,0,1,2,2,1,0,0]},{\"name\":\"福建\",\"district\":\"区域A\",\"data\":[\"95,282\",\"17,504\",\"87%\",\"62,869\",\"9%\",\"17,478\",\"-74%\",\"86,888\",\"92,161\"],\"color\":[0,0,2,0,2,0,1,0,0]},{\"name\":\"四川\",\"district\":\"区域A\",\"data\":[\"63,912\",\"95,523\",\"37%\",\"67,434\",\"9%\",\"98,461\",\"88%\",\"13,790\",\"60,323\"],\"color\":[0,0,0,1,2,2,1,0,0]},{\"name\":\"浙江\",\"district\":\"区域B\",\"data\":[\"23,546\",\"90,793\",\"42%\",\"62,635\",\"9%\",\"9,698\",\"85%\",\"79,144\",\"94,340\"],\"color\":[0,1,0,1,0,2,0,1,0]},{\"name\":\"湖南\",\"district\":\"区域B\",\"data\":[\"10,872\",\"81,477\",\"-69%\",\"70,329\",\"9%\",\"32,006\",\"-52%\",\"89,888\",\"71,994\"],\"color\":[0,1,0,1,1,2,0,0,1]},{\"name\":\"江苏\",\"district\":\"区域B\",\"data\":[\"13,822\",\"72,773\",\"54%\",\"12,867\",\"9%\",\"55,432\",\"52%\",\"23,193\",\"38,672\"],\"color\":[1,0,0,2,1,2,1,0,0]},{\"name\":\"山东\",\"district\":\"区域B\",\"data\":[\"96,137\",\"72,329\",\"64%\",\"28,866\",\"9%\",\"95,324\",\"-22%\",\"2,721\",\"49,789\"],\"color\":[1,1,0,1,0,2,2,0,0]},{\"name\":\"安徽\",\"district\":\"区域B\",\"data\":[\"10,791\",\"53,170\",\"-86%\",\"49,482\",\"9%\",\"99,748\",\"17%\",\"8,357\",\"63,658\"],\"color\":[1,0,1,1,1,2,1,0,0]},{\"name\":\"重庆\",\"district\":\"区域B\",\"data\":[\"63,032\",\"49,912\",\"12%\",\"16,268\",\"9%\",\"47,391\",\"-40%\",\"63,497\",\"20,606\"],\"color\":[0,1,0,1,1,0,2,1,0]},{\"name\":\"河北\",\"district\":\"区域C\",\"data\":[\"576,827\",\"13,117\",\"-6%\",\"85,271\",\"9%\",\"37,879\",\"77%\",\"60,302\",\"13,506\"],\"color\":[1,0,1,0,2,2,1,0,0]},{\"name\":\"云南\",\"district\":\"区域C\",\"data\":[\"71,103\",\"21,434\",\"27%\",\"46,824\",\"9%\",\"37,187\",\"52%\",\"99,825\",\"49,693\"],\"color\":[1,0,0,1,1,2,2,0,1]}]}}";

NSString *json1 = @"{\"name\":\"销售额\",\"config\":{\"color\":[\"#686868\",\"#E21717\",\"#000080\",\"#51aa38\",\"#91c941\",\"#f57658\"],\"filter\":[{\"name\":\"区域\",\"items\":[{\"value\":\"区域A\",\"index\":1},{\"value\":\"区域B\",\"index\":2},{\"value\":\"区域C\",\"index\":3}]},{\"name\":\"销量\",\"items\":[{\"value\":\"过滤条件A\",\"index\":1},{\"value\":\"过滤条件B\",\"index\":1},{\"value\":\"过滤条件C\",\"index\":1}]}]},\"table\":{\"head\":[{\"value\":\"门店\",\"show\":true},{\"value\":\"区域\",\"show\":false},{\"value\":\"销量\",\"show\":true},{\"value\":\"目标销量\",\"show\":true},{\"value\":\"销量 vs 目标\",\"show\":true},{\"value\":\"去年同期\",\"show\":true},{\"value\":\"销量 vs 去年同期\",\"show\":true},{\"value\":\"上月同期\",\"show\":true},{\"value\":\"销量 vs 上月\",\"show\":true},{\"value\":\"毛利\",\"show\":true},{\"value\":\"上月毛利\",\"show\":true}],\"main_data\":[[{\"value\":\"上海\",\"color\":0,\"index\":0},{\"value\":\"区域A\",\"color\":1,\"index\":0},{\"value\":\"70,714\",\"color\":2,\"index\":0},{\"value\":\"58,291\",\"color\":3,\"index\":0},{\"value\":\"-24%\",\"color\":4,\"index\":0},{\"value\":\"37,924\",\"color\":5,\"index\":0},{\"value\":\"9%\",\"color\":5,\"index\":0},{\"value\":\"63,400\",\"color\":4,\"index\":0},{\"value\":\"-19%\",\"color\":3,\"index\":0},{\"value\":\"61,936\",\"color\":2,\"index\":0},{\"value\":\"87,862\",\"color\":1,\"index\":0}]]}}";

/*NSString* json2 = @"{"name":"销售额","config":{"color":["#686868","#E21717","#000080","#51aa38","#91c941","#f57658"],"filter":[{"filter_name":"区域","items":[{"value":"区域A"},{"value":"区域B"},{"value":"区域C"}]}]},"table":{"head":[{"value":"销量"},{"value":"目标销量"},{"value":"销量vs目标"},{"value":"去年同期"},{"value":"销量vs去年同期"},{"value":"上月同期"},{"value":"销量vs上月"},{"value":"毛利"},{"value":"上月毛利"}],"main_data":[{"name":"上海","district":"区域A","data":["70,714","58,291","-24%","37,924","9%","63,400","-19%","61,936","87,862"],"color":[0,1,0,1,2,3,5,1,0]},{"name":"新疆","district":"区域A","data":["3,470","50,897","-9%","81,886","9%","99,239","36%","9,112","15,592"],"color":[0,0,0,1,2,2,1,0,0]},{"name":"福建","district":"区域A","data":["95,282","17,504","87%","62,869","9%","17,478","-74%","86,888","92,161"],"color":[0,0,2,0,2,0,1,0,0]},{"name":"四川","district":"区域A","data":["63,912","95,523","37%","67,434","9%","98,461","88%","13,790","60,323"],"color":[0,0,0,1,2,2,1,0,0]},{"name":"浙江","district":"区域B","data":["23,546","90,793","42%","62,635","9%","9,698","85%","79,144","94,340"],"color":[0,1,0,1,0,2,0,1,0]},{"name":"湖南","district":"区域B","data":["10,872","81,477","-69%","70,329","9%","32,006","-52%","89,888","71,994"],"color":[0,1,0,1,1,2,0,0,1]},{"name":"江苏","district":"区域B","data":["13,822","72,773","54%","12,867","9%","55,432","52%","23,193","38,672"],"color":[1,0,0,2,1,2,1,0,0]},{"name":"山东","district":"区域B","data":["96,137","72,329","64%","28,866","9%","95,324","-22%","2,721","49,789"],"color":[1,1,0,1,0,2,2,0,0]},{"name":"安徽","district":"区域B","data":["10,791","53,170","-86%","49,482","9%","99,748","17%","8,357","63,658"],"color":[1,0,1,1,1,2,1,0,0]},{"name":"重庆","district":"区域B","data":["63,032","49,912","12%","16,268","9%","47,391","-40%","63,497","20,606"],"color":[0,1,0,1,1,0,2,1,0]},{"name":"河北","district":"区域C","data":["576,827","13,117","-6%","85,271","9%","37,879","77%","60,302","13,506"],"color":[1,0,1,0,2,2,1,0,0]},{"name":"云南","district":"区域C","data":["71,103","21,434","27%","46,824","9%","37,187","52%","99,825","49,693"],"color":[1,0,0,1,1,2,2,0,1]}]}}";*/

@implementation SuperChartModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{

             };
}

+ (instancetype)testModel{
        // 暂时写死json
        NSString *newjson;
        User* user = [[User alloc]init];
        NSString *baseString = [NSString stringWithFormat:@"%@/api/v1/group/%@/template/5/report/9903/json",kBaseUrl,user.groupID];
        NSString *jsonURL = [NSString stringWithFormat:@"%@",baseString];
        HttpResponse *reponse = [HttpUtils httpGet:jsonURL];
        newjson = reponse.string;
        BOOL isYes = [NSJSONSerialization isValidJSONObject:reponse.data];
        if (!newjson || !isYes) {
            newjson = json;
        }
    //return [SuperChartModel mj_objectWithKeyValues:json1];
    return [SuperChartModel mj_objectWithKeyValues:newjson];
}

- (NSArray *)showColors{
    NSMutableArray* array = [NSMutableArray array];
 for (NSNumber* number in self.table.dataSet) {
        
        NSString* item = self.config.color[number.integerValue];
        [array addObject:item];
    }
    return array;
}

@end

#pragma mark - ChartConfig
@implementation ChartConfig
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"filter":@"TableDataModel",
             @"color":@"NSString"
             };
}
@end

#pragma mark - TableDataModel
@implementation TableDataModel
- (NSMutableArray *)selectSet{
    if (!_selectSet) {
        _selectSet = [NSMutableArray array];
    }
    return _selectSet;
}

- (NSMutableArray *)dataSet{
    if (!_dataSet) {
        _dataSet = [NSMutableArray array];
    }
    return _dataSet;
}

- (void)mj_keyValuesDidFinishConvertingToObject{ //初始化一些配置
    [self.selectSet removeAllObjects];
    for (int i=0; i<self.head.count; i++) { // 默认全部选择列
        self.head[i].select = YES;
        [self.selectSet addObject:@(i)];
    }
    [self.dataSet removeAllObjects];
    for (int i=0; i<self.main_data.count; i++) { // 默认全部行
        self.main_data[i].select = YES;
        [self.dataSet addObject:@(i)];
    }
    for (int i=0; i<self.items.count; i++) { // 默认选择全部区域
        self.items[i].select = YES;
    }
    
    TableDataItemModel* key = [NSArray getObjectInArray:self.head keyPath:@"isKey" equalValue:@(YES)];
    if (!key&&self.head.count) {
        key = self.head[0];
        key.isKey = YES;
    }
    self.keyHead = key;
}

- (NSArray<TableDataItemModel *> *)showData{
    NSMutableArray* array = [NSMutableArray array];
    for (NSNumber* number in _dataSet) {
        TableDataItemModel* item = _main_data[number.integerValue];
        [item.showData removeAllObjects];
        for (NSNumber* showNumber in _selectSet) {
            [item.showData addObject:item.data[showNumber.integerValue]];
        }
        [array addObject:item];
    }
    return array;
}

- (NSArray<TableDataItemModel *> *)showhead{
    NSMutableArray* array = [NSMutableArray array];
    for (NSNumber* number in _selectSet) {
        TableDataItemModel* item = _head[number.integerValue];
        [array addObject:item];
    }
    return array;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"head":@"TableDataItemModel",
             @"main_data":@"TableDataItemModel",
             @"items":@"TableDataItemModel"
             };
}
@end

#pragma mark - TableDataItemModel
@implementation TableDataItemModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"data":@"NSString",
             @"color":@"NSString"
             };
}

- (NSMutableArray *)showData{
    if (!_showData) {
        _showData = [NSMutableArray array];
    }
    return _showData;
}

- (void)mj_keyValuesDidFinishConvertingToObject{
    NSMutableArray *data = [NSMutableArray array];
    for (NSString* string in self.data) {
        TableDataItemModel* item = [[TableDataItemModel alloc] init];
        item.value = string;
        [data addObject:item];
    }
    self.data = data;
}



@end


