//
//  LoadingView.h
//  weightManage
//
//  Created by iss on 2019/6/26.
//  Copyright © 2019 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingView : UIView

+ (void)show;
+ (void)showWithInfo:(NSString *)info;
+ (void)showOnView:(UIView *)superView;
+ (void)showOnView:(UIView *)superView withInfo:(NSString *)info;
+ (void)showOnViewWithBig:(UIView *)superView withSex:(NSString *)sex;

+ (void)remove;
+ (void)removeFromView:(UIView *)superView;


@end

NS_ASSUME_NONNULL_END
