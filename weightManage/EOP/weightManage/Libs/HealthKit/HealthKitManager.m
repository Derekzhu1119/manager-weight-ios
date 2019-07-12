//
//  HealthKitManager.m
//  weightManage
//
//  Created by iss on 2019/7/1.
//  Copyright © 2019 iss. All rights reserved.
//

#import "HealthKitManager.h"
#import "UIAlertController+alertView.h"

@interface HealthKitManager()

@property (nonatomic, strong) HKHealthStore *healthStore;

@end

@implementation HealthKitManager
static HealthKitManager *instance = nil;


+ (instancetype)sharedManager {
    if (!instance) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [HealthKitManager sharedManager];
}

- (ZFStepAuthorizationStatus)stepAuthorizationStatus {
    if (![self isHealthDataAvailable]) { return ZFStepAuthorizationStatusUnsupport; }
    
    ZFStepAuthorizationStatus stepStatus = ZFStepAuthorizationStatusSharingDenied;
    
    HKObjectType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:stepType];
    switch (status) {
        case HKAuthorizationStatusNotDetermined:
            stepStatus = ZFStepAuthorizationStatusNotDetermined;
            break;
        case HKAuthorizationStatusSharingDenied:
            stepStatus = ZFStepAuthorizationStatusSharingDenied;
            break;
        case HKAuthorizationStatusSharingAuthorized:
            stepStatus = ZFStepAuthorizationStatusSharingAuthorized;
            break;
        default:
            break;
    }
    return stepStatus;
}

- (void)requestHealthKitAuthorization:(void (^)(BOOL, NSError *))compltion {
    if (![self isHealthDataAvailable]) { return; }
    if ([self stepAuthorizationStatus] != ZFStepAuthorizationStatusNotDetermined) { return; }
    
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet *readTypes = [NSSet setWithObjects:stepCountType,nil];
    
    [self.healthStore requestAuthorizationToShareTypes:readTypes readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        if (compltion) {
            compltion(success, error);
        }
    }];
}

- (void)fetchStepCountToday:(void (^)(NSString *, NSError *))completion {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error) {
            completion(@"--",error);
        } else {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results) {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totleSteps += usersHeight;
            }
            NSString *result = [NSString stringWithFormat:@"%.0f",totleSteps];
            completion(result,error);
        }
    }];
    [self.healthStore executeQuery:query];
}


- (BOOL)isHealthDataAvailable {
    return [HKHealthStore isHealthDataAvailable];
}

- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}


- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

- (NSPredicate *)predicateForSamplesYesterday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:now];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:lastDay];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

//写数据
/*
 申请权限
 shareTypes  ：数据写入权限
 readTypes   ：数据读取权限
 **/
- (void)requestAuthorizationToShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                               readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                              completion:(void (^)(BOOL success, NSError * _Nullable error))completion
{
    //使用
    if (!self.healthStore) {
        self.healthStore = [[HKHealthStore alloc] init];
    }
    
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    NSSet *typesSet = [NSSet setWithObjects:heightType, nil];
    //申请身高的读取和写入权限
    [self.healthStore requestAuthorizationToShareTypes:typesSet readTypes:typesSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //获得权限之后，读取数据
            [self writeData];
        } else {
            //您可以在设置--隐私--健康中允许应用读取健康数据
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            NSString *msgStr = [NSString stringWithFormat:@"请在【设置->%@->%@】下允许访问权限",appName,@"运动与健身"];
            [UIAlertController showUIAlertControllerWithTitle:@"提示" withMessage:msgStr withSureBtnTitle:@"确定" withCancleTitle:nil withCancleBtnClick:^(UIAlertAction *action) {
                
            } withSureBtnClick:^(UIAlertAction *action) {
            }];
        }
    }];
}


//写入数据之前，注意要先申请写入权限(身高)
- (void)writeData {
    //身高具体数值类型
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:[HKUnit meterUnitWithMetricPrefix:HKMetricPrefixCenti] doubleValue:181];
    //当前日期
    NSDate *today = [NSDate date];
    
    //身高数值类
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:today endDate:today];
    
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"write success");
    }];
}

//读取身高数据
- (void)readData {
    //身高 CM
    HKSampleType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //NSSortDescriptor用来对数据进行排序
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    //此处按时间筛选  开始时间到结束时间，自定义
    NSDate *date = [NSDate date];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:date endDate:date options:(HKQueryOptionNone)];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:heightType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[start, end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        //循环获取得到的数据
        for (int i = 0; i < results.count; i ++) {
            //把结果转换为字符串类型
            HKQuantitySample *result = results[i];
            HKQuantity *quantity = result.quantity;
            //此处可以输出quantity数据 （带单位信息）
            NSLog(@"quantity = %@", quantity);
            
            //通过单位解析值类型，这里需要获取以CM为单位的身高数据，所以单位信息为[HKUnit meterUnitWithMetricPrefix:HKMetricPrefixCenti]
            //单位信息可参照HKUnit类，文章下面有简单介绍
            CGFloat value = [quantity doubleValueForUnit:[HKUnit meterUnitWithMetricPrefix:HKMetricPrefixCenti]];
            NSLog(@"身高为 = %f", value);
        }
    }];
    
    //******执行查询******
    [self.healthStore executeQuery:sampleQuery];
    
}


- (void)writeDataWithType:(NSInteger)type withCount:(NSString *)count completion:(void (^)(BOOL success, NSError * _Nullable error))completion
{
    if (![self isHealthDataAvailable]) {
        [UIAlertController showUIAlertControllerWithTitle:@"提示" withMessage:@"该设备不支持写入健康数据" withSureBtnTitle:@"确定" withCancleTitle:nil withCancleBtnClick:nil withSureBtnClick:nil];
        return;
    }
    //使用
    if (!self.healthStore) {
        self.healthStore = [[HKHealthStore alloc] init];
    }
    
    HKQuantityType *fatType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal];  //总脂肪
    HKQuantityType *drateType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];  //碳水化合物
    HKQuantityType *proteinType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein];  //蛋白质
    
    NSSet *typesSet = [NSSet setWithObjects:fatType,drateType,proteinType, nil];
    //申请读取和写入权限
    [self.healthStore requestAuthorizationToShareTypes:typesSet readTypes:nil completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //获得权限之后，读取数据
            [self writeDataWithType:type withCount:count withCompletion:completion];
        } else {
            //您可以在设置--隐私--健康中允许应用读取健康数据
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            NSString *msgStr = [NSString stringWithFormat:@"请在【设置->%@->%@】下允许访问权限",appName,@"运动与健身"];
            [UIAlertController showUIAlertControllerWithTitle:@"提示" withMessage:msgStr withSureBtnTitle:@"确定" withCancleTitle:nil withCancleBtnClick:^(UIAlertAction *action) {
                
            } withSureBtnClick:^(UIAlertAction *action) {
            }];
        }
    }];
}

- (void)writeDataWithType:(NSInteger)type withCount:(id)count withCompletion:(void (^)(BOOL success, NSError * _Nullable error))completion
{
    //具体数值类型
    HKQuantityType *healthType = nil;
    //单位
    HKQuantity *healthQuantity = nil ;
    if (type == 0) {  //总脂肪
        healthType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal];
        healthQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:[count doubleValue]];
    }else if(type == 1){ //碳水化合物
        healthType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates];
        healthQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:[count doubleValue]];
    }else if(type == 2){ //蛋白质
        healthType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein];
        healthQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:[count doubleValue]];
    }
    
    //当前日期
    NSDate *today = [NSDate date];
    //数值类
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:healthType quantity:healthQuantity startDate:today endDate:today];
    
    [self.healthStore saveObject:heightSample withCompletion:completion];
}


@end
