//
//  BasicTool.h
//  CarsDemo
//
//  Created by zoulinlin on 14-4-5.
//
//

#import <Foundation/Foundation.h>


#define SYSTEM_VERSION                              [[UIDevice currentDevice]systemVersion].floatValue

@interface BasicTool : NSObject
+(BOOL)isEmpty:(NSObject*)obj;
+(void)copyFileToApp:(NSString *)name type:(NSString *)typeOfFile;
+(NSString*)getDeviceUUID;
+(NSString*)curSoftVersion;

+(void)showDialog:(NSString*)title message:(NSString*)message;
+(void)showDialog:(NSString*)title message:(NSString*)message waitingTime:(NSTimeInterval)time;
@end
