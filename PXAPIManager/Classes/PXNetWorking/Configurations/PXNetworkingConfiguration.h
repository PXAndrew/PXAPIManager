//
//  PXNetworkingConfiguration.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/13.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#ifndef NetworkingConfiguration_h
#define NetworkingConfiguration_h

typedef NS_ENUM(NSUInteger, PXURLResponseStatus)
{
    PXURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的APIBaseManager来决定。
    PXURLResponseStatusErrorTimeout,
    PXURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kNetworkingTimeoutSeconds = 20.0f;
static BOOL kShouldCache = YES;


// services
extern NSString *const into;

#endif /* NetworkingConfiguration_h */
