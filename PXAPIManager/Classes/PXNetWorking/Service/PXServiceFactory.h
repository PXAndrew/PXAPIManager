//
//  PXServiceFactory.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/12.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXService.h"

@interface PXServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (PXService<PXServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
