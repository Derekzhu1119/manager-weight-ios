#import <Cordova/CDVPlugin.h>

@interface XYPlugin : CDVPlugin

- (void)share:(CDVInvokedUrlCommand *)command;  //分享

- (void)vibrate:(CDVInvokedUrlCommand *)command; //手机振动

- (void)getPreferredLanguage:(CDVInvokedUrlCommand *)command; //获取系统语言

- (void)gototab:(CDVInvokedUrlCommand *)command; // 去tab

- (void)getLoginUserInfo:(CDVInvokedUrlCommand *)command;  //获取当前用户登录信息

- (void)getLoginUserInfoAgain:(CDVInvokedUrlCommand *)command; ////再次获取当前用户登录信息

- (void)openWindow:(CDVInvokedUrlCommand *)command; //打开一个新的web

- (void)closeWindow:(CDVInvokedUrlCommand *)command;  //关闭当前页面

- (void)isHideTab:(CDVInvokedUrlCommand *)command; //显示和隐藏tab

- (void)logout:(CDVInvokedUrlCommand *)command;  //退出登录

- (void)playSound:(CDVInvokedUrlCommand *)command;  //播放音频

- (void)writeHealthDataToPhone:(CDVInvokedUrlCommand *)command; //写入健康数据

@end
