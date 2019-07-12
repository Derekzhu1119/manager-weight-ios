//
//  RequestManage+Extand.h
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

#import "RequestManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestManage (Extand)

/* 网络是否连接*/
+ (BOOL)isNetWorkReachable;

/* 开启网络监控*/
+ (void)startNetworkMonitoring;

/* 关闭网络监控*/
+ (void)stopNetworkMonitoring;

/* 当前在进行中的所有请求*/
+ (NSMutableArray *)arrayOfRequest;

/* 取消当前所有请求*/
+ (void)cancelAllRequest;


@end

NS_ASSUME_NONNULL_END
