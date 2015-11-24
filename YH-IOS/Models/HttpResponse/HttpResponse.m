//
//  HttpResponse.m
//  iSearch
//
//  Created by lijunjie on 15/7/13.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//

#import "HttpResponse.h"
#import "ExtendNSLogFunctionality.h"

@implementation HttpResponse

- (HttpResponse *)init {
    if(self = [super init]) {
        _data     = [[NSMutableDictionary alloc] init];
        _errors   = [[NSMutableArray alloc] init];
        _received = [[NSData alloc] init];
    }
    return self;
}

- (BOOL)isValid {
    return (!self.errors || [self.errors count] == 0);
}

- (NSString *)receivedString {
    return [[NSString alloc]initWithData:self.received encoding:NSUTF8StringEncoding];
}

#pragma mark - rewrite setter
- (void)setReceived:(NSData *)received {
    if(!received) { return; }
    
    NSError *error;
    _received = received;
    _string   = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    _data     = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:&error];
    if(error) {
        [self.errors addObject:(NSString *)psd([error localizedDescription],@"服务器数据转化JSON失败")];
    }
}

- (void)setResponse:(NSHTTPURLResponse *)response {
    @try {
        _URL         = [response.URL absoluteString];
        _statusCode  = [NSNumber numberWithInteger:response.statusCode];
        _contentType = [response.MIMEType lowercaseString];
        _chartset    = [response.textEncodingName lowercaseString];
        _contentLength = [NSNumber numberWithLongLong:response.expectedContentLength];
        NSDictionary *dict = response.allHeaderFields;
        _server     = dict[@"Server"];
        _xPoweredBy = dict[@"X-Powered-By"];
        _date       = dict[@"Date"];
    }
    @catch (NSException *exception) {
        NSLog(@"%@ for %@#%@", @"parse NSHTTPURLResponse failed", exception.name, exception.reason);
    }
    @finally {
        _response = response;
    }

}

#pragma mark - assistant methods
- (void)checkBaseRespose {
    if(![self.contentType isEqualToString:@"application/json"]) {
        NSLog(@"%@ contentType not application/json but %@", self.URL, self.contentType);
    }
    if(![self.chartset isEqualToString:@"utf-8"]) {
        NSLog(@"%@ chartset not utf-8 but %@", self.URL, self.chartset);
    }
}

#pragma mark - suit for Url+Param.h
- (BOOL)isSuccessfullyPostActionLog {
    return (self.data && self.data[@"status"] && (int)self.data[@"status"] >= 0);
}
@end
