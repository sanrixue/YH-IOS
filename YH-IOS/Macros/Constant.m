//
//  Constraint.m
//  YH-IOS
//
//  Created by lijunjie on 16/9/16.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "Constant.h"

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
NSString *const kWarmTitleText      = @"温馨提示";
NSString *const kIAlreadyKnownText  = @"知道了";
NSString *const kAppForbiedUseText  = @"您被禁止在该设备使用本应用";
NSString *const kWarningInitPwdText = @"初始化密码未修改，安全起见，请在\n【设置】-【个人信息】-【修改密码】页面修改密码";
NSString *const kWarningTitleText   = @"提示";
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
 * Assets file name
 */
NSString *const kLoadingAssetsName       = @"loading";
NSString *const kFontsAssetsName         = @"fonts";
NSString *const kImagesAssetsName        = @"images";
NSString *const kStylesheetsAssetsName   = @"stylesheets";
NSString *const kJavascriptsAssetsName   = @"javascripts";
NSString *const kBarCodeScanAssetsName   = @"BarCodeScan";
NSString *const kAdvertisementAssetsName = @"BarCodeScan";

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

/**
 *  API#Post Comment column names
 */
NSString *const kObjTitleAPCCName    = @"object_title";
NSString *const kUserNameAPCCName    = @"user_name";
NSString *const kContentAPCCName     = @"content";

/**
 *  LocalNotification#TabItems/BannerBtn/ThursdaySay/ModifiedPassword/PgyerUpgrade
 */
NSString *const kAppLNName           = @"tab_kpi";
NSString *const kTabKPILNName        = @"tab_kpi";
NSString *const kTabAnalyseLNName    = @"tab_analyse";
NSString *const kTabAppLNName        = @"tab_app";
NSString *const kTabMessageLNName    = @"tab_message";
NSString *const kSettingLNName       = @"setting";
NSString *const kSettingThursdaySayLNName = @"setting_thursday_say";
NSString *const kSettingPasswordLNName = @"setting_password";
NSString *const kSettingPgyerLNName  = @"setting_pgyer";

/**
 *  Config#Pgyer upgrade columns name
 */
NSString *const kDownloadURLCPCName = @"downloadURL";
NSString *const kVersionCodeCPCName = @"versionCode";
NSString *const kVersionNameCPCName = @"versionName";

NSString *const kUpgradeBtnText     = @"升级";
NSString *const kUpgradeWarnText    = @"更新到版本: %@(%@)";
NSString *const kUpgradeTitleText   = @"版本更新";
NSString *const kCancelBtnText      = @"放弃";
NSString *const kUpgradeWarnTestText = @"有测试版本发布，请手工安装。";
NSString *const kNoUpgradeWarnText   = @"未检测到更新";

/**
 *  Config#BarCodeScan
 */
NSString *kBarCodeScanFolderName = @"BarCodeScan";
NSString *kBarCodeScanFileName  = @"scan_bar_code.html";