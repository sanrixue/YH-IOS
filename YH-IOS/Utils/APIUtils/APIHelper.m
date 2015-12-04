//
//  APIUtils.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "APIHelper.h"
#import "const.h"
#import "HttpUtils.h"
#import "FileUtils.h"
#import "HttpResponse.h"

@implementation APIHelper


+ (void)reportData:(NSString *)groupID reportID:(NSString *)reportID {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, API_REPORT_DATA_PATH];
    
    NSString *userspacePath = [FileUtils userspace];
    NSString *assetsPath = [userspacePath stringByAppendingPathComponent:HTML_DIRNAME];
    HttpResponse *httpResponse = [HttpUtils checkResponseHeader:urlString assetsPath:assetsPath];
    
    NSString *reportDataFileName = [NSString stringWithFormat:REPORT_DATA_FILENAME, groupID, reportID];
    NSString *reportDataFilePath = [assetsPath stringByAppendingPathComponent:reportDataFileName];
    
    
    if([httpResponse.statusCode isEqualToNumber:@(200)] ||
       ([httpResponse.statusCode isEqualToNumber:@(304)] && ![FileUtils checkFileExist:reportDataFilePath isDir:NO])) {
        
        if(httpResponse.string) {
            NSError *error = nil;
            [httpResponse.string writeToFile:reportDataFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if(error) {
                NSLog(@"%@ - %@", error.description, reportDataFilePath);
            }
        }
    }
}
@end
