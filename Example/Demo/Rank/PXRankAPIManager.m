//
//  PXRankAPIManager.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXRankAPIManager.h"

@interface PXRankAPIManager () <PXAPIManagerValidator> {
    // 当前页数
    NSInteger _pageNumber;
    // 总页数
    NSInteger _pageCount;
}

@end

@implementation PXRankAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.validator = self;
        _pageNumber = 1;
    }
    return self;
}

/**
 @return 返回接口名称
 */
- (NSString *)methodName {
    return @"top/item-list";
}


/**
 @return 返回请求方式
 */
- (PXAPIManagerRequestType)requestType {
    return PXAPIManagerRequestTypePost;
}


/**
 @return 返回域名信息
 */
- (NSString *)serviceType {
    return into;
}

/**
 @return 是否缓存   暂时没有持久层
 */
- (BOOL)shouldCache {
    return NO;
}

/**
 此方法做返回数据的验证，比如页码是否符合，数据是否符合要求等。

 @param manager APIManager 本身
 @param data 数据
 @return 返回结果，YES为请求成功，NO为请求失败
 */
- (BOOL)manager:(PXAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    _pageCount = [data[@"page"][@"page_count"] integerValue];
    if (_pageNumber > _pageCount) {
        return NO;
    }
    return YES;
}

- (BOOL)manager:(PXAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}


/**
 此方法用于存放共有参数，比如定位参数，页码参数等

 @param params 业务层传进来的请求参数
 @return 返回总参数
 */
- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    dictionary[@"page"] = @(_pageNumber);
    return dictionary;
}

/**
 下拉刷新
 */
- (void)refreshData {
    _pageNumber = 1;
    [self loadData];
}

/**
 上拉加载更多
 */
- (void)loadMoreData {
    _pageNumber ++;
    [self loadData];
}

@end
