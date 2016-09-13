//
//  constant.h
//  hChart
//
//  Created by lijunjie on 15/11/3.
//  Copyright © 2015年 us.solife. All rights reserved.
//

#import "PrivateConstants.h"

#ifndef constant_h
#define constant_h

#define kThemeColor                 @"#53a93f" //31809f
#define kBannerBgColor              @"#53a93f"
#define kBannerTextColor            @"#ffffff"

#define API_USER_PATH               @"%@/api/v1/%@/%@/%@/authentication"
#define API_DATA_PATH               @"%@/api/v1/group/%@/template/%@/report/%@/attachment"
#define API_COMMENT_PATH            @"%@/api/v1/user/%@/id/%@/type/%@"
#define API_SCREEN_LOCK_PATH        @"%@/api/v1/user_device/%@/screen_lock"
#define API_DEVICE_STATE_PATH       @"%@/api/v1/user_device/%@/state"
#define API_RESET_PASSWORD_PATH     @"%@/api/v1/update/%@/password"
#define API_ACTION_LOG_PATH         @"%@/api/v1/ios/logger"
#define API_PUSH_DEVICE_TOKEN_PATH  @"%@/api/v1/device/%@/push_token/%@"
#define API_BARCODE_SCAN_PATH       @"%@/api/v1/group/%@/role/%@/user/%@/store/%@/barcode_scan?code_info=%@&code_type=%@"
#define API_ASSETS_PATH             @"%@/api/v1/download/%@.zip"
#define API_UPLOAD_GRAVATAR_PATH    @"/api/v1/device/%@/upload/user/%@/gravatar"

#define KPI_DEPRECATED_PATH         @"%@/mobile/%@/role/%@/group/%@/kpi"
#define KPI_PATH                    @"%@/mobile/%@/group/%@/role/%@/kpi"
#define MESSAGE_PATH                @"%@/mobile/%@/role/%@/group/%@/user/%@/message"
#define APPLICATION_PATH            @"%@/mobile/%@/role/%@/app"
#define ANALYSE_PATH                @"%@/mobile/%@/role/%@/analyse"
#define COMMENT_PATH                @"%@/mobile/%@/id/%@/type/%@/comment"
#define RESET_PASSWORD_PATH         @"%@/mobile/%@/update_user_password"
#define THURSDAY_SAY_PATH           @"%@/mobile/%@/thursday_say"

#define REPORT_DATA_FILENAME_DEPRECATED @"template_data_group_%@_report_%@.js"
#define REPORT_DATA_FILENAME            @"group_%@_template_%@_report_%@.js"

#define USER_CONFIG_FILENAME        @"user.plist"
#define PUSH_CONFIG_FILENAME        @"push_message.plist"
#define CONFIG_DIRNAME              @"Configs"
#define SETTINGS_CONFIG_FILENAME    @"setting.plist"
#define TABINDEX_CONFIG_FILENAME    @"page_tab_index.plist"
#define GESTURE_PASSWORD_FILENAME   @"gesture_password.plist"
#define LOCAL_NOTIFICATION_FILENAME @"local_notification.plist"
#define HTML_DIRNAME                @"HTML"
#define ASSETS1_DIRNAME             @"Assets"
#define SHARED_DIRNAME              @"Shared"
#define CACHED_DIRNAME              @"Cached"

#define CACHED_HEADER_FILENAME      @"cached_header.plist"
#define USER_AGENT_FILENAME         @"webview_user_agent.txt"
#define CURRENT_VERSION__FILENAME   @"current_version.txt"
#define PGYER_VERSION_FILENAME      @"pgyer_version.plist"
#define BETA_CONFIG_FILENAME        @"beta.plist"
#define GRAVATAR_CONFIG_FILENAME    @"gravatar.plist"
#define BARCODE_RESULT_FILENAME     @"barcode_result.json"

#define URL_WRITE_LOCAL             @"1"
// #define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]



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

#define kBarCodeScanResultDefault @"{ \
  \"chart\": {                        \
      \"title\": \"查询中...\",        \
      \"series\": [{                  \
           \"name\": \"查询中\",       \
           \"type\": \"line\",        \
           \"data\": [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] \
      }] \
    }, \
    \"tabs\": [] \
  }";

#endif /* constant_h */
