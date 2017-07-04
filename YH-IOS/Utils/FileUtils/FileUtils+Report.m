//
//  FileUtils+Report.m
//  YH-IOS
//
//  Created by lijunjie on 16/7/18.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils+Report.h"

@implementation FileUtils (Report)

/**
 *  内部报表是否支持筛选功能
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 是否支持筛选功能
 */
+ (BOOL)reportIsSupportSearch:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSArray *searchItems = [self reportSearchItems:groupID templateID:templateID reportID:reportID];
    return ([searchItems count] > 0);
}

/**
 *  内部报表 JavaScript 文件路径
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 文件路径
 */
+ (NSString *)reportJavaScriptDataPath:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSString *reportDataFileName = [NSString stringWithFormat:kReportDataFileName, groupID, templateID, reportID];
    NSString *javascriptPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"assets/javascripts"];
    return [javascriptPath stringByAppendingPathComponent:reportDataFileName];
}

/**
 *  内部报表具有筛选功能时，选项列表
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 选项列表
 */
+ (NSArray *)reportSearchItems:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSDictionary *searchItems = [NSDictionary new];
    NSString *searchItemsPath = [NSString stringWithFormat:@"%@.search_items", [self reportJavaScriptDataPath:groupID templateID:templateID reportID:reportID]];
    if([FileUtils checkFileExist:searchItemsPath isDir:NO]) {
        searchItems = [NSDictionary dictionaryWithContentsOfFile:searchItemsPath];
    }
    
    return searchItems[@"data"];
}

/**
 *  内部报表具有筛选功能时，用户选择的选项，默认第一个选项
 *
 *  @param groupID    群组ID
 *  @param templateID 模板ID
 *  @param reportID   报表ID
 *
 *  @return 用户选择的选项，默认第一个选项
 */
+ (NSString *)reportSelectedItem:(NSNumber *)groupID templateID:(NSString *)templateID reportID:(NSString *)reportID {
    NSString *selectedItem = NULL;
    NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [self reportJavaScriptDataPath:groupID templateID:templateID reportID:reportID]];
    if([FileUtils checkFileExist:selectedItemPath isDir:NO]) {
        selectedItem = [NSString stringWithContentsOfFile:selectedItemPath encoding:NSUTF8StringEncoding error:nil];
    }
    
    return selectedItem;
}
@end
