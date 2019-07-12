//
//  LoginView.m
//  weightManage
//
//  Created by iss on 2019/6/28.
//  Copyright © 2019 iss. All rights reserved.
//

#import "LoginView.h"
#import "LoginRequestManage.h"
#import "MJExtension.h"
#import "CorvodaNormalViewController.h"
#import "UIImage+GIF.h"
#import <UMAnalytics/MobClick.h>
#import "Masonry.h"
#import "UIView+Utils.h"
#import "UIView+Utils.h"
#import "UIViewController+BaseAction.h"
#import <UMAnalytics/MobClick.h>
#import "TabbarViewController.h"

@interface LoginView()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *secrectLoginLab; //密码登录按钮
@property (weak, nonatomic) IBOutlet UITextField *account_tf;
@property (weak, nonatomic) IBOutlet UITextField *secrect_tf;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *secrectView;


@end

@implementation LoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
}


-(void)configUI
{
    self.secrectLoginLab.text = NSLocalizedStrings(@"login_secrectLogin");
    self.account_tf.placeholder = NSLocalizedStrings(@"login_PleaseEnterAccount");
    self.secrect_tf.placeholder = NSLocalizedStrings(@"login_PleaseEnterPassword");
    [self.loginBtn setTitle:NSLocalizedStrings(@"login_loginBtn") forState:UIControlStateNormal];
    [self.registerBtn setTitle:NSLocalizedStrings(@"login_ReigstBtn") forState:UIControlStateNormal];

    //给注册按钮加下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedStrings(@"login_ReigstBtn")];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange];
    [self.registerBtn setAttributedTitle:str forState:UIControlStateNormal];

    
}

#pragma mark - request
- (void)requestToLogin
{
    if ([MFSession isEmpty:_account_tf.text]) {
        [[UIViewController currentViewController] showTextViewWithStatus:NSLocalizedStrings(@"regist_PleaseEnterAccount")];
        return;
    }
    if ([MFSession isEmpty:_secrect_tf.text]) {
        [[UIViewController currentViewController] showTextViewWithStatus:NSLocalizedStrings(@"regist_PleaseEnterPassword")];
        return;
    }
    [LoginRequestManage requestToLoginWithAccount:_account_tf.text withPassword:_secrect_tf.text withSucess:^(NSDictionary *  _Nonnull responseObject)
     {
         [self requestToGetUserInfo];
     } withFailed:^(NSString * _Nonnull error) {
         
     }];
}

//获取用户数据
- (void)requestToGetUserInfo
{
    [LoginRequestManage requestToGetUserInfoWithParam:nil withSucess:^(NSDictionary *  _Nonnull responseObject)
     {
         [self goToRootViewController];
         
     } withFailed:^(NSString * _Nonnull error) {
         
     }];
}

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


#pragma mark - 点击事件
- (IBAction)loginAction:(id)sender {
    [MobClick endEvent:@"login"];
    [self requestToLogin];
}

- (IBAction)registerAction:(id)sender {
    [MobClick endEvent:@"regist"];
    [[UIViewController currentViewController] pushVC:@"RegistViewController"];
}



@end
