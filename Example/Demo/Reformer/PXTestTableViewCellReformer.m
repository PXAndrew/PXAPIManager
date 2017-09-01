//
//  PXTestTableViewCellReformer.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXTestTableViewCellReformer.h"

NSString * const kTestReformerItemID = @"kTestReformerItemID";
NSString * const kTestReformerImage = @"kTestReformerImage";
NSString * const kTestReformerTitle = @"kTestReformerTitle";
NSString * const kTestReformerMerchantName = @"kTestReformerMerchantName";

@implementation PXTestTableViewCellReformer

- (id)manager:(PXAPIBaseManager *)manager reformData:(NSDictionary *)data {

    NSMutableArray *dataArray = [NSMutableArray array];
    if ([manager isKindOfClass:NSClassFromString(@"PXRankAPIManager")]) {
        for (NSDictionary *dict in data[@"rows"]) {
            NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
            resDict[kTestReformerItemID] = dict[@"item_id"];
            resDict[kTestReformerImage] = dict[@"image"];
            resDict[kTestReformerTitle] = dict[@"title"];
            resDict[kTestReformerMerchantName] = dict[@"merchant_name"];
            [dataArray addObject:resDict];
        }
    }
    if ([manager isKindOfClass:NSClassFromString(@"PXNearAPIMangager")]) {
        for (NSDictionary *dict in data[@"rows"]) {
            NSMutableDictionary *resDict = [NSMutableDictionary dictionary];
            resDict[kTestReformerItemID] = dict[@"item_id"];
            resDict[kTestReformerImage] = dict[@"image"];
            resDict[kTestReformerTitle] = dict[@"title"];
            resDict[kTestReformerMerchantName] = dict[@"venue"];
            [dataArray addObject:resDict];
        }
    }
    return dataArray;
}

@end
