//
//  PXAPIBaseManager.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/7.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXAPIBaseManager.h"
#import "PXApiProxy.h"
#import "PXNetworkingConfiguration.h"

#define CallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [[PXApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(PXURLResponse *response) { \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(PXURLResponse *response) {                                                        \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf failedOnCallingAPI:response withErrorType:PXAPIManagerErrorTypeDefault];    \
    }];                                                                                         \
    [self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

@interface PXAPIBaseManager ()

// 原始数据
@property (nonatomic, strong, readwrite) id fetchedRawData;
// 请求列表
@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, assign, readwrite) BOOL isLoading;

@property (nonatomic, readwrite) PXAPIManagerErrorType errorType;

@end

@implementation PXAPIBaseManager


#pragma mark - life cycle
- (instancetype)init {

    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(PXAPIManager)]) {
            _child = (id<PXAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - calling api
- (NSInteger)loadData {
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            // 实际的网络请求
            if ([self isReachable]) {
                self.isLoading = YES;
                switch (self.child.requestType) {
                    case PXAPIManagerRequestTypeGet:
                        CallAPI(GET, requestId);
                        break;
                    case PXAPIManagerRequestTypePost:
                        CallAPI(POST, requestId);
                        break;
                    default:
                        break;
                }
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:PXAPIManagerErrorTypeDefault];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:PXAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(PXURLResponse *)response {
    
    self.isLoading = NO;
    self.response = response;
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    // 成功回调，从表中把对应 request 移除
    [self removeRequestIdWithRequestID:response.requestId];
    
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self beforePerformSuccessWithResponse:response]) {
            
            [self.delegate managerCallAPIDidSuccess:self];
            
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:PXAPIManagerErrorTypeNoContent];
    }

}

- (void)failedOnCallingAPI:(PXURLResponse *)response withErrorType:(PXAPIManagerErrorType)errorType
{
    self.isLoading = NO;
    self.response = response;

    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self beforePerformFailWithResponse:response]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern (装饰模式)
 */
- (BOOL)beforePerformSuccessWithResponse:(PXURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = PXAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(PXURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(PXURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(PXURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - method for child
//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache {
    return kShouldCache;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestID {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestID) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}


#pragma mark - public methods
- (void)cancelAllRequests {
    [[PXApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [[PXApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
    [self removeRequestIdWithRequestID:requestID];
}

- (id)fetchDataWithReformer:(id<PXAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - setters and getters
- (BOOL)isReachable {
    return YES;
}

- (BOOL)isLoading {
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

@end
