//
//  MFSession.h
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFConfig.h"
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFSession : NSObject

//host
@property(nonatomic,copy)NSString *ApiHost;
@property(nonatomic,copy)NSString *htmlHost;

// Share
@property (nonatomic, copy) NSString *shareSDKKey;
@property (nonatomic, copy) NSString *shareWeiKey;
@property (nonatomic, copy) NSString *shareWeiSecret;
@property (nonatomic, copy) NSString *shareFacebookKey;
@property (nonatomic, copy) NSString *shareFacebookSecrect;

//userInfo
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, strong)LoginModel *loginModel;


+ (MFSession *)shareMFSession; //init

//显示隐藏状态栏小菊花
+(void)showStatusBarHud;
+(void)hideStatusBarHud;

//判断值是否为空
+ (BOOL)isEmpty:(NSString *)value;
//bundlekey
+ (NSString *)bundleIdentifierKey;
//退出登录
+(void)loginOut;
//清理网页缓存
+(void)cleanWKWebViewCacheWithoutLocalStorge;
+ (void)cleanWKWebViewCache;
//验证用户名以字母开头
+ (BOOL)checkRegistUserName:(NSString *)userName;
//拼接h5 url
+(NSString *)getHtmlPathWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
