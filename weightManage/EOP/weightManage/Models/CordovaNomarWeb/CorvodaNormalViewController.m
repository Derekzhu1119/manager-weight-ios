//
//  CorvodaNormalViewController.m
//  weightManage
//
//  Created by iss on 2019/6/21.
//  Copyright © 2019 iss. All rights reserved.
//

#import "CorvodaNormalViewController.h"
#import <WebKit/WebKit.h>

@interface CorvodaNormalViewController ()

@property(nonatomic,strong)WKWebView *wkWebView;


@end

@implementation CorvodaNormalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MFSession showStatusBarHud];
    [LoadingView showOnViewWithBig:self.view withSex:[MFSession shareMFSession].loginModel.baseInfo.sex];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    [self configUI];
    [self addNotification];
}

#pragma mark - 配置UI
- (void)configUI
{
    self.wkWebView = (WKWebView *)self.webView;
    self.wkWebView.scrollView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //token
    if ([MFSession shareMFSession].token) {
        NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('token','%@')",[MFSession shareMFSession].token];
        [self.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    }

}

#pragma mark - 通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webVIewLoadFinish:) name:CDVPageDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webViewLoadStart:) name:CDVPluginResetNotification object:nil];
}

#pragma Mark -  method
-(void)webViewLoadStart:(WKWebView *)webView
{
//    [MBProgressHUD showGifHUD:self.view animated:YES];
//    [LoadingView showOnView:self.view];
}

- (void)webVIewLoadFinish:(WKWebView *)webView
{
    [MFSession hideStatusBarHud];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [MBProgressHUD hidenGifHUD:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LoadingView removeFromView:self.view];
    });
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
