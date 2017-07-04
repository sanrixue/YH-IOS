//
//  FileUtils+FileUtils_Assets.m
//  YH-IOS
//
//  Created by lijunjie on 16/2/24.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils+Assets.h"
#import "NSData+MD5.h"
#import <SSZipArchive.h>
#import "TFHpple.h"

@implementation FileUtils (Assets)

/**
 *  静态资源处理
 *
 *  assets.zip, loading.zip解压至shredPath/ (选择文件夹压缩)
 *  loading.zip, loading.zip解压至shredPath/ (选择文件夹压缩)
 *  fonts.zip 解压至 assets/fonts/ (选择文件压缩)
 *  images.zip 解压至 assets/images/ (选择文件压缩)
 *  stylesheets.zip 解压至 assets/stylesheets/ (选择文件压缩)
 *  javascripts.zip 解压至 assets/javascripts/ (选择文件压缩)
 *
 *  @param fileName bundle资源文件名称
 */
+ (void)checkAssets:(NSString *)fileName isInAssets:(BOOL)isInAssets bundlePath:(NSString *)bundlePath {
    NSString *sharedPath = [FileUtils sharedPath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSError *error;
    NSString *zipName = [NSString stringWithFormat:@"%@.zip", fileName];
    NSString *zipPath = [sharedPath stringByAppendingPathComponent:zipName];
    if(![FileUtils checkFileExist:zipPath isDir:NO]) {
        NSString *bundleZipPath = [bundlePath stringByAppendingPathComponent:zipName];
        [[NSFileManager defaultManager] copyItemAtPath:bundleZipPath toPath:zipPath error:&error];
        if(error) { NSLog(@"unZip: %@ failed for - %@", zipPath, [error localizedDescription]); }
    }
    
    NSString *keyName = [NSString stringWithFormat:@"local_%@_md5", fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:zipPath];
    NSString *md5String = fileData.md5;
    
    BOOL isShouldUnZip = YES;
    if([userDict.allKeys containsObject:keyName] && [userDict[keyName] isEqualToString:md5String]) {
        isShouldUnZip = NO;
    }
    if ([fileName isEqualToString:@"dist.zip"]) {
        isShouldUnZip = YES;
    }
    
    if(isShouldUnZip) {
        NSString *assetsPath = sharedPath;
        if(isInAssets) {
            if ([fileName isEqualToString:@"icons"]) {
                assetsPath = [sharedPath stringByAppendingPathComponent:@"assets"];
                assetsPath = [assetsPath stringByAppendingPathComponent:@"images"];
            }
            else{
                assetsPath = [sharedPath stringByAppendingPathComponent:@"assets"];
                assetsPath = [assetsPath stringByAppendingPathComponent:fileName];
            }
        }
        else {
            NSString *assetFolderPath = [assetsPath stringByAppendingPathComponent:fileName];
            if([FileUtils checkFileExist:assetFolderPath isDir:YES]) {
                [FileUtils removeFile:assetFolderPath];
            }
        }
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:assetsPath];
        
        userDict[keyName] = md5String;
        [userDict writeToFile:userConfigPath atomically:YES];
        NSLog(@"unzipfile for %@, %@", fileName, md5String);
    }
}

/**
 *  服务器响应用 HTML 代码加载静态资源调整为应用内相对路径
 *
 *  @param htmlPath <#htmlPath description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)loadLocalAssetsWithPath:(NSString *)htmlPath {
    NSError *error = nil;
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error],
    *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    if(error) {
        NSLog(@"%@ - %@", error.description, htmlPath);
    }
    
    
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSMutableDictionary *uniqDict = [NSMutableDictionary dictionary];
    
    // <script src="../*.js"></script>
    NSArray *elements = [doc searchWithXPathQuery:@"//script"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0 && [dict[@"src"] hasPrefix:@"assets/"]) {
            uniqDict[dict[@"src"]] = [NSString stringWithFormat:@"%@?%@", [dict[@"src"] componentsSeparatedByString:@"?"][0], timestamp];
        }
    }
    // <link href="../*.css">
    elements = [doc searchWithXPathQuery:@"//link"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"href"] && [dict[@"href"] length] > 0 && [dict[@"href"] hasPrefix:@"assets/"]) {
            uniqDict[dict[@"href"]] = [NSString stringWithFormat:@"%@?%@", [dict[@"href"] componentsSeparatedByString:@"?"][0], timestamp];
        }
    }
    // <img src="../*.png">
    elements = [doc searchWithXPathQuery:@"//img"];
    for(TFHppleElement *element in elements) {
        NSDictionary *dict = element.attributes;
        if(dict && dict[@"src"] && [dict[@"src"] length] > 0 && [dict[@"src"] hasPrefix:@"assets/"]) {
            uniqDict[dict[@"src"]] = [NSString stringWithFormat:@"%@?%@", [dict[@"src"] componentsSeparatedByString:@"?"][0], timestamp];
        }
    }
    for(id key in uniqDict) {
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:key withString:uniqDict[key]];
    }
    
    return htmlContent;
}

+ (NSString *)currentUIVersion {
    return @"v2";
//    NSString *settingsConfigPath = [FileUtils dirPath:kConfigDirName FileName:kBetaConfigFileName];
//    NSMutableDictionary *betaDict = [FileUtils readConfigFile:settingsConfigPath];
//    return betaDict[@"old_ui"] && [betaDict[@"old_ui"] boolValue] ? @"v1" : @"v2";
}
@end
