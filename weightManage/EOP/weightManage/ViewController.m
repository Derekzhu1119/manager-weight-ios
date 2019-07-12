//
//  ViewController.m
//  weightManage
//
//  Created by iss on 2019/6/19.
//  Copyright © 2019 iss. All rights reserved.
//

#import "ViewController.h"
#import "TabbarViewController.h"
#import "LoginRequestManage.h"
#import "SSKeychain.h"
#import "LoginViewController.h"
#import "LoginModel.h"
#import "CorvodaNormalViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIImageView *bgImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分析";
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    [self requestToLogin];
}

#pragma mark - 配置UI
-(void)configUI
{
    self.bgImageView.image = [UIImage imageNamed:[self getLaunchImageName]];
//    [MFSession cleanWKWebViewCacheWithoutLocalStorge];  //清除缓存
}

#pragma mark - 数据请求
- (void)requestToLogin
{
    [MFSession showStatusBarHud];
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:UserDefault_Account];
    NSString *password =  [SSKeychain passwordForService:[MFSession bundleIdentifierKey] account:account];

    [LoginRequestManage requestToLoginWithAccount:account withPassword:password withSucess:^(NSDictionary *  _Nonnull responseObject)
     {
         [self requestToGetUserInfo];
     } withFailed:^(NSString * _Nonnull error) {
         [MFSession hideStatusBarHud];
         UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
         [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
     }];
}

//获取用户数据
- (void)requestToGetUserInfo
{
    [LoginRequestManage requestToGetUserInfoWithParam:nil withSucess:^(NSDictionary *  _Nonnull responseObject)
     {
         [MFSession hideStatusBarHud];
         [self goToRootViewController];
         
     } withFailed:^(NSString * _Nonnull error) {
         [MFSession hideStatusBarHud];
         UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
         [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
     }];
}

#pragma mark - 设置根视图
//拿到数据后进行逻辑跳转
- (void)goToRootViewController
{
    LoginTargetInfoModel *targetModel = [MFSession shareMFSession].loginModel.targetInfo;
    if (!targetModel) {
        CorvodaNormalViewController *vc = [[CorvodaNormalViewController alloc]init];
        vc.startPage = [MFSession getHtmlPathWithUrl:baiaoPanUrl];  //表盘
        [[UIApplication sharedApplication].delegate.window setRootViewController:vc];
    }else{
        [[UIApplication sharedApplication].delegate.window setRootViewController:[[TabbarViewController alloc]init]];
    }
}

- (NSString *)getLaunchImageName {
    NSString *launchImageName = nil;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    if ([infoDic objectForKey:@"UILaunchImages"]
        && [[infoDic objectForKey:@"UILaunchImages"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *launchImageDic in [infoDic objectForKey:@"UILaunchImages"]) {
            CGSize size = CGSizeFromString(launchImageDic[@"UILaunchImageSize"]);
            if (UIScreenHeight == size.height) {
                launchImageName = launchImageDic[@"UILaunchImageName"];
                break;
            }
        }
    }
    return launchImageName;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}


@end
