//
//  PunchClockViewController.m
//  weightManage
//
//  Created by iss on 2019/6/19.
//  Copyright © 2019 iss. All rights reserved.
//

#import "PunchClockViewController.h"
#import <WebKit/WebKit.h>

@interface PunchClockViewController ()

@property(nonatomic,strong)WKWebView *wkWebView;

@end

@implementation PunchClockViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self callBackWithJS];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [MBProgressHUD showGifHUD:self.view animated:YES];
    [LoadingView showOnViewWithBig:self.view withSex:[MFSession shareMFSession].loginModel.baseInfo.sex];

    //隐藏导航栏
    self.fd_prefersNavigationBarHidden = YES;
    self.wkWebView = (WKWebView *)self.webView;

    [self configUI];
    [self addNotification];
}

#pragma mark - 配置UI
- (void)configUI
{
    self.wkWebView.scrollView.bounces = NO;
    //调js方法
    NSInteger index = self.tabBarController.selectedIndex;
    if (index == 1 && [MFSession shareMFSession].token) {
        NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('token','%@')",[MFSession shareMFSession].token];
        [self.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    }
}

#pragma mark - 通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webViewLoadStart:) name:CDVPluginResetNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webVIewLoadFinish:) name:CDVPageDidLoadNotification object:nil];
}

#pragma Mark -  method
-(void)webViewLoadStart:(WKWebView *)webView
{

}

- (void)webVIewLoadFinish:(WKWebView *)webView
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.wkWebView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
//    [MBProgressHUD hidenGifHUD:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LoadingView removeFromView:self.view];
    });
}

-(void)callBackWithJS
{
    NSInteger index = self.tabBarController.selectedIndex;
    NSString *jsStr = nil;
    switch (index) {
        case 0:
        {
            jsStr = @"window.initTargetData()";
        }
            break;
        case 1:
        {
            jsStr = @"window.eoopWeb.reloadIndex()";
        }
            break;
        case 2:
        {
            jsStr = @"window.initReportData()";
        }
            break;
        default:
            break;
    }
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:nil];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
