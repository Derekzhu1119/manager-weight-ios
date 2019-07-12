//
//  RequestManage+Extand.m
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

#import "RequestManage+Extand.h"
#import <AFNetworking/AFNetworking.h>
#import "UIViewController+BaseAction.h"

@implementation RequestManage (Extand)

+ (BOOL)isNetWorkReachable{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self startNetworkMonitoring];
        return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus > 0 ? YES : NO;
    }else{
        return YES;
    }
}

+ (void)startNetworkMonitoring{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                //               @"网络断开"
                [[UIViewController currentViewController]showTextViewWithStatus:@"似乎与互联网断开连接了"];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                [[UIViewController currentViewController]showTextViewWithStatus:@"无法检测到网络连接"];
                //               @"无法检测到网络连接"
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                //                [[UIViewController currentViewController]showTextViewWithStatus:@"切换到wifi环境"];
                //                @"网络切换至wifi环境"
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                //                [[UIViewController currentViewController]showTextViewWithStatus:@"切换到流量环境"];
                //                @"网络切换至流量环境"
                break;
            }
        }
    }];
    
}


+ (void)stopNetworkMonitoring{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager stopMonitoring];
}


/* 当前在进行中的所有请求*/
+ (NSMutableArray *)arrayOfRequest{
    return nil;
}

/* 取消当前所有请求*/
+ (void)cancelAllRequest{
    
}


@end
