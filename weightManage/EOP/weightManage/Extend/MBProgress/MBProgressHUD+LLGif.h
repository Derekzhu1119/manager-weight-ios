//
//  MBProgressHUD+LLGif.h
//  DragTrain
//
//  Created by LYC on 2018/6/5.
//  Copyright © 2018年 com. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LLGif)

/**
 *  1.建议Appdelegate初始化调用，可减少初次调用有空白的情况
 *  2.该方法加载速度很快基本不会影响App的启动速度
 */
+ (void)initAnimationGif;

+ (instancetype)showGifHUD:(UIView *)view animated:(BOOL)animated;
+ (void)hidenGifHUD:(BOOL)animated;

@end
