//
//  NSObject+NetWorkingMethods.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/17.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "NSObject+NetWorkingMethods.h"

@implementation NSObject (NetWorkingMethods)

- (id)PX_defaultValue:(id)defaultData {
    
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)isEmptyObject {
    
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
