//
//  PXNearAPIMangager.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXNearAPIMangager.h"

@interface PXNearAPIMangager () <PXAPIManagerValidator>

@end

@implementation PXNearAPIMangager

- (instancetype)init {
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName {
    return @"home/list";
}

- (PXAPIManagerRequestType)requestType {
    return PXAPIManagerRequestTypePost;
}

- (NSString *)serviceType {
    return into;
}

- (BOOL)shouldCache {
    return NO;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithDictionary:params];
    // 定位，页码可以在此方法中写

    return resDict;
}

- (BOOL)manager:(PXAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}
- (BOOL)manager:(PXAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}


@end
