//
//  PXService.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/11.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXService.h"

@implementation PXService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(PXServiceProtocol)]) {
            self.child = (id<PXServiceProtocol>)self;
            NSLog(@"%@", self.child.onlineApiBaseUrl);
        }
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)privateKey
{
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey
{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

@end
