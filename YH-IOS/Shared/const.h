//
//  const.h
//  hChart
//
//  Created by lijunjie on 15/11/3.
//  Copyright © 2015年 us.solife. All rights reserved.
//

#ifndef const_h
#define const_h

#define YH_COLOR          @"#53a93f" //53,A9,3F; 83, 169, 63

#define BASE_URL2        @"http://121.40.35.29:4567"
#define BASE_URL         @"http://localhost:4567"
#define BASE_URL1         @"http://yonghui.idata.mobi"

#define LOGIN_PATH        @"/mobile/login"
#define API_USER_PATH     @"/api/v1/%@/%@/%@/authentication"
#define API_DATA_PATH     @"/api/v1/group/%@/report/%@/attachment"
#define API_COMMENT_PATH  @"/api/v1/user/%@/id/%@/type/%@"
#define API_SCREEN_LOCK_PATH  @"/api/v1/user_device/%@/screen_lock"
#define API_DEVICE_STATE_PATH  @"/api/v1/user_device/%@/state"

#define KPI_PATH          @"/mobile/role/%@/group/%@/kpi"
#define MESSAGE_PATH      @"/mobile/%@/message"
#define APPLICATION_PATH  @"/mobile/%@/app"
#define ANALYSE_PATH      @"/mobile/%@/analyse"
#define COMMENT_PATH      @"/mobile/id/%@/type/%@/comment"

#define FONTS_PATH        @"/mobile/assets/fonts.zip"

#define REPORT_DATA_FILENAME @"template_data_group_%@_report_%@.js"

#define USER_CONFIG_FILENAME @"user.plist"
#define CONFIG_DIRNAME    @"Configs"
#define SETTINGS_CONFIG_FILENAME    @"Setting.plist"
#define TABINDEX_CONFIG_FILENAME    @"PageTabIndex.plist"
#define GESTURE_PASSWORD_FILENAME   @"GesturePassword.plist"
#define HTML_DIRNAME      @"HTML"
#define ASSETS1_DIRNAME   @"Assets"
#define SHARED_DIRNAME   @"Shared"

#define CACHED_HEADER_FILENAME @"cachedHeader.plist"

#define URL_WRITE_LOCAL   @"1"


#define PGY_APP_ID @"7586e8c77ceadd3240c5e243e9d0c391"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

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

#endif /* const_h */
