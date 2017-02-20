//
//  SlideUtils.m
//  iSearch
//
//  Created by lijunjie on 15/6/22.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import "Version.h"
#import "Constant.h"
#import "FileUtils.h"
#import "DateUtils.h"
#import "ExtendNSLogFunctionality.h"

@implementation Version

- (Version *)init {
    if(self = [super init]) {
        _errors = [NSMutableArray array];
        
        NSDictionary *localVersionInfo =[[NSBundle mainBundle] infoDictionary];
        _current   = localVersionInfo[@"CFBundleShortVersionString"];
        _build     = localVersionInfo[@"CFBundleVersion"];
        _appName   = localVersionInfo[@"CFBundleDisplayName"];
        _lang      = localVersionInfo[@"CFBundleDevelopmentRegion"];
        _suport    = localVersionInfo[@"MinimumOSVersion"];
        _sdkName   = localVersionInfo[@"DTSDKName"];
        _platform  = localVersionInfo[@"DTPlatformName"];
        _bundleID  = localVersionInfo[@"CFBundleIdentifier"];
        _dbVersion = (NSString *)psd(localVersionInfo[@"Database Version"], @"NotSet");
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSDictionary *fattributes = [fm attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
        _fileSystemSize     = [fattributes objectForKey:NSFileSystemSize];
        _fileSystemFreeSize = [fattributes objectForKey:NSFileSystemFreeSize];
    }
    return self;
}

- (BOOL)isUpgrade {
    return self.latest && ![self.latest isEqualToString:self.current];
}

- (NSString *)simpleDescription {
    return [NSString stringWithFormat:@"<#%@ version: %@, machine: %@(%@), sdkName: %@, lang: %@>", self.appName,self.current, [Version machine], [Version machineHuman], self.sdkName,self.lang];
}

+ (NSString *)machine {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)machineInfo {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    NSString *nodename = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    
    return @{@"machine": machine, @"sysname": sysname, @"nodename": nodename, @"release": release, @"version": version};
}

+ (NSString *)machineHuman {
    NSString *device = [self machine];
    NSString *human = device;
    
    if ([device isEqualToString:@"x86_64"])     human = @"Simulator";
    else if ([device isEqualToString:@"i386"])  human = @"Simulator";
    
    else if ([device isEqualToString:@"iPad1,1"]) human = @"iPad";
    else if ([device isEqualToString:@"iPad2,1"]) human = @"iPad 2 (A1395)";
    else if ([device isEqualToString:@"iPad2,2"]) human = @"iPad 2 (A1396)";
    else if ([device isEqualToString:@"iPad2,3"]) human = @"iPad 2 (A1397)";
    else if ([device isEqualToString:@"iPad2,4"]) human = @"iPad 2 (A1395+NewChip)";
    else if ([device isEqualToString:@"iPad2,5"]) human = @"iPad Mini 1G (A1432)";
    else if ([device isEqualToString:@"iPad2,6"]) human = @"iPad Mini 1G (A1454)";
    else if ([device isEqualToString:@"iPad2,7"]) human = @"iPad Mini 1G (A1455)";
    
    else if ([device isEqualToString:@"iPad3,1"]) human = @"iPad 3 (A1416)";
    else if ([device isEqualToString:@"iPad3,2"]) human = @"iPad 3 (A1403)";
    else if ([device isEqualToString:@"iPad3,3"]) human = @"iPad 3 (A1430)";
    else if ([device isEqualToString:@"iPad3,4"]) human = @"iPad 4 (A1458)";
    else if ([device isEqualToString:@"iPad3,5"]) human = @"iPad 4 (A1459)";
    else if ([device isEqualToString:@"iPad3,6"]) human = @"iPad 4 (A1460)";
    
    else if ([device isEqualToString:@"iPad4,1"]) human = @"iPad Air (A1474)";
    else if ([device isEqualToString:@"iPad4,2"]) human = @"iPad Air (A1475)";
    else if ([device isEqualToString:@"iPad4,3"]) human = @"iPad Air (A1476)";
    else if ([device isEqualToString:@"iPad4,4"]) human = @"iPad Mini 2G (A1489)";
    else if ([device isEqualToString:@"iPad4,5"]) human = @"iPad Mini 2G (A1490)";
    else if ([device isEqualToString:@"iPad4,6"]) human = @"iPad Mini 2G (A1491)";
    
    else if ([device isEqualToString:@"iPhone1,1"]) human = @"iPhone 1G";
    else if ([device isEqualToString:@"iPhone1,2"]) human = @"iPhone 3G";
    else if ([device isEqualToString:@"iPhone2,1"]) human = @"iPhone 3GS";
    else if ([device isEqualToString:@"iPhone3,1"]) human = @"iPhone 4";
    else if ([device isEqualToString:@"iPhone3,2"]) human = @"Verizon iPhone 4";
    else if ([device isEqualToString:@"iPhone4,1"]) human = @"iPhone 4S";
    else if ([device isEqualToString:@"iPhone5,2"]) human = @"iPhone 5";
    else if ([device isEqualToString:@"iPhone5,1"]) human =  @"iPhone 5 (A1428)";
    else if ([device isEqualToString:@"iPhone5,2"]) human =  @"iPhone 5 (A1429/A1442)";
    else if ([device isEqualToString:@"iPhone5,3"]) human =  @"iPhone 5c (A1456/A1532)";
    else if ([device isEqualToString:@"iPhone5,4"]) human =  @"iPhone 5c (A1507/A1516/A1526/A1529)";
    else if ([device isEqualToString:@"iPhone6,1"]) human =  @"iPhone 5s (A1453/A1533)";
    else if ([device isEqualToString:@"iPhone6,2"]) human =  @"iPhone 5s (A1457/A1518/A1528/A1530)";
    else if ([device isEqualToString:@"iPhone7,1"]) human =  @"iPhone 6 Plus (A1522/A1524)";
    else if ([device isEqualToString:@"iPhone7,2"]) human =  @"iPhone 6 (A1549/A1586)";
    else if ([device isEqualToString:@"iPhone8,1"]) human = @"iPhone 6s";
    else if ([device isEqualToString:@"iPhone8,2"]) human = @"iPhone 6s Plus";
    else if ([device isEqualToString:@"iPhone8,4"]) human = @"iPhone SE";
    else if ([device isEqualToString:@"iPhone9,1"]) human = @"iPhone 7";
    else if ([device isEqualToString:@"iPhone9,2"]) human = @"iPhone 7Plus";
    
    else if ([device isEqualToString:@"iPod1,1"]) human = @"iPod Touch 1G";
    else if ([device isEqualToString:@"iPod2,1"]) human = @"iPod Touch 2G";
    else if ([device isEqualToString:@"iPod3,1"]) human = @"iPod Touch 3G";
    else if ([device isEqualToString:@"iPod4,1"]) human = @"iPod Touch 4G";
    
    return human;
}

@end
