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
 *  bundle 资源拷贝至sharedPath
 *
 *  @param fileName bundle资源文件名称
 */
+ (void)checkAssets:(NSString *)fileName {
    NSString *sharedPath = [FileUtils sharedPath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    
    NSString *zipName = [NSString stringWithFormat:@"%@.zip", fileName];
    NSString *zipPath = [sharedPath stringByAppendingPathComponent:zipName];
    NSString *keyName = [NSString stringWithFormat:@"local_%@_md5", fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:zipPath];
    NSString *md5String = fileData.md5;
    
    BOOL isShouldUnZip = YES;
    
    if([FileUtils checkFileExist:userConfigPath isDir:NO]) {
        if([userDict.allKeys containsObject:keyName] && [userDict[keyName] isEqualToString:md5String]) {
            isShouldUnZip = NO;
        }
    }
    
    if(isShouldUnZip) {
        NSString *assetsFolderPath = [sharedPath stringByAppendingPathComponent:fileName];
        if([FileUtils checkFileExist:assetsFolderPath isDir:YES]) {
            [FileUtils removeFile:assetsFolderPath];
        }
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:sharedPath];
        
        userDict[keyName] = md5String;
        [userDict writeToFile:userConfigPath atomically:YES];
        NSLog(@"unzipfile for %@, %@", fileName, md5String);
    }
}
@end
