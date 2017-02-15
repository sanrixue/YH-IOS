//
//  LoginTest.m
//  YH-IOS
//
//  Created by li hao on 17/2/14.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "LoginViewController.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import "HttpUtils.h"

SPEC_BEGIN(LOGINTEST)

describe(@"LoginTest", ^{
    
    context(@"when view Controller created", ^{
        __block LoginViewController *manage = nil;
        beforeAll(^{
            manage = [[LoginViewController alloc]init];
        });
        it(@"when login button click ", ^{
            [manage loginBtnClick];
            [[[manage userNameText] shouldNot] beNil];
            [[[manage userPasswordText] shouldNot]beNil];
            NSString * result = [APIHelper userAuthentication:manage.userNameText.text password:manage.userPasswordText.text];
            if(result){
                HttpResponse *reponse = [[HttpResponse alloc]init];
                [[[reponse statusCode] shouldNot] equal:@201];
            }
        });
    });
});

SPEC_END
