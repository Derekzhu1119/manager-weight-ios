//
//  BaseNavigationViewController.m
//  YaYin
//
//  Created by He on 2018/5/2.
//  Copyright © 2018年 He. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "UIColor+HexStr.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if (self.viewControllers.count == 2) {
        UIViewController *viewController = (UIViewController *)[self.viewControllers firstObject];
        viewController.hidesBottomBarWhenPushed = NO;
    }
    return [super popViewControllerAnimated:animated];
    
}

+ (void)initialize {
    //导航栏设置
    [[UINavigationBar appearance] setBarTintColor:TabBgColor]; //背景色
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#000000"]];//图标颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];     //标题颜色
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barStyle = UIStatusBarStyleLightContent;   //状态栏字体颜色
    //去除导航栏线
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
