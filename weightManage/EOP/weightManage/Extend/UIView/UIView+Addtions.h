//
//  UIView+Addtions.h
//  SFD
//
//  Created by Pill.Gong on 7/1/13.
//  Copyright (c) 2013 Harvey Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_IPHONE_SIMULATOR
#define DeviceIsSimulator 1
#else
#define DeviceIsSimulator 0
#endif

#define CurrentDeviceISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define StatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

#define NavigationBarHeight 44
#define BottomBarHeight (ISMoreFiveEightInch?83:50)
#define SystemTakeHeight (StatusBarHeight + NavigationBarHeight)

#define IsiOSOver(version) ([UIDevice currentDevice].systemVersion.floatValue >= version)
#define IsiOS7Over ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define IsiOS11Over ([UIDevice currentDevice].systemVersion.floatValue >= 11.0)
#define ISIOS7 (IsiOS7Over)
#define ISIOS8 (IsiOSOver(8.0))

#define IsiOSO(version) ([UIDevice currentDevice].systemVersion.floatValue == version)
#define ISIOS80 (IsiOSO(8.0))

#define UIScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define UIScreenHeight ([UIScreen mainScreen].bounds.size.height)


#define AppWidth    UIScreenWidth
#define AppHeight   UIScreenHeight

#define CurrentScreenWidth AppWidth

#define ISThreeHalfInch (UIScreenHeight == 480)
#define ISFourInch (UIScreenHeight == 568)
#define ISFourSevenInch (UIScreenHeight == 667)
#define ISFiveHalfInch  (UIScreenHeight == 736)
#define ISFiveEightInch (UIScreenHeight == 812)
#define ISMoreFiveEightInch (UIScreenHeight >= 812)

#define FormatSize(origin) (UIScreenWidth * origin / 375.0)

#define BarHeight (IsiOS7Over ? (NavigationBarHeight + StatusBarHeight) : NavigationBarHeight)

#define COLOR(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define NSStringBOOL(boolValue) (boolValue?@"YES":@"NO")
#define NSStringBOOLInt(boolValue) (boolValue?@"1":@"0")
#define NSStringInt(index) ([[NSString alloc] initWithFormat:@"%d", index])
#define NSStringInteger(index) ([NSString stringWithFormat:@"%zd", index])

#define DefaultTextPadding 5.0f

@interface UIView (SFD)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

#pragma mark - tap gesture

typedef void (^UIViewVoidBlock)(void);

@property (nonatomic) UIViewVoidBlock responseBlock;

- (void)addTapGestureWithTarget:(id)target responseBlock:(UIViewVoidBlock)block;

+ (CAGradientLayer *)getGradientLayerWithFrame:(CGRect)layerFrame Colors:(NSArray *)colors;
+ (CAGradientLayer *)navViewLayer;
+ (CAGradientLayer *)navEmptyViewLayer;
+ (UIImage *)navBgImg;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor;

@end
