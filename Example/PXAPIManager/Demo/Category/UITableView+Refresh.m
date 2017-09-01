//
//  UITableView+Refresh.m
//  NetWork
//
//  Created by Andrew on 2017/5/21.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "UITableView+Refresh.h"
#import <MJRefresh/MJRefresh.h>

@implementation UITableView (Refresh)

/**
 添加下拉刷新
 */
- (void)addTopRefreshWithTarget:(id)target selector:(SEL)action {
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    refreshHeader.lastUpdatedTimeLabel.hidden = NO;
    refreshHeader.stateLabel.hidden = NO;
    self.mj_header = refreshHeader;
}


/**
 添加加载更多
 */
- (void)addFootRefreshWithTarget:(id)target selector:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    self.mj_footer = footer;
}

@end
