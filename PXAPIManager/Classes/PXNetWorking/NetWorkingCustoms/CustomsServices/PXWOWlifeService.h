//
//  PXWOWlifeService.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/12.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXService.h"

@interface PXWOWlifeService : PXService <PXServiceProtocol>

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@property (nonatomic, readonly) NSString *onlinePublicKey;
@property (nonatomic, readonly) NSString *offlinePublicKey;

@property (nonatomic, readonly) NSString *onlinePrivateKey;
@property (nonatomic, readonly) NSString *offlinePrivateKey;

@end
