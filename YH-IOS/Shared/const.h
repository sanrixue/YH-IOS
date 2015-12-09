//
//  const.h
//  hChart
//
//  Created by lijunjie on 15/11/3.
//  Copyright © 2015年 us.solife. All rights reserved.
//

#ifndef const_h
#define const_h

#define YH_COLOR          @"#53a93f"

#define BASE_URL          @"http://121.40.35.29:4567"
#define BASE_URL2          @"http://localhost:4567"

#define LOGIN_PATH        @"/mobile/login"
#define API_USER_PATH     @"/api/v1/%@/%@/%@/authentication"
#define API_DATA_PATH     @"/api/v1/group/%@/report/%@/attachment"

#define KPI_PATH          @"/mobile/%@/kpi"
#define MESSAGE_PATH      @"/mobile/%@/message"
#define APPLICATION_PATH  @"/mobile/%@/app"
#define ANALYSE_PATH      @"/mobile/%@/analyse"

#define FONTS_PATH        @"/mobile/assets/fonts.zip"

#define REPORT_DATA_FILENAME @"javascripts_template_data_group_%@_report_%@.js"

#define USER_CONFIG_FILENAME @"user.plist"
#define CONFIG_DIRNAME    @"Configs"
#define HTML_DIRNAME      @"HTML"
#define ASSETS1_DIRNAME   @"Assets"

#define CACHED_HEADER_FILENAME @"cachedHeader.plist"

#define URL_WRITE_LOCAL   @"1"


#define PGY_APP_ID @"7586e8c77ceadd3240c5e243e9d0c391"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

#endif /* const_h */
