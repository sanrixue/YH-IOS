//
//  FileUtils+FileUtils_Assets.h
//  YH-IOS
//
//  Created by lijunjie on 16/2/24.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils.h"
#import "Constant.h"

@interface FileUtils (Assets)
/**
 *  bundle 资源拷贝至sharedPath
 *
 *  @param fileName bundle资源文件名称
 */
+ (void)checkAssets:(NSString *)fileName isInAssets:(BOOL)isInAssets bundlePath:(NSString *)bundlePath;

/**
 *  服务器响应用 HTML 代码加载静态资源调整为应用内相对路径
 *
 *  @param htmlPath <#htmlPath description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)loadLocalAssetsWithPath:(NSString *)htmlPath;

+ (NSString *)currentUIVersion;
@end
