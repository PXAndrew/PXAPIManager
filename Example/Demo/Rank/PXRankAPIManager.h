//
//  PXRankAPIManager.h
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXAPIBaseManager.h"

@interface PXRankAPIManager : PXAPIBaseManager <PXAPIManager>

- (void)refreshData;

- (void)loadMoreData;

@end
