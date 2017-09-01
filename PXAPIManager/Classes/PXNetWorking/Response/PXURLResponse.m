//
//  PXURLResponse.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/13.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXURLResponse.h"
#import "NSURLRequest+NetWorkMethod.h"
#import "NSObject+NetWorkingMethods.h"

@interface PXURLResponse ()

/**
 响应状态
 */
@property (nonatomic, assign, readwrite) PXURLResponseStatus status;

/**
 通过解析后的串
 */
@property (nonatomic, copy, readwrite) NSString *contentString;

/**
 数据通过 JSON 解析后的对象
 */
@property (nonatomic, copy, readwrite) id content;

/**
 请求失败 error
 */
@property (nonatomic, strong, readwrite) NSError *error;

/**
 request 对象
 */
@property (nonatomic, copy, readwrite) NSURLRequest *request;

/**
 request ID
 */
@property (nonatomic, assign, readwrite) NSInteger requestID;

/**
 原始数据
 */
@property (nonatomic, copy, readwrite) NSData *responseData;

/**
 是否缓存
 */
@property (nonatomic, assign, readwrite) BOOL isCache;


@end

@implementation PXURLResponse

#pragma mark - life cycle
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData status:(PXURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = status;
        self.requestID = [requestID integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
        
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error {
    self = [super init];
    if (self) {
        self.contentString = [responseString PX_defaultValue:@""];
        self.status = [self responseStatusWithError:error];
        self.error = error;
        self.requestID = [requestID integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
        
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
    }
    return self;
}



#pragma mark - private methods
- (PXURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        PXURLResponseStatus result = PXURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = PXURLResponseStatusErrorTimeout;
        }
        return result;
    } else {
        return PXURLResponseStatusSuccess;
    }
}

@end
