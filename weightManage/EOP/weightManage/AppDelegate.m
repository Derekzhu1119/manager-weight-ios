//
//  AppDelegate.m
//  weightManage
//
//  Created by iss on 2019/6/19.
//  Copyright © 2019 iss. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"
#import "MFSession.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <UMCommon/UMCommon.h>

#import "LoginViewController.h"
#import "GuideView.h"
#import "CorvodaNormalViewController.h"
#import "SSKeychain.h"
#import "ViewController.h"
#import "KNMovieViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self configIQKeyBoardManager];
    [self initShareSdk];
    [self initUmeng];
    
    [self setRootViewController];
    
    return YES;
}



#pragma mark - 设置根视图
-(void)setRootViewController
{
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:UserDefault_Account];
    if (account) {
       NSString *password =  [SSKeychain passwordForService:[MFSession bundleIdentifierKey] account:account];
        if (password) {
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
            [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
        }else{
            [self goToLoginViewController];
        }
    }else{
        [self goToLoginViewController];
    }

}

- (void)goToLoginViewController
{
    NSString *isFirst = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstLoad"];
    if (!isFirst) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"firstLoad"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        KNMovieViewController *KNVC = [[KNMovieViewController alloc]init];
        [[UIApplication sharedApplication].delegate.window setRootViewController:KNVC];
    }else{
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
        [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
    }
}

#pragma mark - 初始化sharesdk
-(void)initShareSdk
{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信
        [platformsRegister setupWeChatWithAppId:[MFSession shareMFSession].shareWeiKey appSecret:[MFSession shareMFSession].shareWeiSecret];
        //Facebook
        [platformsRegister setupFacebookWithAppkey:[MFSession shareMFSession].shareFacebookKey appSecret:[MFSession shareMFSession].shareFacebookSecrect displayName:@"shareSDK"];

    }];
}

#pragma mark - 初始化友盟
-(void)initUmeng
{
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:NO];//设置打开日志
    [UMConfigure initWithAppkey:@"5d12eb153fc19565a8000cd7" channel:@""];
}

#pragma mark - 配置IQKeyboardManage
-(void)configIQKeyBoardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
