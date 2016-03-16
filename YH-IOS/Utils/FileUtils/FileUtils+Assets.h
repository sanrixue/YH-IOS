//
//  FileUtils+FileUtils_Assets.h
//  YH-IOS
//
//  Created by lijunjie on 16/2/24.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "FileUtils.h"
#import "const.h"

@interface FileUtils (Assets)
/**
 *  bundle 资源拷贝至sharedPath
 *
 *  @param fileName bundle资源文件名称
 */
+ (void)checkAssets:(NSString *)fileName isInAssets:(BOOL)isInAssets bundlePath:(NSString *)bundlePath;
@end
