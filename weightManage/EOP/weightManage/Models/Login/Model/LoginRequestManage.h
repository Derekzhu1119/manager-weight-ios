//
//  LoginRequestManage.h
//  weightManage
//
//  Created by iss on 2019/6/21.
//  Copyright © 2019 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginRequestManage : RequestManage

+(void)requestToLoginWithAccount:(NSString *)account withPassword:(NSString *)password withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock;

+(void)requestToRegistWithParam:(NSMutableDictionary *)dic withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock;

+(void)requestToGetUserInfoWithParam:(nullable NSMutableDictionary *)dic withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock;

+(void)requestToLogoutWithParam:(nullable NSMutableDictionary *)dic withSucess:(HttpClientSuccessBlock)successBlock withFailed:(HttpClientFailBlock)failedBlock;


@end

NS_ASSUME_NONNULL_END
