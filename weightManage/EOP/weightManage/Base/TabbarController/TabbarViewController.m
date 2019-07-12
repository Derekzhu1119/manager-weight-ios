//
//  TabbarViewController.m
//  weightManage
//
//  Created by iss on 2019/6/19.
//  Copyright © 2019 iss. All rights reserved.
//

typedef NS_ENUM(NSInteger, DirectionStyle){
    DirectionStyleToUnder = 0,  //向下
    DirectionStyleToUn = 1      //向上
};
#import "TabbarViewController.h"
#import "PunchClockViewController.h"
#import "UIColor+HexStr.h"
#import "BaseNavigationViewController.h"
#import "ViewController.h"
#import <UMAnalytics/MobClick.h>

@interface TabbarViewController ()<UITabBarControllerDelegate>

@property(nonatomic,strong)NSArray *enentArray;

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    //设置tababr颜色
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    [UITabBar appearance].translucent = YES;
    
    //去除tabbar的横线
//    [self.tabBar setBackgroundImage:[UIImage new]];
    UIImage *bgImage = [self gradientColorWithRed:31/255.0 green:20/255.0 blue:133/255.0 startAlpha:0 endAlpha:1 direction:DirectionStyleToUnder frame:CGRectMake(0, 0, UIScreenWidth, BottomBarHeight)];
    [self.tabBar setBackgroundImage:bgImage];
//    [self.tabBar setShadowImage:[UIImage new]];
    self.tabBar.layer.borderWidth = 0.0f;
    self.tabBar.clipsToBounds = YES;
    [self creteMenu];
}

-(void)creteMenu
{
    NSArray *imageArray = [[NSArray alloc]initWithObjects:@"tab_targrt",@"tab_punch",@"tab_analyse", nil];
    [self addChildViewController:[[PunchClockViewController alloc]init] title:nil imageName:imageArray[0] withTag:0];
    [self addChildViewController:[[PunchClockViewController alloc]init] title:nil imageName:imageArray[1] withTag:1];
    [self addChildViewController:[[PunchClockViewController alloc]init] title:nil imageName:imageArray[2] withTag:2];
    self.delegate = self;
    self.selectedIndex = 1;
    [MobClick endEvent:self.enentArray[1]]; //
}

-(void)addChildViewController:(UIViewController *)controller  title:(NSString *)title imageName:(NSString *)imageName withTag:(NSInteger)tag
{
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:controller];
    if ([controller isKindOfClass:[PunchClockViewController class]]) {
        PunchClockViewController *vc = (PunchClockViewController *)controller;
        if (tag == 1) {
            vc.startPage = [MFSession getHtmlPathWithUrl:punchUrl]; //打卡
        }else if (tag == 0){
            vc.startPage = [MFSession getHtmlPathWithUrl:targetUrl]; //目标
        }else if(tag == 2){
            vc.startPage = [MFSession getHtmlPathWithUrl:analyseUrl]; //报表
        }
    }
    nav.tabBarItem.tag = tag;
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select",imageName]];
    UIImage *normalMultipleImage = [self createNewImageWithColor:normalImage multiple:0.8];
    UIImage *selectedMultipleImage = [self createNewImageWithColor:selectedImage multiple:0.8];
    nav.tabBarItem.image = normalMultipleImage;
    nav.tabBarItem.selectedImage = selectedMultipleImage;
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);  //设置图标偏移量
    [self addChildViewController:nav];
}

//设置TabBarItem图片的大小
//2.图片放大或压缩处理 ，图片放大倍数 0 ~ 2 之间 ，0~1 缩小图片，1~2 放大图片
/**
 *  根据image 返回放大或缩小之后的图片
 *
 *  @param image    原始图片
 *  @param multiple 放大倍数 0 ~ 2 之间
 *
 *  @return 新的image
 */
- (UIImage *) createNewImageWithColor:(UIImage *)image multiple:(CGFloat)multiple
{
    CGFloat newMultiple = multiple;
    if (multiple == 0) {
        newMultiple = 1;
    }
    else if((fabs(multiple) > 0 && fabs(multiple) < 1) || (fabs(multiple)>1 && fabs(multiple)<2))
    {
        newMultiple = multiple;
    }
    else
    {
        newMultiple = 1;
    }
    CGFloat w = image.size.width*newMultiple;
    CGFloat h = image.size.height*newMultiple;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *tempImage = nil;
    CGRect imageFrame = CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:0] addClip];
    [image drawInRect:imageFrame];
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [tempImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


//渐变色
- (UIImage *)gradientColorWithRed:(CGFloat)red
                          green:(CGFloat)green
                           blue:(CGFloat)blue
                     startAlpha:(CGFloat)startAlpha
                       endAlpha:(CGFloat)endAlpha
                      direction:(DirectionStyle)direction
                          frame:(CGRect)frame
{
    //底部上下渐变效果背景
    // The following methods will only return a 8-bit per channel context in the DeviceRGB color space. 通过图片上下文设置颜色空间间
    UIGraphicsBeginImageContext(frame.size);
    //获得当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建颜色空间 /* Create a DeviceRGB color space. */
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //通过矩阵调整空间变换
    CGContextScaleCTM(context, frame.size.width, frame.size.height);
    
    //通过颜色组件获得渐变上下文
    CGGradientRef backGradient;
    //253.0/255.0, 163.0/255.0, 87.0/255.0, 1.0,
    if (direction == DirectionStyleToUnder) {
        //向下
        //设置颜色 矩阵
        CGFloat colors[] = {
            red, green, blue, startAlpha,
            red, green, blue, endAlpha,
        };
        backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    } else {
        //向上
        CGFloat colors[] = {
            red, green, blue, endAlpha,
            red, green, blue, startAlpha,
        };
        backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    }
    
    //释放颜色渐变
    CGColorSpaceRelease(rgb);
    //通过上下文绘画线色渐变
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0.5, 0), CGPointMake(0.5, 1), kCGGradientDrawsBeforeStartLocation);
    //通过图片上下文获得照片
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

#pragma mark - tab点击
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [MobClick endEvent:self.enentArray[tabBarController.selectedIndex]];
    
    //发通知,回调js方法
//    [[NSNotificationCenter defaultCenter]postNotificationName:CLICKTABNOTIFICATION object:@(tabBarController.selectedIndex)];
}

-(NSArray *)enentArray{
    if (!_enentArray) {
        _enentArray = [NSArray arrayWithObjects:@"target",@"punchClock",@"analyse", nil];
    }
    return _enentArray;
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
