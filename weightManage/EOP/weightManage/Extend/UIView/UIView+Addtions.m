
//  UIView+Addtions.m
//  SFD
//
//  Created by Pill.Gong on 7113.
//  Copyright (c) 2013 Harvey Ding. All rights reserved.


#import "UIView+Addtions.h"
#import <objc/runtime.h>

#import "MFSession.h"
#import "UIImage+Addtions.h"

@implementation UIView (SFD)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)ttScreenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)ttScreenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


#pragma mark - tap gesture

- (UIViewVoidBlock)tapResponseBlock
{
    return (UIViewVoidBlock)objc_getAssociatedObject(self, @selector(tapResponseBlock));
}

- (void)setTapResponseBlock:(UIViewVoidBlock)cacheKey
{
    objc_setAssociatedObject(self, @selector(tapResponseBlock), cacheKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addTapGestureWithTarget:(id)target responseBlock:(UIViewVoidBlock)block {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(tapGesture:)];

    if (block) {
        self.tapResponseBlock = block;
    }

    [self addGestureRecognizer:tap];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (self.tapResponseBlock) {
            self.tapResponseBlock();
        }
    }
}

+ (CAGradientLayer *)getGradientLayerWithFrame:(CGRect)layerFrame Colors:(NSArray *)colors
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setFrame:layerFrame];
    [gradientLayer setColors:colors];
    [gradientLayer setStartPoint:CGPointZero];
    [gradientLayer setEndPoint:CGPointMake(0, 1.0)];
    return gradientLayer;
}

+ (CAGradientLayer *)navViewLayer
{
    CGFloat navBarH = ISMoreFiveEightInch?44.0:0;
    CAGradientLayer *viewLayer = [self getGradientLayerWithFrame:CGRectMake(0, 0, UIScreenWidth, navBarH) Colors:@[(id)UIColorFromRGB(0x5D3CDF).CGColor, (id)UIColorFromRGB(0x7494D9).CGColor]];
    return viewLayer;
}

+ (UIImage *)navBgImg
{
    MFSession *session = [MFSession shareMFSession];
    if (!session.navImage) {
        CGFloat navBarH = ISMoreFiveEightInch?88.0:64.0;
        UIImage *navBg = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0x6240E7), UIColorFromRGB(0x0F73D9)] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(UIScreenWidth, navBarH)];
        session.navImage = navBg;
    }
    return session.navImage;
}

+ (CALayer *)navEmptyViewLayer
{
    CGFloat navBarH = ISMoreFiveEightInch?44.0:0;
    CALayer *emptyLayer = [CALayer layer];
    emptyLayer.backgroundColor = [UIColor blueColor].CGColor;
    emptyLayer.bounds = CGRectMake(0, 0, UIScreenWidth, navBarH);
    return emptyLayer;
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length]< 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length]!= 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor
{
    view.layer.shadowColor = theColor.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 2.0;
    
    float shadowPathWidth = view.layer.shadowRadius + 2.0;
    CGRect shadowRect = CGRectMake(0, view.bounds.size.height, view.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    view.layer.shadowPath = path.CGPath;
}


@end
