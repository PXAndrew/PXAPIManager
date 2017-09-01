//
//  PXAPIBaseManager.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/7.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXURLResponse.h"

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kAPIBaseManagerRequestID = @"kAPIBaseManagerRequestID";

typedef NS_ENUM (NSUInteger, PXAPIManagerErrorType){
    PXAPIManagerErrorTypeDefault = 0,       //没有产生过API请求，这个是manager的默认状态。
    PXAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    PXAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    PXAPIManagerErrorTypeParamsError,   //错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    PXAPIManagerErrorTypeTimeout,       //请求超时。APIProxy设置的是20秒超时，具体超时时间的设置请自己去看APIProxy的相关代码。
    PXAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, PXAPIManagerRequestType){
    PXAPIManagerRequestTypeGet,
    PXAPIManagerRequestTypePost,
    PXAPIManagerRequestTypePut,
    PXAPIManagerRequestTypeDelete
};

/*
 总述：
 这个base manager是用于给外部访问API的时候做的一个基类。任何继承这个基类的manager都要添加两个getter方法：
 
 - (NSString *)methodName
 {
 return @"community.searchMap";
 }
 
 - (RTServiceType)serviceType
 {
 return RTcasatwyServiceID;
 }
 
 外界在使用manager的时候，如果需要调api，只要调用loadData即可。manager会去找paramSource来获得调用api的参数。调用成功或失败，则会调用delegate的回调函数。
 
 继承的子类manager可以重载basemanager提供的一些方法，来实现一些扩展功能。具体的可以看m文件里面对应方法的注释。
 */


@class PXAPIBaseManager;
/*************************************************************************************************/
/*                               PXAPIManagerApiCallBackDelegate                                 */
/*************************************************************************************************/

//api回调
@protocol PXAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(PXAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(PXAPIBaseManager *)manager;
@end

// 数据莲蓬头
@protocol PXAPIManagerDataReformer <NSObject>
@required
- (id)manager:(PXAPIBaseManager *)manager reformData:(NSDictionary *)data;
@end

// 数据校验
@protocol PXAPIManagerValidator <NSObject>
@required
- (BOOL)manager:(PXAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(PXAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

// 参数
@protocol PXAPIManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(PXAPIBaseManager *)manager;
@end

@protocol PXAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(PXAPIBaseManager *)manager beforePerformSuccessWithResponse:(PXURLResponse *)response;
- (void)manager:(PXAPIBaseManager *)manager afterPerformSuccessWithResponse:(PXURLResponse *)response;

- (BOOL)manager:(PXAPIBaseManager *)manager beforePerformFailWithResponse:(PXURLResponse *)response;
- (void)manager:(PXAPIBaseManager *)manager afterPerformFailWithResponse:(PXURLResponse *)response;

- (BOOL)manager:(PXAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(PXAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

/*
 PXAPIBaseManager的派生类必须符合这些protocal
 */
@protocol PXAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (PXAPIManagerRequestType)requestType;
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;

@end


@interface PXAPIBaseManager : NSObject

@property (weak, nonatomic) id<PXAPIManagerCallBackDelegate> delegate;  // 回调
@property (weak, nonatomic) id<PXAPIManagerParamSource> paramSource;    // 参数
@property (weak, nonatomic) id<PXAPIManagerValidator> validator;        // 检验器
@property (weak, nonatomic) id<PXAPIManagerInterceptor> interceptor;    // 拦截器

@property (weak, nonatomic) NSObject<PXAPIManager> *child;

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。
 */
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) PXAPIManagerErrorType errorType;
@property (nonatomic, strong) PXURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id)fetchDataWithReformer:(id<PXAPIManagerDataReformer>)reformer;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (NSInteger)loadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
- (BOOL)beforePerformSuccessWithResponse:(PXURLResponse *)response;
- (void)afterPerformSuccessWithResponse:(PXURLResponse *)response;

- (BOOL)beforePerformFailWithResponse:(PXURLResponse *)response;
- (void)afterPerformFailWithResponse:(PXURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;


@end
