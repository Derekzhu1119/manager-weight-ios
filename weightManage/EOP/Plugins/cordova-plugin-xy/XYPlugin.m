#import "XYPlugin.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <WebKit/WKWebView.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIAlertController+alertView.h"
#import "TabbarViewController.h"
#import "CorvodaNormalViewController.h"
#import "UIViewController+BaseAction.h"
#import "HealthKitManager.h"

@interface XYPlugin()
    
@property (nonatomic, strong) NSString *callBackIdStr;


@end

@implementation XYPlugin
    

- (void)share:(CDVInvokedUrlCommand *)command {
    
//    [UIAlertController showUIAlertControllerWithTitle:@"客户端弹窗" withMessage:@"点击了分享" withSureBtnTitle:@"确定" withCancleTitle:nil withCancleBtnClick:nil withSureBtnClick:nil];
    
    
//    (type, url, title, content, image, success, error)
    NSInteger type = [[command.arguments objectAtIndex:0] integerValue];
    NSString *url = [command.arguments objectAtIndex:1];
    NSString *title = [command.arguments objectAtIndex:2];
    NSString *content = [command.arguments objectAtIndex:3];
//    NSString *image = [command.arguments objectAtIndex:4];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"icon"]];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //SSUIPlatformItem *item_1 = [[SSUIPlatformItem alloc] init];
    //item_1.platformName = @"item_1";
    //item_1.iconNormal = [UIImage imageNamed:@"COD13.jpg"];
    //item_1.iconSimple = [UIImage imageNamed:@"D11.jpg"];
    //item_1.platformId = @"123456789";
    //[item_1 addTarget:self action:@selector(test_1:)];
    
    SSDKPlatformType sharetype;
    NSArray *items = nil;
    if (type == 0 ) {   //微信朋友圈
        items = @[@(SSDKPlatformSubTypeWechatTimeline)];
        sharetype = SSDKPlatformSubTypeWechatTimeline;
    }else if (type == 2){  //微信收藏
        items = @[@(SSDKPlatformSubTypeWechatFav)];
        sharetype = SSDKPlatformSubTypeWechatFav;
    }else if(type == 3){  //facebook
        items = @[@(SSDKPlatformTypeFacebook)];
        sharetype = SSDKPlatformTypeFacebook;
    }else {   //微信好友
        items = @[@(SSDKPlatformSubTypeWechatSession)];
        sharetype = SSDKPlatformSubTypeWechatSession;
    }
//    SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
//        config.style = SSUIActionSheetStyleSimple;
//        config.menuBackgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [ShareSDK share:sharetype parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
                
            case SSDKResponseStateSuccess:
            {
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"--%@",error.description);
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                //失败
                break;
            }
            case SSDKResponseStateCancel:
            {
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"share cancel"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
                break;
            default:
                break;
        }

    }];
    
//    [ShareSDK showShareActionSheet:nil
//                       customItems:items
//                       shareParams:shareParams
//                sheetConfiguration:nil
//                    onStateChanged:^(SSDKResponseState state,
//                                     SSDKPlatformType platformType,
//                                     NSDictionary *userData,
//                                     SSDKContentEntity *contentEntity,
//                                     NSError *error,
//                                     BOOL end)
//     {
//
//     }];
    
}


- (void)vibrate:(CDVInvokedUrlCommand *)command //手机振动
{
    //time为毫秒
    __block int time = [[command.arguments objectAtIndex:0]intValue]/1000;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer)
         {
             time--;
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
             if (time <=0) {
                 [timer invalidate];
                 timer = nil;
             }
         }];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


- (void)getPreferredLanguage:(CDVInvokedUrlCommand *)command //获取系统语言
{
    NSString *language = [self getCurrentLanguage];
    CDVPluginResult *pluginResult = nil;
    if (language) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{
                                                                                                                    @"value":language
                                                                                                                    }];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        
    }
    
    if (command.callbackId) {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)gototab:(CDVInvokedUrlCommand *)command // 去tab
{
    NSInteger index = [[command.arguments objectAtIndex:0]integerValue];
    TabbarViewController *tab = [[TabbarViewController alloc]init];
    tab.selectedIndex = index;
    [UIApplication sharedApplication].delegate.window.rootViewController = tab;
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    if (command.callbackId) {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)getLoginUserInfo:(CDVInvokedUrlCommand *)command
{
    MFSession *session = [MFSession shareMFSession];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (session.token) {
        [dic setObject:session.token forKey:@"token"];
    }
    if (session.loginName) {
        [dic setObject:session.loginName forKey:@"loginName"];
    }
    if (session.loginModel.baseInfo.sex) {
        [dic setObject:session.loginModel.baseInfo.sex forKey:@"sex"];
    }
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
    if (command.callbackId) {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)getLoginUserInfoAgain:(CDVInvokedUrlCommand *)command ////再次获取当前用户登录信息
{
    MFSession *session = [MFSession shareMFSession];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (session.token) {
        [dic setObject:session.token forKey:@"token"];
    }
    if (session.loginName) {
        [dic setObject:session.loginName forKey:@"loginName"];
    }
    if (session.loginModel.baseInfo.sex) {
        [dic setObject:session.loginModel.baseInfo.sex forKey:@"sex"];
    }
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
    if (command.callbackId) {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)openWindow:(CDVInvokedUrlCommand *)command //打开一个新的web
{
    NSString *url = [command.arguments objectAtIndex:0];
    CorvodaNormalViewController *webVC = [[CorvodaNormalViewController alloc]init];
    webVC.startPage = url;
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC.navigationController pushViewController:webVC animated:YES];
}

- (void)closeWindow:(CDVInvokedUrlCommand *)command  //关闭当前页面
{
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC.navigationController popViewControllerAnimated:YES];
}

- (void)isHideTab:(CDVInvokedUrlCommand *)command //显示和隐藏tab
{
    BOOL isHiden = [[command.arguments objectAtIndex:0]boolValue];
    UIViewController *currentVC = [UIViewController currentViewController];
    TabbarViewController *tabbarController = (TabbarViewController *)currentVC.tabBarController;
    [UIView animateWithDuration:0.5 animations:^{
        tabbarController.tabBar.hidden = isHiden;
    }];
}

- (void)logout:(CDVInvokedUrlCommand *)command//退出登录
{
    [MFSession loginOut];
}

#pragma mark - private method
//获取当前系统语言
-(NSString *)getCurrentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    if(languages == nil){
        return nil;
    }else{
        if([languages count] == 0){
            return nil;
        }else{
            NSString *currentLanguage = [languages objectAtIndex:0];
            return currentLanguage;
        }
    }
}

- (void)playSound:(CDVInvokedUrlCommand *)command  //播放音频
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"time_picker" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
    AudioServicesPlaySystemSound(soundID);
}

void soundCompleteCallBack(SystemSoundID soundID, void *clientData)
{
    NSLog(@"播放完成");
}


- (void)writeHealthDataToPhone:(CDVInvokedUrlCommand *)command //写入健康数据
{
    //type: 0:总脂肪  1:碳水化合物  2:蛋白质
    NSInteger type = [[command.arguments objectAtIndex:0] integerValue];
    NSString *count = [command.arguments objectAtIndex:1];
    [self.commandDelegate runInBackground:^{
    [[HealthKitManager sharedManager]writeDataWithType:type withCount:count completion:^(BOOL success, NSError * _Nullable error) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:success ? CDVCommandStatus_OK :CDVCommandStatus_ERROR];
        if (command.callbackId) {
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
    }];
}

@end
