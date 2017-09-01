//
//  UITableView+Refresh.h
//  NetWork
//
//  Created by Andrew on 2017/5/21.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Refresh)

- (void)addTopRefreshWithTarget:(id)target selector:(SEL)action;

- (void)addFootRefreshWithTarget:(id)target selector:(SEL)action;

@end
