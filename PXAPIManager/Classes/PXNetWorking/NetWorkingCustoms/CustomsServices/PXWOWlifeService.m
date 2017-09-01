//
//  PXWOWlifeService.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/12.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXWOWlifeService.h"

@implementation PXWOWlifeService

- (BOOL)isOnline {
    return YES;
}

- (NSString *)offlineApiBaseUrl {
    return nil;
}

- (NSString *)onlineApiBaseUrl {
    return @"http://mobapi.intocity.cn/api";
}

- (NSString *)offlineApiVersion {
    return @"";
}

- (NSString *)onlineApiVersion {
    return @"";
}

- (NSString *)offlinePublicKey {
    return nil;
}

- (NSString *)onlinePublicKey {
    return nil;
}

- (NSString *)offlinePrivateKey {
    return nil;
}

- (NSString *)onlinePrivateKey {
    return nil;
}

@end
