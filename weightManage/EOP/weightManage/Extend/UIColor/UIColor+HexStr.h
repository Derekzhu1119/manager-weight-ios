
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor(HexStr)


/**
 * 6位十六进制
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/*
 * 带alpha
 */
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;


/**
 * 带8位的十六进制
 */
+ (UIColor *) colorWithLongHexString: (NSString *)color;

@end
