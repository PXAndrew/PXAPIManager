//
//  PXServiceFactory.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/12.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXServiceFactory.h"
#import "PXWOWlifeService.h"

/*************************************************************************/

// service name list
NSString *const into = @"into";

@interface PXServiceFactory ()

@property (strong, nonatomic) NSMutableDictionary *serviceStorage;

@end

@implementation PXServiceFactory

+ (instancetype)sharedInstance {
    static PXServiceFactory *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PXServiceFactory alloc] init];
    });
    return instance;
}

#pragma mark - public methods
- (PXService<PXServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (PXService<PXServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    NSLog(@"%@", identifier);
    if ([identifier isEqualToString:into]) {
        return [[PXWOWlifeService alloc] init];
    }
    return nil;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = [NSMutableDictionary dictionary];
    }
    return _serviceStorage;
}

@end
