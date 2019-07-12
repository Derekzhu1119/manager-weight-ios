//
//  HealthKitManager.h
//  weightManage
//
//  Created by iss on 2019/7/1.
//  Copyright © 2019 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

typedef NS_ENUM(NSInteger, ZFStepAuthorizationStatus) {
    ZFStepAuthorizationStatusNotDetermined = 0,   //未确定
    ZFStepAuthorizationStatusSharingDenied,        //已拒绝
    ZFStepAuthorizationStatusSharingAuthorized,    //已授权
    ZFStepAuthorizationStatusUnsupport,            //不支持
};

NS_ASSUME_NONNULL_BEGIN

@interface HealthKitManager : NSObject

+ (instancetype)sharedManager;


/**
 检查设备是否支持健康数据
 @return yes 支持
 */
- (BOOL)isHealthDataAvailable;


/**
 检查健康数据访问权限
 @return 返回权限状态
 */
- (ZFStepAuthorizationStatus)stepAuthorizationStatus;


/**
 请求用户授权
 @param compltion 回调
 */
- (void)requestHealthKitAuthorization:(void(^)(BOOL success, NSError *error))compltion;


/**
 获取当天步数
 @param completion 回调   出错时 value = @"--"
 */
- (void)fetchStepCountToday:(void(^)(NSString *value, NSError *error))completion;

/*
 申请权限
 shareTypes  ：数据写入权限
 readTypes   ：数据读取权限
 **/
- (void)requestAuthorizationToShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                               readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                              completion:(void (^)(BOOL success, NSError * _Nullable error))completion;

//体重管家写入数据
- (void)writeDataWithType:(NSInteger)type withCount:(NSString *)count completion:(void (^)(BOOL success, NSError * _Nullable error))completion;



@end

NS_ASSUME_NONNULL_END
