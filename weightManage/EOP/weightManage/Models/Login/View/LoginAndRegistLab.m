//
//  LoginAndRegistLab.m
//  weightManage
//
//  Created by iss on 2019/6/21.
//  Copyright © 2019 iss. All rights reserved.
//

#import "LoginAndRegistLab.h"
#import "NSAttributedString+YYText.h"
#import "UIViewController+BaseAction.h"
#import "CorvodaNormalViewController.h"
#import <UMAnalytics/MobClick.h>

@implementation LoginAndRegistLab

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
    }
    return self;
}

-(void)addLabelTapWithText1:(NSString *)text1 withText2:(NSString *)text2
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attributes];
    NSRange range1 = [[text string] rangeOfString:text1];
    NSRange range2 = [[text string] rangeOfString:text2];
    [text addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range1];
    [text addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range2];
    //设置高亮色和点击事件
    __block UIViewController *currentVC = [UIViewController currentViewController];
    [text yy_setTextHighlightRange:range1 color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect)
    {
//        [currentVC showTextViewWithStatus:@"用户协议"];
        CorvodaNormalViewController *vc =[[CorvodaNormalViewController alloc]init];
        vc.startPage = [MFSession getHtmlPathWithUrl:protecol];
        [currentVC.navigationController pushViewController:vc animated:YES];
    }];
    //设置高亮色和点击事件
    [text yy_setTextHighlightRange:range2 color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        [currentVC showTextViewWithStatus:@"隐私协议"];
        CorvodaNormalViewController *vc =[[CorvodaNormalViewController alloc]init];
        vc.startPage = [MFSession getHtmlPathWithUrl:protecol];
        [currentVC.navigationController pushViewController:vc animated:YES];
    }];
    
    self.attributedText = text;
    //居中显示一定要放在这里，放在viewDidLoad不起作用
    self.textAlignment = NSTextAlignmentCenter;

}


@end
