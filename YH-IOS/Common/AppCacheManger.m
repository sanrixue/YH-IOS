//
//  AppCacheManger.m
//  Chart
//
//  Created by CJG on 16/8/5.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import "AppCacheManger.h"


@implementation AppCacheManger

+ (NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (float)getCacheSize{
    NSString *folderPath = [self getCachesPath];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (NSArray*)protectFileArr{
    return @[@"CurToken.plist",@"CurCustomer.plist"];
}

+ (void)cleanCache:(void (^)())finish{
    NSString *path = [self getCachesPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        NSMutableArray *muChilderFiles = [NSMutableArray arrayWithArray:childerFiles];
        [muChilderFiles removeObjectsInArray:[self protectFileArr]];
        for (NSString *fileName in muChilderFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    if (finish) {
        finish();
    }
}

+ (BOOL)saveImage:(UIImage *)image name:(NSString *)name{
    NSString *path = [self getCachesPath];
    NSString *imagePath = [path stringByAppendingString:name];
   return [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}
@end
