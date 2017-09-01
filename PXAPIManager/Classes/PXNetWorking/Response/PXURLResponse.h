//
//  PXURLResponse.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/13.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXNetworkingConfiguration.h"

@interface PXURLResponse : NSObject

@property (nonatomic, assign, readonly) PXURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;

@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData status:(PXURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

@end
