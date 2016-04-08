//
//  constant.h
//  hChart
//
//  Created by lijunjie on 15/11/3.
//  Copyright © 2015年 us.solife. All rights reserved.
//

#ifndef constant_h
#define constant_h

#define YH_COLOR                    @"#53a93f" //53,A9,3F; 83, 169, 63

#define SHNEGYIPLUS_URL             @"http://121.199.38.185:4567"
#define YONGHUIBI_URL               @"http://yonghui.idata.mobi"
#define LOCALHOST_URL               @"http://localhost:4567"

#define LOGIN_PATH                  @"/mobile/login"
#define API_USER_PATH               @"/api/v1/%@/%@/%@/authentication"
#define API_DATA_PATH               @"/api/v1/group/%@/report/%@/attachment"
#define API_COMMENT_PATH            @"/api/v1/user/%@/id/%@/type/%@"
#define API_SCREEN_LOCK_PATH        @"/api/v1/user_device/%@/screen_lock"
#define API_DEVICE_STATE_PATH       @"/api/v1/user_device/%@/state"
#define API_RESET_PASSWORD_PATH     @"/api/v1/update/%@/password"
#define API_ACTION_LOG_PATH         @"/api/v1/ios/logger"
#define API_ASSETS_PATH             @"/api/v1/download/%@.zip"

#define KPI_PATH                    @"/mobile/v2/role/%@/group/%@/kpi"
#define MESSAGE_PATH                @"/mobile/v2/role/%@/group/%@/user/%@/message"
#define APPLICATION_PATH            @"/mobile/v2/role/%@/app"
#define ANALYSE_PATH                @"/mobile/v2/role/%@/analyse"
#define COMMENT_PATH                @"/mobile/v2/id/%@/type/%@/comment"
#define RESET_PASSWORD_PATH         @"/mobile/v2/update_user_password"

#define REPORT_DATA_FILENAME        @"template_data_group_%@_report_%@.js"

#define USER_CONFIG_FILENAME        @"user.plist"
#define CONFIG_DIRNAME              @"Configs"
#define SETTINGS_CONFIG_FILENAME    @"Setting.plist"
#define TABINDEX_CONFIG_FILENAME    @"page_tab_index.plist"
#define GESTURE_PASSWORD_FILENAME   @"gesture_password.plist"
#define HTML_DIRNAME                @"HTML"
#define ASSETS1_DIRNAME             @"Assets"
#define SHARED_DIRNAME              @"Shared"

#define CACHED_HEADER_FILENAME      @"cached_header.plist"
#define USER_AGENT_FILENAME         @"webview_user_agent.txt"
#define CURRENT_VERSION__FILENAME   @"current_version.txt"

#define URL_WRITE_LOCAL             @"1"

#define YH_PGYER_APP_ID             @"7586e8c77ceadd3240c5e243e9d0c391"
#define YH_UMENG_APP_ID             @"56f9ebad67e58eb4990012c8"
#define SHENGYIPLUS_PGYER_APP_ID    @"3445bd5b17c8a671819c1f1445127a1d"
#define SHENGYIPLUS_UMENG_APP_ID    @"56fb3e46e0f55ad04a00084a"
#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

#define BASE_URL YONGHUIBI_URL
#define PGYER_APP_ID YH_PGYER_APP_ID
#define UMENG_APP_ID YH_UMENG_APP_ID

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


#endif /* constant_h */
