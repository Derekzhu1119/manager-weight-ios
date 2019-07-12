//
//  Header.h
//  weightManage
//
//  Created by iss on 2019/6/19.
//  Copyright © 2019 iss. All rights reserved.
//

#ifndef Header_h
#define Header_h

//宏常亮
#define headerUrl @""

#define WS(weakSelf)  __weak __typeof(self) weakSelf = self
#define  NSLocalizedStrings(string)  NSLocalizedString(string, nil)
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define UserDefault_Account      @"UserDefault_Account"

#import "UIColor+HexStr.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MFSession.h"
#import "MBProgressHUD+LLGif.h"
#import "LoadingView.h"

//色值
#define TabBgColor  [UIColor colorWithHexString:@"#1f1485"]

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



#endif /* Header_h */
