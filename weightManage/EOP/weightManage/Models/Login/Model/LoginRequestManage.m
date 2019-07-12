//
//  LoginRequestManage.m
//  weightManage
//
//  Created by iss on 2019/6/21.
//  Copyright © 2019 iss. All rights reserved.
//


#import "LoginRequestManage.h"
#import "SSKeychain.h"

NSString *const LoginUrl = @"/api/web/login/login-name";
NSString *const RegistUrl = @"/api/web/register/login-name";
NSString *const GetUserInfo = @"/api/web/user/info";
NSString *const LogoutUrl = @"/api/web/login/out";

@implementation LoginRequestManage

+(void)requestToLoginWithAccount:(NSString *)account withPassword:(NSString *)password withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock
{
    NSString *url = [[MFSession shareMFSession].ApiHost stringByAppendingString:LoginUrl];
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:account forKey:@"loignName"];
    [dicParam setObject:password forKey:@"password"];
    [RequestManage requestWithType:POST isShowHud:YES withUrl:url param:dicParam success:^(NSDictionary*  _Nonnull obj)
    {
        [[NSUserDefaults standardUserDefaults]setObject:account forKey: UserDefault_Account];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary *resultDic = obj[@"result"];
        [MFSession shareMFSession].token = resultDic[@"token"];
        [MFSession shareMFSession].loginName = account;
        [SSKeychain setPassword:password forService:[MFSession bundleIdentifierKey] account:account];
        
        if (successBlock) {
            successBlock(obj);
        }
    }
    failure:^(NSString * _Nonnull error)
    {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    
}


+(void)requestToRegistWithParam:(NSMutableDictionary *)dic withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock
{
    NSString *url = [[MFSession shareMFSession].ApiHost stringByAppendingString:RegistUrl];
    [RequestManage requestWithType:POST isShowHud:YES withUrl:url param:dic success:^(id  _Nonnull obj)
     {
         if (successBlock) {
             successBlock(obj);
         }
     }
      failure:^(NSString * _Nonnull error)
     {
         if (failedBlock) {
             failedBlock(error);
         }
     }];
}

+(void)requestToGetUserInfoWithParam:(NSMutableDictionary *)dic withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock
{
    NSString *url = [[MFSession shareMFSession].ApiHost stringByAppendingString:GetUserInfo];
    [RequestManage requestWithType:POST isShowHud:NO withUrl:url param:dic success:^(NSDictionary *  _Nonnull obj)
     {
         NSDictionary *resultDic = obj[@"result"];
         [MFSession shareMFSession].loginModel = [LoginModel mj_objectWithKeyValues:resultDic];
         if (successBlock) {
             successBlock(obj);
         }
     }
      failure:^(NSString * _Nonnull error)
     {
         if (failedBlock) {
             failedBlock(error);
         }
     }];
}

+(void)requestToLogoutWithParam:(nullable NSMutableDictionary *)dic withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock
{
    NSString *url = [[MFSession shareMFSession].ApiHost stringByAppendingString:LogoutUrl];
    [RequestManage requestWithType:POST isShowHud:YES withUrl:url param:dic success:^(NSDictionary *  _Nonnull obj)
     {
         if (successBlock) {
             successBlock(obj);
         }
     }
     failure:^(NSString * _Nonnull error)
     {
         if (failedBlock) {
             failedBlock(error);
         }
     }];
}

@end
