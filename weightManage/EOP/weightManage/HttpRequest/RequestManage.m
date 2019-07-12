//
//  RequestManage.m
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

#import "RequestManage.h"
#import "RequestManage+Extand.h"
#import <AFNetworking/AFNetworking.h>
#import "UIViewController+BaseAction.h"

static NSInteger const kTimeoutInterval =  10.0;
static NSString *const kErrorMessage= @"服务器繁忙,请稍后再试";
static NSString *const kErrorSpell = @"module错误,请检查拼写";
static NSString *const KErrorNotReachable = @"网络异常，请稍后再试";

@implementation RequestManage

+ (AFHTTPSessionManager *)sharedManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^
                  {
                      manager = [AFHTTPSessionManager manager];
                      manager.requestSerializer = [AFJSONRequestSerializer serializer];
                      manager.responseSerializer = [AFJSONResponseSerializer serializer];
                      manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
//                      manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                      [manager.requestSerializer setValue:@"application/json;charset=UTF-8;application/problem+json" forHTTPHeaderField:@"Content-Type"];
                      manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain",@"text/json",@"application/javascript",@"application/x-javascript" ,@"text/javascript",@"text/x-javascript",@"text/x-json", @"application/problem+json",nil];
//                      manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                      manager.requestSerializer.timeoutInterval = kTimeoutInterval;
                      
                  });
    return manager;
}

#pragma mark - 数据请求
+(void)requestWithType:(RequestMethod)requestType
                 isShowHud:(BOOL)isShow
                   withUrl:(NSString *)url
                     param:(NSMutableDictionary *)param
                   success:(void (^)(id obj))success
                   failure:(void (^)(NSString *error))failure
{
    if (isShow) {
        UIViewController *currentVC = [UIViewController currentViewController];
//        [MBProgressHUD showGifHUD:currentVC.view animated:YES];
        [LoadingView showOnView:currentVC.view];
    }
    if (!param) {
        param = [NSMutableDictionary new];
    }
    
    NSLog(@"###请求链接----%@\n 参数----%@",url,param);
    switch (requestType) {
        case GET:
            [self requestGETWithUrl:url param:param success:success failure:failure];
            break;
        case POST:
            [self requestPostWithUrl:url param:param success:success failure:failure];
            break;
        default:
            break;
    }
}


#pragma mark - POST请求,无图片参数
+ (void)requestPostWithUrl:(NSString *)url
                         param:(NSMutableDictionary *)param
                       success:(void (^)(id obj))success
                       failure:(void (^)(NSString *error))failure
{
    AFHTTPSessionManager *manage = [self sharedManager];
//    [manage.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//        return [self getColleagueZoneFormatStringWithDic:param];
//    }];
    if ([MFSession shareMFSession].token) {
        [manage.requestSerializer setValue:[MFSession shareMFSession].token forHTTPHeaderField:@"token"];
    }
    
    [manage POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hidenGifHUD:YES];
        [LoadingView removeFromView:[UIViewController currentViewController].view];
        //成功回调
        if (success && [responseObject[@"code"]integerValue] == 2000 )
        {
            success(responseObject);
        }else{
            [[UIViewController currentViewController]showTextViewWithStatus:responseObject[@"msg"]];
            if (failure) {
                failure(responseObject[@"msg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [MBProgressHUD hidenGifHUD:YES];
        [LoadingView removeFromView:[UIViewController currentViewController].view];
        //失败回调
        if (failure) {
            [[UIViewController currentViewController] showTextViewWithStatus:![RequestManage isNetWorkReachable] ? KErrorNotReachable : error.description];
            ![RequestManage isNetWorkReachable] ? failure(KErrorNotReachable) : failure(error.description);
        }
    }];
}

#pragma mark - GET请求,无图片参数
+ (void)requestGETWithUrl:(NSString *)url
                        param:(NSMutableDictionary *)param
                      success:(void (^)(id obj))success
                      failure:(void (^)(NSString *error))failure
{
    //把token塞进header
    AFHTTPSessionManager *manage = [self sharedManager];
    if ([MFSession shareMFSession].token) {
        [manage.requestSerializer setValue:[MFSession shareMFSession].token forHTTPHeaderField:@"token"];
    }

    [manage GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         [MBProgressHUD hidenGifHUD:YES];
        [LoadingView removeFromView:[UIViewController currentViewController].view];
        //成功回调
        if (success && [responseObject[@"code"]integerValue] == 2000 )
        {
            success(responseObject);
        }else{
            [[UIViewController currentViewController]showTextViewWithStatus:responseObject[@"msg"]];
            if (failure) {
                failure(responseObject[@"msg"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [MBProgressHUD hidenGifHUD:YES];
        [LoadingView removeFromView:[UIViewController currentViewController].view];
        //失败回调
        if (failure) {
            [[UIViewController currentViewController] showTextViewWithStatus:![RequestManage isNetWorkReachable] ? KErrorNotReachable : error.description];
            ![RequestManage isNetWorkReachable] ? failure(KErrorNotReachable) : failure(error.description);
        }
    }];
}

+ (NSString *)getColleagueZoneFormatStringWithDic:(NSDictionary *)dic {
    if (!dic.allKeys.count) {
        return nil;
    }
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *key in dic.allKeys) {
        id obj = dic[key];
        [mutableString appendFormat:@"%@=%@&", key, obj];
    }
    return [mutableString substringToIndex:mutableString.length - 1];
}


@end
