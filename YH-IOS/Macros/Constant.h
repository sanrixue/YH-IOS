//
//  Constraint.h
//  YH-IOS
//
//  Created by lijunjie on 16/9/16.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "PrivateConstants.h"
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
 *  Config#Color
 */
extern NSString *const kThemeColor;
extern NSString *const kBannerBgColor;
extern NSString *const kBannerTextColor;
extern NSString *const kIsUrlWrite2Local;
extern NSInteger const kTimerInterval;

/**
 *  API#paths
 */
extern NSString *const kUserAuthenticateAPIPath;
extern NSString *const kReportDataAPIPath;
extern NSString *const kCommentAPIPath;
extern NSString *const kScreenLockAPIPath;
extern NSString *const kDeviceStateAPIPath;
extern NSString *const kResetPwdAPIPath;
extern NSString *const kActionLogAPIPath;
extern NSString *const kPushDeviceTokenAPIPath;
extern NSString *const kBarCodeScanAPIPath;
extern NSString *const kDownloadAssetsAPIPath;
extern NSString *const kUploadGravatarAPIPath;
extern NSString *const kUnzipReportDataFileName;

/**
 *  Config#User Behavior Column name
 */
extern NSString *const kBehaviorConfigFileName;
extern NSString *const kDashboardUBCName;
extern NSString *const kMessageUBCName;
extern NSString *const kReportUBCName;
extern NSString *const kTabIndexUBCName;

/**
 * Config#User BarCode Result
 */
extern NSString *const kBarcodeReturnFileName;

/**
 *  Mobile#View Path
 */
extern NSString *const kKPIMobilePath;
extern NSString *const kMessageMobilePath;
extern NSString *const kAppMobilePath;
extern NSString *const kAnalyseMobilePath;
extern NSString *const kCommentMobilePath;
extern NSString *const kResetPwdMobilePath;
extern NSString *const kThursdaySayMobilePath;
extern NSString *const KFindPwdAPIPath;

/**
 *  Config#Push Message
 */
extern NSString *const kTypePushColumn;
extern NSString *const kTitlePushColumn;
extern NSString *const kLinkPushColumn;
extern NSString *const kObjIDPushColumn;
extern NSString *const kObjTypePushColumn;
extern NSString *const kStatePushColumn;
extern NSString *const kTypeReportPushColumn;
extern NSString *const kTypeKPIPushColumn;
extern NSString *const kTypeAnalysePushColumn;
extern NSString *const kTypeAppPushColumn;
extern NSString *const kTypeMessagePushColumn;
extern NSString *const kTypeThursdaySayPushColumn;

/**
 *  Config#Application
 */
extern NSString *const kConfigDirName;
extern NSString *const kHTMLDirName;
extern NSString *const kAssetsDirName;
extern NSString *const kSharedDirName;
extern NSString *const kCachedDirName;
extern NSString *const kReportDataFileName;
extern NSString *const kUserConfigFileName;
extern NSString *const kPushConfigFileName;
extern NSString *const kPushMessageFileName;
extern NSString *const kSettingConfigFileName;
extern NSString *const kGesturePwdConfileFileName;
extern NSString *const kLocalNotificationConfigFileName;
extern NSString *const kCachedHeaderConfigFileName;
extern NSString *const kPgyerVersionConfigFileName;
extern NSString *const kGravatarConfigFileName;
extern NSString *const kBetaConfigFileName;
extern NSString *const kBarCodeResultFileName;
extern NSString *const kCurrentVersionFileName;
extern NSString *const kUserAgentFileName;

/**
 * Text
 */
extern NSString *const kWarmTitleText;
extern NSString *const kIAlreadyKnownText;
extern NSString *const kAppForbiedUseText;
extern NSString *const kWarningInitPwdText;
extern NSString *const kWarningTitleText;
extern NSString *const kWarningNoStoreText;
extern NSString *const kWarningNoCaremaText;
extern NSString *const kSureBtnText;
extern NSString *const kWeiXinShareText;

/**
 *  Dashboard#DropMenu
 */
extern NSString *const kDropMentScanText;
extern NSString *const kDropMentVoiceText;
extern NSString *const kDropMentSearchText;
extern NSString *const kDropMentUserInfoText;

/**
 *  Subject#DropMenu
 */
extern NSString *const kDropSearchText;
extern NSString *const kDropShareText;
extern NSString *const kDropCommentText;
extern NSString *const kDropRefreshText;

/**
 *  Assets Folder and FileName
 */
extern NSString *const kAdFolderName;
extern NSString *const kAdFileName;

/**
 *  StoryBoard | ViewController
 */
extern NSString *const kMainSBName;
extern NSString *const kLoginVCName;

/**
 * Assets file name
 */
extern NSString *const kAssetsAssetsName;
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
extern NSString *const kScreenshotType;

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

/**
 *  Config#Pgyer upgrade columns name
 */
extern NSString *const kDownloadURLCPCName;
extern NSString *const kVersionCodeCPCName;
extern NSString *const kVersionNameCPCName;

extern NSString *const kUpgradeBtnText;
extern NSString *const kUpgradeWarnText;
extern NSString *const kUpgradeTitleText;
extern NSString *const kCancelBtnText;
extern NSString *const kUpgradeWarnTestText;
extern NSString *const kNoUpgradeWarnText;
extern NSString *const kViewInstantBtnText;

/**
 *  Config#BarCodeScan
 */
extern NSString *kBarCodeScanFolderName;
extern NSString *kBarCodeScanFileName;

#endif /* Constant_h */
