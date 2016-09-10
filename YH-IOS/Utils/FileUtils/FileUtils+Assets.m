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
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
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
    
    if(isShouldUnZip) {
        NSString *assetsPath = sharedPath;
        if(isInAssets) {
            assetsPath = [sharedPath stringByAppendingPathComponent:@"assets"];
            assetsPath = [assetsPath stringByAppendingPathComponent:fileName];
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
@end
