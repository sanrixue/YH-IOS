//
//  BasicTool.m
//  CarsDemo
//
//  Created by zoulinlin on 14-4-5.
//
//

#import "BasicTool.h"
#import "UIAlertView+Category.h"

@implementation BasicTool


#pragma mark 复制资源文件到doc文件夹下
+(void)copyFileToApp:(NSString *)name type:(NSString *)typeOfFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistName = [NSString stringWithFormat:@"%@.%@",name,typeOfFile];
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:plistName];
    NSString *resourceSampleImagesFolderPath =[[NSBundle mainBundle]
                                               pathForResource:name
                                               ofType:typeOfFile];
    NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceSampleImagesFolderPath];
    [[NSFileManager defaultManager] createFileAtPath:documentLibraryFolderPath
                                            contents:mainBundleFile
                                          attributes:nil];
}


+(NSString*) getDeviceUUID {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        NSString *uuid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"];
        if (uuid == nil) {
            uuid = [[NSUUID UUID] UUIDString];
            [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:@"UUID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return uuid;
    }
    else {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
}


#pragma dialog
+(void)showDialog:(NSString*)title message:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * dialog =[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [dialog show];
    });
}

+(void)showDialog:(NSString*)title message:(NSString*)message waitingTime:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * dialog =[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [dialog show];
        [dialog performSelector:@selector(dismissWithClickedButtonIndex:) withObject:@(0) afterDelay:time];
    });
}


+ (BOOL)isEmpty:(NSObject*)obj {
    return obj ==nil || [obj class] == [NSNull class];
}


+(NSString*)curSoftVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
}

@end
