//
//  LoadingView.m
//  weightManage
//
//  Created by iss on 2019/6/26.
//  Copyright © 2019 iss. All rights reserved.
//

#import "LoadingView.h"
#import "Masonry.h"
#import "UIImage+GIF.h"

#define CQLoadingDefaultView [UIApplication sharedApplication].delegate.window

@interface LoadingView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation LoadingView

#pragma mark - show

+ (void)show {
    [LoadingView showOnView:CQLoadingDefaultView withInfo:@""];
}

+ (void)showWithInfo:(NSString *)info {
    [LoadingView showOnView:CQLoadingDefaultView withInfo:info];
}

+ (void)showOnView:(UIView *)superView {
    [LoadingView showOnView:superView withInfo:@""];
}

+ (void)showOnView:(UIView *)superView withInfo:(NSString *)info {
    // 先将view上的loading移除
    [LoadingView removeFromView:superView];
    
    LoadingView *loading = [[LoadingView alloc] initWithInfo:info];
    [superView addSubview:loading];
    [loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.mas_equalTo(superView);
    }];
}

+ (void)showOnViewWithBig:(UIView *)superView withSex:(NSString *)sex;
{
    // 先将view上的loading移除
    [LoadingView removeFromView:superView];

    LoadingView *loading = [[LoadingView alloc] initWithSex:sex];
    [superView addSubview:loading];
    [loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.mas_equalTo(superView);
    }];
}

#pragma mark - remove

+ (void)remove {
    [LoadingView removeFromView:CQLoadingDefaultView];
}

+ (void)removeFromView:(UIView *)superView {
    [MFSession hideStatusBarHud];
    for (UIView *subView in superView.subviews) {
        if ([subView isMemberOfClass:[LoadingView class]]) {
            [UIView animateWithDuration:0.5 animations:^{
                subView.alpha = 0;
            }completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        }
    }
}

#pragma mark - init

- (instancetype)initWithInfo:(NSString *)info {
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];;
        
        [MFSession showStatusBarHud];

        /*
        //------- image view -------//
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage sd_animatedGIFNamed:@"loading"];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            if ([info isEqualToString:@""]) {
                // 纯loading，放view正中
                make.centerY.mas_equalTo(self);
            } else {
                // 有文本的loading，将imageView调高点
                make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-20);
            }
        }];
        
        //------- info label -------//
        self.infoLabel = [[UILabel alloc] init];
        [self addSubview:self.infoLabel];
        self.infoLabel.text = info;
        self.infoLabel.font = [UIFont systemFontOfSize:14];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(220);
            make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(self);
        }];
         */
    }
        
    return self;
}

- (instancetype)initWithSex:(NSString *)sex {
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];;

        //------- image view -------//
        self.imageView = [[UIImageView alloc] init];
        if ([sex isEqualToString:@"1"]) {
            self.imageView.image = [UIImage sd_animatedGIFNamed:@"loading_man"];
        }else{
            self.imageView.image = [UIImage sd_animatedGIFNamed:@"loading_women"];
        }
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(UIScreenHeight);
        }];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
