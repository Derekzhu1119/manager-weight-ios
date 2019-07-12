//
//  LoginModel.h
//  weightManage
//
//  Created by iss on 2019/6/21.
//  Copyright © 2019 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN
@class LoginBaseInfoModel;
@class LoginTargetInfoModel;
@interface LoginModel : NSObject

@property(nonatomic,strong)LoginBaseInfoModel *baseInfo;
@property(nonatomic,strong)LoginTargetInfoModel *targetInfo;

@end

@interface LoginBaseInfoModel : NSObject

@property(nonatomic,strong)NSString *birth;
@property(nonatomic,strong)NSString *height;
@property(nonatomic,strong)NSString *loginName;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *userId;

@end

@interface LoginTargetInfoModel : NSObject
@property(nonatomic,strong)NSString *planBeginDays;
@property(nonatomic,strong)NSString *planCompletePercentage;
@property(nonatomic,strong)NSString *planRemainingDays;
@property(nonatomic,strong)NSString *settingDate;
@property(nonatomic,strong)NSString *target;
@property(nonatomic,strong)NSString *targetDate;
@property(nonatomic,strong)NSString *targetWeight;
@property(nonatomic,strong)NSString *weight;

@end

NS_ASSUME_NONNULL_END
