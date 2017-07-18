//
//  Constraint.m
//  YH-IOS
//
//  Created by lijunjie on 16/9/16.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "Constant.h"

/**
 *  Config#Color
 */
NSString *const kThemeColor       = @"#51aa33"; //31809f
NSString *const kBannerBgColor    = @"#51aa33";
NSString *const kDropViewColor    = @"#434a4d"; //弹出框颜色
NSString *const kDropClickColor   = @"#393f42"; //弹出框点击颜色
NSString *const kBannerTextColor  = @"#ffffff";
NSString *const kIsUrlWrite2Local = @"1";
NSInteger const kTimerInterval    = 30;

/**
 *  API#paths
 */
NSString *const kUserAuthenticateAPIPath = @"%@/api/v1/%@/%@/%@/authentication";
NSString *const kReportDataAPIPath       = @"%@/api/v1/group/%@/template/%@/report/%@/zip";
NSString *const kCommentAPIPath          = @"%@/api/v1/user/%@/id/%@/type/%@";
NSString *const kScreenLockAPIPath       = @"%@/api/v1/user_device/%@/screen_lock";
NSString *const kDeviceStateAPIPath      = @"%@/api/v1/user_device/%@/state";
NSString *const kResetPwdAPIPath         = @"%@/api/v1/update/%@/password";
NSString *const KFindPwdAPIPath          = @"%@/api/v1/ios/reset_password";
NSString *const kActionLogAPIPath        = @"%@/api/v1/ios/logger";
NSString *const kPushDeviceTokenAPIPath  = @"%@/api/v1/device/%@/push_token/%@";
NSString *const kBarCodeScanAPIPath      = @"%@/api/v1/group/%@/role/%@/user/%@/store/%@/barcode_scan?code_info=%@&code_type=%@";
NSString *const kDownloadAssetsAPIPath   = @"%@/api/v1/download/%@.zip";
NSString *const kUploadGravatarAPIPath   =  @"/api/v1/device/%@/upload/user/%@/gravatar";

/**
 *  Mobile#View Path
 */
NSString *const kKPIMobilePath         = @"%@/mobile/%@/group/%@/role/%@/kpi";
NSString *const kMessageMobilePath     = @"%@/mobile/%@/role/%@/group/%@/user/%@/message";
NSString *const kAppMobilePath         = @"%@/mobile/%@/role/%@/app";
NSString *const kAnalyseMobilePath     = @"%@/mobile/%@/role/%@/analyse";
NSString *const kCommentMobilePath     = @"%@/mobile/%@/id/%@/type/%@/comment";
NSString *const kResetPwdMobilePath    = @"%@/mobile/%@/update_user_password";
NSString *const kThursdaySayMobilePath = @"%@/mobile/%@/thursday_say";

/**
 *  Config#Application
 */
NSString *const kConfigDirName = @"Configs";
NSString *const kHTMLDirName   = @"HTML";
NSString *const kAssetsDirName = @"Assets";
NSString *const kSharedDirName = @"Shared";
NSString *const kCachedDirName = @"Cached";
NSString *const kReportDataFileName              = @"group_%@_template_%@_report_%@.js";
NSString *const kUnzipReportDataFileName         = @"group_%@_report_%@_template_%@.js";
NSString *const kUserConfigFileName              = @"user.plist";
NSString *const kPushConfigFileName              = @"push_message_config.plist";
NSString *const kSettingConfigFileName           = @"setting.plist";
NSString *const kGesturePwdConfileFileName       = @"gesture_password.plist";
NSString *const kLocalNotificationConfigFileName = @"local_notification.plist";
NSString *const kCachedHeaderConfigFileName      = @"cached_header.plist";
NSString *const kPgyerVersionConfigFileName      = @"pgyer_version.plist";
NSString *const kGravatarConfigFileName          = @"gravatar.plist";
NSString *const kBetaConfigFileName              = @"beta_v0.plist";
NSString *const kBarCodeResultFileName           = @"barcode_result.json";
NSString *const kCurrentVersionFileName          = @"current_version.txt";
NSString *const kUserAgentFileName               = @"webview_user_agent.txt";

/**
  * Config#User barcode js
  */

NSString *const kBarcodeReturnFileName           = @"barCodeResult";

/**
 *  Config#User Behavior Column name
 */
NSString *const kBehaviorConfigFileName = @"behavior_v0.plist";
NSString *const kDashboardUBCName       = @"dashboard";
NSString *const kMessageUBCName         = @"message";
NSString *const kReportUBCName          = @"message";
NSString *const kTabIndexUBCName        = @"tab_index";

/**
 *  Config#Push Message With Umeng
 */
NSString *const kPushMessageFileName       = @"push_message.plist";
NSString *const kTypePushColumn            = @"type";
NSString *const kTitlePushColumn           = @"title";
NSString *const kLinkPushColumn            = @"url";
NSString *const kObjIDPushColumn           = @"object_id";
NSString *const kObjTypePushColumn         = @"object_type";
NSString *const kStatePushColumn           = @"state";
NSString *const kTypeReportPushColumn      = @"report";
NSString *const kTypeKPIPushColumn         = @"kpi";
NSString *const kTypeAnalysePushColumn     = @"analyse";
NSString *const kTypeAppPushColumn         = @"app";
NSString *const kTypeMessagePushColumn     = @"message";
NSString *const kTypeThursdaySayPushColumn = @"thursday_say";

/**
 *  Assets Folder and FileName
 */
NSString *const kAdFolderName = @"advertisement";
NSString *const kAdFileName   = @"index_ios.html";

/**
 *  StoryBoard | ViewController
 */
NSString *const kMainSBName  = @"Main";
NSString *const kLoginVCName = @"LoginViewController";

/**
 * Text
 */
NSString *const kWarmTitleText       = @"温馨提示";
NSString *const kIAlreadyKnownText   = @"知道了";
NSString *const kAppForbiedUseText   = @"您被禁止在该设备使用本应用";
NSString *const kWarningInitPwdText  = @"初始化密码未修改，安全起见，请在\n【设置】-【个人信息】-【修改密码】页面修改密码";
NSString *const kWarningTitleText    = @"提示";
NSString *const kWarningNoStoreText  = @"您无门店权限";
NSString *const kWarningNoCaremaText = @"没有摄像机权限";
NSString *const kSureBtnText         = @"确定";
NSString *const kWeiXinShareText     = @"图表截图分享";

/**
 *  Dashboard#DropMenu
 */
NSString *const kDropMentScanText     = @"扫一扫";
NSString *const kDropMentVoiceText    = @"语音播报";
NSString *const kDropMentSearchText   = @"搜索";
NSString *const kDropMentUserInfoText = @"个人信息";

/**
 *  Subject#DropMenu
 */
NSString *const kDropSearchText  = @"筛选";
NSString *const kDropShareText   = @"分享";
NSString *const kDropCommentText = @"评论";
NSString *const kDropRefreshText = @"刷新";
NSString *const kDropCopyLinkText = @"拷贝链接";

/**
 * Assets file name
 */
NSString *const kAssetsAssetsName        = @"assets";
NSString *const kLoadingAssetsName       = @"loading";
NSString *const kFontsAssetsName         = @"fonts";
NSString *const kImagesAssetsName        = @"images";
NSString *const kStylesheetsAssetsName   = @"stylesheets";
NSString *const kJavascriptsAssetsName   = @"javascripts";
NSString *const kBarCodeScanAssetsName   = @"BarCodeScan";
NSString *const kAdvertisementAssetsName = @"advertisement";
NSString *const kIconsAssetsName         = @"icons";

NSString *const kLoadingPopupText        = @"加载库";
NSString *const kFontsPopupText          = @"字体库";
NSString *const kImagesPopupText         = @"图库";
NSString *const kStylesheetsPopupText    = @"样式库";
NSString *const kJavascriptsPopupText    = @"解析库";
NSString *const kBarCodeScanPopupText    = @"扫码样式库";
NSString *const kAdvertisementPopupText  = @"广告样式库";

/**
 *  Config#User.plist column names
 */
NSString *const kIsLoginCUName           = @"is_login";
NSString *const kUserIDCUName            = @"user_id";
NSString *const kUserNameCUName          = @"user_name";
NSString *const kUserNumCUName           = @"user_num";
NSString *const kPasswordCUName          = @"user_md5";
NSString *const kUserDeviceIDCUName      = @"user_device_id";
NSString *const kUserLocationName        = @"coordinate";
NSString *const kGesturePasswordCUName   = @"gesture_password";
NSString *const kIsUseGesturePasswordCUName = @"use_gesture_password";
NSString *const kAppVersionCUName        = @"app_version";
NSString *const kGroupIDCUName           = @"group_id";
NSString *const kGroupNameCUName         = @"group_name";
NSString *const kRoleIDCUName            = @"role_id";
NSString *const kRoleNameCUName          = @"role_name";
NSString *const kKPIIDsCUName            = @"kpi_ids";
NSString *const kAppIDSCUName            = @"app_ids";
NSString *const kAnalyseIDsCUName        = @"analyse_ids";
NSString *const kStoreIDsCUName          = @"store_ids";
NSString *const kDeviceUUIDCUName        = @"device_uuid";
NSString *const kDeviceStateCUName       = @"device_state";
NSString *const kGravatarCUName          = @"gravatar";

/**
 *  ActionLog#Column names
 */
NSString *const kActionALCName       = @"action";
NSString *const kObjIDALCName        = @"obj_id";
NSString *const kObjTypeALCName      = @"obj_type";
NSString *const kObjTitleALCName     = @"obj_title";
NSString *const kActionLogALCName    = @"action_log";
NSString *const kUserNameALCName     = @"user_name";
NSString *const kPasswordALCName     = @"user_pass";
NSString *const kUserALCName         = @"user";
NSString *const kScreenshotType      = @"Screenshort-type";

/**
 *  API#Post Comment column names
 */
NSString *const kObjTitleAPCCName    = @"object_title";
NSString *const kUserNameAPCCName    = @"user_name";
NSString *const kContentAPCCName     = @"content";


/**
 *  LocalNotification#TabItems/BannerBtn/ThursdaySay/ModifiedPassword/PgyerUpgrade
 */
NSString *const kAppLNName           = @"app";
NSString *const kTabKPILNName        = @"tab_kpi";
NSString *const kTabAnalyseLNName    = @"tab_analyse";
NSString *const kTabAppLNName        = @"tab_app";
NSString *const kTabMessageLNName    = @"tab_message";
NSString *const kSettingLNName       = @"setting";
NSString *const kSettingThursdaySayLNName = @"setting_thursday_say";
NSString *const kSettingPasswordLNName    = @"setting_password";
NSString *const kSettingPgyerLNName       = @"setting_pgyer";

/**
 *  Config#Pgyer upgrade columns name
 */
NSString *const kDownloadURLCPCName = @"downloadURL";
NSString *const kVersionCodeCPCName = @"versionCode";
NSString *const kVersionNameCPCName = @"versionName";

NSString *const kUpgradeBtnText      = @"升级";
NSString *const kUpgradeWarnText     = @"更新到版本: %@(%@)";
NSString *const kUpgradeTitleText    = @"版本更新";
NSString *const kCancelBtnText       = @"下一次";
NSString *const kUpgradeWarnTestText = @"有测试版本发布，请手工安装。";
NSString *const kNoUpgradeWarnText   = @"未检测到更新";
NSString *const kViewInstantBtnText  = @"立即查看";

/**
 *  Config#BarCodeScan
 */
NSString *kBarCodeScanFolderName = @"BarCodeScan";
NSString *kBarCodeScanFileName   = @"scan_bar_code.html";

