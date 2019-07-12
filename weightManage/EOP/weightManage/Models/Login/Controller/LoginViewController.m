//
//  LoginViewController.m
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

#import "LoginViewController.h"
#import "TabbarViewController.h"
#import "UIViewController+BaseAction.h"
#import "LoginAndRegistLab.h"
#import "LoginRequestManage.h"
#import "CorvodaNormalViewController.h"
#import "MJExtension.h"
#import "LoginModel.h"
#import "UIImage+GIF.h"
#import <UMAnalytics/MobClick.h>
#import "Masonry.h"
#import "UIView+Utils.h"
#import "LoginView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView2;


@property(nonatomic,strong)LoginAndRegistLab *bottomLabel;   //最底下的label

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self topBgAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    [self configuUI];
    
}

#pragma mark -配置UI
-(void)configuUI
{
    
    LoginView *loginView = [[NSBundle mainBundle]loadNibNamed:@"LoginView" owner:self options:nil][0];
    loginView.alpha = 0;
    loginView.frame = CGRectMake(0, 350.0/812*UIScreenHeight, UIScreenWidth, UIScreenHeight -  212.0/812*UIScreenHeight);
    [self.view addSubview:loginView];
    
    //bottomlabel
    LoginAndRegistLab *bottomLab = [[LoginAndRegistLab alloc]initWithFrame:CGRectMake(20.0, CGRectGetHeight(loginView.frame) - BottomBarHeight + 49.0 - 40.0, UIScreenWidth-40.0, 20.0)];
    bottomLab.text = NSLocalizedStrings(@"login_protecol");
    [bottomLab addLabelTapWithText1:NSLocalizedStrings(@"login_userprotecol") withText2:NSLocalizedStrings(@"login_privacyprotecol")];
    [loginView addSubview:bottomLab];

    
    [UIView animateWithDuration:2.5 animations:^{
        loginView.frame = CGRectMake(0, 212.0/812*UIScreenHeight, UIScreenWidth, UIScreenHeight -  212.0/812*UIScreenHeight);
        loginView.alpha = 1;
    }];

}


#pragma mark - 做动画
- (void)topBgAnimation
{
    //设置背景图片的颜色
    self.topBgImageView.frame = CGRectMake(0, UIScreenHeight-600.0/812*UIScreenHeight, UIScreenWidth*2, 600.0/812*UIScreenHeight);
    
    self.topBgImageView2.frame = CGRectMake(UIScreenWidth*2, UIScreenHeight-600.0/812*UIScreenHeight, UIScreenWidth*2, 600.0/812*UIScreenHeight);
    
    [self bgImageAnamation1];
    [self bgImageAnamation2];
}

-(void)bgImageAnamation1
{
    [self translationAnimationView:self.topBgImageView animationDuration:20 animationBlock:^{
        if (self.topBgImageView.x < 0) {
            self.topBgImageView.x = UIScreenWidth*2;
        }
        [self bgImageAnamation1];
    }];
}

-(void)bgImageAnamation2
{
    [self translationAnimationView:self.topBgImageView2 animationDuration:20 animationBlock:^{
        if (self.topBgImageView2.x < 0) {
            self.topBgImageView2.x = UIScreenWidth*2;
        }
        [self bgImageAnamation2];
    }];
}

- (void)translationAnimationView:(UIView *)view animationDuration:(NSTimeInterval)timer animationBlock:(void(^)(void))block
{
    [UIView animateWithDuration:timer animations:^{
        view.x = view.x  - UIScreenWidth*2;
    } completion:^(BOOL finished) {
        if (finished) {
            block();
        }
    }];
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
