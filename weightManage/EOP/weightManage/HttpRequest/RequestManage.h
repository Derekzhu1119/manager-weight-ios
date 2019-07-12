//
//  RequestManage.h
//  weightManage
//
//  Created by iss on 2019/6/20.
//  Copyright © 2019 iss. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HttpClientSuccessBlock)(id responseObject);
typedef void (^HttpClientFailBlock)(NSString *error);

@interface RequestManage : NSObject

typedef NS_ENUM(NSInteger, RequestMethod) {
    GET = 1,
    POST,
    PATCH,
    DELETE
};

#pragma mark - 数据请求
+(void)requestWithType:(RequestMethod)requestType
                 isShowHud:(BOOL)isShow
                   withUrl:(NSString *)url
                     param:(NSMutableDictionary *)param
                   success:(void (^)(id obj))success
                   failure:(void (^)(NSString *error))failure;



@end

NS_ASSUME_NONNULL_END
