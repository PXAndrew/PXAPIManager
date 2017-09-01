//
//  PXApiProxy.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/7.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXURLResponse.h"

typedef void(^CallBack)(PXURLResponse *response);

@interface PXApiProxy : NSObject

/**
 获取单例

 @return 单例
 */
+ (instancetype)sharedInstance;


- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(CallBack)success fail:(CallBack)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(CallBack)success fail:(CallBack)fail;


- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(CallBack)success fail:(CallBack)fail;


- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;



@end
