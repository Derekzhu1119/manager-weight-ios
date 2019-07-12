//
//  MFSession.m
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

//host
static const NSString *ApiHost = @"ApiHost";
static const NSString *htmlHost = @"htmlHost";

// ShareSDK
static const NSString *ShareSDK = @"ShareSDK";
static const NSString *ShareSDKKey = @"ShareSDKKey";
static const NSString *ShareWeiKey = @"ShareWeiKey";
static const NSString *ShareWeiSecret = @"ShareWeiSecret";
static const NSString *ShareFacebookKey = @"ShareFacebookKey";
static const NSString *ShareFacebookSecrect = @"ShareFacebookSecrect";


#import "MFSession.h"
#import "LoginViewController.h"
#import "SSKeychain.h"
#import "LoginRequestManage.h"
#import "UIViewController+BaseAction.h"
#import <WebKit/WebKit.h>


static MFSession *_session = nil;


@implementation MFSession

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *configFilePath = MFConfigFilePath;
        NSDictionary *configDic = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
        
        NSDictionary *properyDic = configDic[@"MFProperties"];
        NSDictionary *functionDic = configDic[@"MFFunctions"];
        
        //host
        self.ApiHost = properyDic[ApiHost];
        self.htmlHost = properyDic[htmlHost];
        
        // Share
        if (functionDic[ShareSDK]) {
            self.shareSDKKey = functionDic[ShareSDK][ShareSDKKey];
            self.shareWeiKey = functionDic[ShareSDK][ShareWeiKey];
            self.shareWeiSecret = functionDic[ShareSDK][ShareWeiSecret];
            self.shareFacebookKey = functionDic[ShareSDK][ShareFacebookKey];
            self.shareFacebookSecrect = functionDic[ShareSDK][ShareFacebookSecrect];
        }
        
    }
    return self;
}

+ (MFSession *)shareMFSession {
    
    if (_session == nil) {
        _session = [[MFSession alloc] init];
    }
    
    return _session;
}

//显示隐藏状态栏小菊花
+(void)showStatusBarHud
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+(void)hideStatusBarHud
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//判断值是否为空
+ (BOOL)isEmpty:(NSString *)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return  (nil == value || [value isKindOfClass:[NSNull class]] || ([value length] == 0) || [value isEqualToString:@"(null)"] || [value isEqualToString:@"<null>"] || [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]);
    }
    //非字符串类型直接返回empty
    return YES;
}

+ (NSString *)bundleIdentifierKey {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
}

//退出登录
+(void)loginOut
{
    //清除本地和keychain数据
    [LoginRequestManage requestToLogoutWithParam:nil withSucess:^(id  _Nonnull responseObject)
    {
        NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:UserDefault_Account];
        [SSKeychain deletePasswordForService:[MFSession bundleIdentifierKey] account:account];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserDefault_Account];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [MFSession cleanWKWebViewCache];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
        [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
    }
    withFailed:^(NSString * _Nonnull error)
    {
        [[UIViewController currentViewController]showTextViewWithStatus:@"登出失败"];
    }];
    
}

//清理缓存
+(void)cleanWKWebViewCacheWithoutLocalStorge
{
    NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeOfflineWebApplicationCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeSessionStorage,WKWebsiteDataTypeIndexedDBDatabases,WKWebsiteDataTypeWebSQLDatabases];
    NSSet *websiteDataTypes= [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

+ (void)cleanWKWebViewCache{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

//验证注册的y登录名以字母开头
+ (BOOL)checkRegistUserName:(NSString *)userName
{
    //判断是否以字母开头
    NSString *regex =  @"^[A-Za-z][A-Za-z0-9]*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pre evaluateWithObject:userName];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}

//拼接h5 url
+(NSString *)getHtmlPathWithUrl:(NSString *)url
{
    NSString *urlStr = [[MFSession shareMFSession].htmlHost stringByAppendingString:url];
    if ([MFSession shareMFSession].token) {
        urlStr = [NSString  stringWithFormat:@"%@?token=%@",urlStr,[MFSession shareMFSession].token];
    }
    return urlStr;
}


@end
