//
//  RegistViewController.m
//  weightManage
//
//  Created by iss on 2019/6/21.
//  Copyright © 2019 iss. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginAndRegistLab.h"
#import "TabbarViewController.h"
#import "CorvodaNormalViewController.h"
#import "UIViewController+BaseAction.h"
#import "LoginRequestManage.h"
#import <UMAnalytics/MobClick.h>
#import "HealthKitManager.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UILabel *startRegistLab;
@property (weak, nonatomic) IBOutlet UITextField *account_tf;
@property (weak, nonatomic) IBOutlet UITextField *password_tf;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword_tf;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;

    [self configUI];
}

#pragma mark - 配置UI
- (void)configUI
{
    self.startRegistLab.text = NSLocalizedStrings(@"regist_startReigist");
    self.account_tf.placeholder = NSLocalizedStrings(@"regist_PleaseEnterAccount");
    self.password_tf.placeholder = NSLocalizedStrings(@"regist_PleaseEnterPassword");
    self.confirmPassword_tf.placeholder = NSLocalizedStrings(@"regist_PleaseConfimPassword");
    [self.sureBtn setTitle:NSLocalizedStrings(@"regist_Sure") forState:UIControlStateNormal];
    
    //bottomlabel
    LoginAndRegistLab *bottomLab = [[LoginAndRegistLab alloc]initWithFrame:CGRectMake(20.0, UIScreenHeight - BottomBarHeight + 49.0 - 40.0, UIScreenWidth-40.0, 20.0)];
    bottomLab.text = NSLocalizedStrings(@"login_protecol");
    [bottomLab addLabelTapWithText1:NSLocalizedStrings(@"login_userprotecol") withText2:NSLocalizedStrings(@"login_privacyprotecol")];
    [self.view addSubview:bottomLab];
}

#pragma mark - 数据请求
- (void)requestForRegist
{
    if ([MFSession isEmpty:_account_tf.text]) {
        [self showTextViewWithStatus:NSLocalizedStrings(@"regist_PleaseEnterAccount")];
        return;
    }
    if (![MFSession checkRegistUserName:_account_tf.text]) {
        [self showTextViewWithStatus:NSLocalizedStrings(@"regist_UserNamesShouldBeginWithLetters")];
        return;
    }
    if ([MFSession isEmpty:_password_tf.text]) {
        [self showTextViewWithStatus:NSLocalizedStrings(@"regist_PleaseEnterPassword")];
        return;
    }
    if (_password_tf.text.length < 6) {
        [self showTextViewWithStatus:NSLocalizedStrings(@"regist_PasswordLengthShouldNotBeLessThanSixBits")];
        return;
    }
    if (![_password_tf.text isEqualToString:_confirmPassword_tf.text]) {
        [self showTextViewWithStatus:NSLocalizedStrings(@"regist_PasswordInconsistent")];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_account_tf.text forKey:@"loginName"];
    [dic setObject:_password_tf.text forKey:@"password"];
    [dic setObject:_confirmPassword_tf.text forKey:@"confirmPassword"];
    [LoginRequestManage requestToRegistWithParam:dic withSucess:^(id  _Nonnull responseObject)
    {
        [self showTextViewWithStatus:NSLocalizedStrings(@"regist_registrationSuccess")];
        [self.navigationController popViewControllerAnimated:YES];
    } withFailed:^(NSString * _Nonnull error)
    {
        
    }];
    
}

#pragma mark - 点击事件
- (IBAction)sureBtnAction:(id)sender {
    [MobClick endEvent:@"regist_confirm"];
    [self requestForRegist];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
