//
//  PXApiProxy.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/7.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXApiProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "PXRequestGenerator.h"

@interface PXApiProxy ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

/**
 请求列表
 */
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@end

@implementation PXApiProxy

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static PXApiProxy *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PXApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(CallBack)success fail:(CallBack)fail {

    NSURLRequest *request = [[PXRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestID = [self callApiWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(CallBack)success fail:(CallBack)fail {
    
    NSURLRequest *request = [[PXRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    NSNumber *requestID = [self callApiWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(CallBack)success fail:(CallBack)fail {
    
    NSLog(@"\n==================================\n\nRequest Start:\n\n %@\n\n==================================", request.URL);
    // 跑到这里的block的时候，就已经是主线程了。
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", response); 
        if (error) {
            NSLog(@"error = %@", error);
            PXURLResponse *response = [[PXURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail ? fail(response) : nil;
        } else {
            PXURLResponse *response = [[PXURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:PXURLResponseStatusSuccess];
            // 检查http response是否成立。
            success ? success(response) : nil;
        }
    }];
    
    NSNumber *requestID = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    [dataTask resume];
    return requestID;
    
}

#pragma mark - cancel request
- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - getters and setters
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

@end
