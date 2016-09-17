//
//  Constraint.h
//  YH-IOS
//
//  Created by lijunjie on 16/9/16.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "Constants.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SettingTableCellIndex) {
    IndexGesturePassword = 0
};

typedef NS_ENUM(NSInteger, CommentObjectType) {
    ObjectTypeKpi = 1,
    ObjectTypeAnalyse = 2,
    ObjectTypeApp = 3,
    ObjectTypeReport = 4,
    ObjectTypeMessage = 5
};

typedef NS_ENUM(NSInteger, DeviceState) {
    StateOK = 200,
    StateForbid = 401,
};

typedef NS_ENUM(NSInteger, LoadingType) {
    LoadingLogin = 0,
    LoadingLoad = 1,
    LoadingRefresh = 2,
    LoadingLogining = 3 // deprecate
};


/**
 *  StoryBoard | ViewController
 */
extern NSString *const kMainSBName;
extern NSString *const kLoginVCName;

/**
 * Assets file name
 */
extern NSString *const kLoadingAssetsName;
extern NSString *const kFontsAssetsName;
extern NSString *const kImagesAssetsName;
extern NSString *const kStylesheetsAssetsName;
extern NSString *const kJavascriptsAssetsName;
extern NSString *const kBarCodeScanAssetsName;
extern NSString *const kAdvertisementAssetsName;

extern NSString *const kLoadingPopupText;
extern NSString *const kFontsPopupText;
extern NSString *const kImagesPopupText;
extern NSString *const kStylesheetsPopupText;
extern NSString *const kJavascriptsPopupText;
extern NSString *const kBarCodeScanPopupText;
extern NSString *const kAdvertisementPopupText;

/**
 *  Config#User.plist
 */
extern NSString *const kIsLoginCUName;
extern NSString *const kUserIDCUName;
extern NSString *const kUserNameCUName;
extern NSString *const kUserNumCUName;
extern NSString *const kPasswordCUName;
extern NSString *const kUserDeviceIDCUName;
extern NSString *const kGesturePasswordCUName;
extern NSString *const kIsUseGesturePasswordCUName;
extern NSString *const kAppVersionCUName;
extern NSString *const kGroupIDCUName;
extern NSString *const kGroupNameCUName;
extern NSString *const kRoleIDCUName;
extern NSString *const kRoleNameCUName;
extern NSString *const kKPIIDsCUName;
extern NSString *const kAppIDSCUName;
extern NSString *const kAnalyseIDsCUName;
extern NSString *const kStoreIDsCUName;
extern NSString *const kDeviceUUIDCUName;
extern NSString *const kDeviceStateCUName;
extern NSString *const kGravatarCUName;

/**
 *  ActionLog#Column names
 */
extern NSString *const kActionALCName;
extern NSString *const kObjIDALCName;
extern NSString *const kObjTypeALCName;
extern NSString *const kObjTitleALCName;
extern NSString *const kActionLogALCName;
extern NSString *const kUserNameALCName;
extern NSString *const kPasswordALCName;
extern NSString *const kUserALCName;

/**
 *  API#Post Comment column names
 */
extern NSString *const kObjTitleAPCCName;
extern NSString *const kUserNameAPCCName;
extern NSString *const kContentAPCCName;

/**
 *  LocalNotification#TabItems/BannerBtn/ThursdaySay/ModifiedPassword/PgyerUpgrade
 */
extern NSString *const kAppLNName;
extern NSString *const kTabKPILNName;
extern NSString *const kTabAnalyseLNName;
extern NSString *const kTabAppLNName;
extern NSString *const kTabMessageLNName;
extern NSString *const kSettingLNName;
extern NSString *const kSettingThursdaySayLNName;
extern NSString *const kSettingPasswordLNName;
extern NSString *const kSettingPgyerLNName;

#endif /* Constant_h */
