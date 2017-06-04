//
//  PermissionManager.h
//  Chart
//
//  Created by CJG on 16/9/4.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CurPermissionManager [PermissionManager shareInstance]
@interface PermissionManager : NSObject

+ (instancetype)shareInstance;
/**
 *  检测是否有相机权限
 *
 *  @return
 */
- (BOOL)checkCameraAuthorization;
/**
 *  检测是否有定位权限
 *
 *  @return <#return value description#>
 */
- (BOOL)checkLocationPermission;

/**
 *  跳转设置摄像头权限
 */
- (void)goToSettingCameraAuthorization;
/**
 *  跳转到app权限列表界面
 */
- (void)goToAppAuthorizationListView;

/**
 *  验证是否有相机权限，并且showAlert
 *
 *  @param ret <#ret description#>
 */
- (void)verifyCanPhoto:(void(^)(BOOL canPhoto))ret;
/**
 *  验证是否有定位权限，并且showAlert
 *
 *  @param ret <#ret description#>
 */
- (void)verifyCanLocation:(void(^)(BOOL canLocation))ret;

- (void)verifyCanMCP:(void(^)(BOOL canMCP))ret;

@end
