//
//  NSURLRequest+NetWorkMethod.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/11.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "NSURLRequest+NetWorkMethod.h"
#import <objc/runtime.h>

static void *NetworkingRequestParams;

@implementation NSURLRequest (NetWorkMethod)

- (void)setRequestParams:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, &NetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams {
    return objc_getAssociatedObject(self, &NetworkingRequestParams);
}


@end
