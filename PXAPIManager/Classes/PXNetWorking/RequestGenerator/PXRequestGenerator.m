//
//  PXRequestGenerator.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/11.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>
#import "PXServiceFactory.h"
#import "PXNetworkingConfiguration.h"
#import "NSURLRequest+NetWorkMethod.h"

@interface PXRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation PXRequestGenerator

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PXRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PXRequestGenerator alloc] init];
    });
    return sharedInstance;
}

/// get
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    NSLog(@"%@", requestParams);
    [self setRequestHeader:self.httpRequestSerializer];
    NSString *url = nil;
    PXService *service = [[PXServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    if (service.apiVersion.length == 0) {
        url = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    } else {
        url = [NSString stringWithFormat:@"%@/%@/%@", service.apiBaseUrl, service.apiVersion, methodName];
    }
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:url parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    

    return request;
}

/// post
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    [self setRequestHeader:self.httpRequestSerializer];
    NSString *url = nil;
    PXService *service = [[PXServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    if (service.apiVersion.length == 0) {
        url = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    } else {
        url = [NSString stringWithFormat:@"%@/%@/%@", service.apiBaseUrl, service.apiVersion, methodName];
    }
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:url parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    NSLog(@"\n ============ requestParams ============ \n%@", request.requestParams);
    
    return request;
}

// set request header
- (void)setRequestHeader:(AFHTTPRequestSerializer *)httpRequestSerializer {
    
    [httpRequestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSLog(@"%@", httpRequestSerializer.HTTPRequestHeaders);
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

@end
