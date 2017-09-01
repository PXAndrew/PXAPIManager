//
//  PXRequestGenerator.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/11.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXRequestGenerator : NSObject

+ (instancetype)sharedInstance;

/// get request
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
/// post request
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
