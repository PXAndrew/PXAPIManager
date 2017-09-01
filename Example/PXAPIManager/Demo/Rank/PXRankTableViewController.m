//
//  PXRankTableViewController.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXRankTableViewController.h"
#import "PXRankAPIManager.h"
#import "PXTestTableViewCellReformer.h"
#import "PXTestTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UITableView+Refresh.h"
#import <MJRefresh/MJRefresh.h>
#import "PXLocationManager.h"
#import "PXNearTableViewController.h"


@interface PXRankTableViewController () <PXAPIManagerParamSource, PXAPIManagerCallBackDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArray;

/**
 APIManager
 */
@property (strong, nonatomic) PXRankAPIManager *apiManager;

/**
 适配器
 */
@property (strong, nonatomic) PXTestTableViewCellReformer *reformer;

/**
 tableView
 */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PXRankTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.apiManager loadData];
    
    [self setNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)setNavigationBar {
    self.navigationItem.title = @"排行";
    UIBarButtonItem *nearItem = [[UIBarButtonItem alloc] initWithTitle:@"NEAR" style:UIBarButtonItemStylePlain target:self action:@selector(pushNear)];
    self.navigationItem.rightBarButtonItem = nearItem;
}

#pragma mark - ButtonDidTap
- (void)pushNear {
    PXNearTableViewController *viewController = [[PXNearTableViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - PXAPIManagerParamSource
- (NSDictionary *)paramsForApi:(PXAPIBaseManager *)manager {
    return @{
             @"class" : @"美食"
             };
}

#pragma mark - PXAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(PXAPIBaseManager *)manager {
    if (manager == self.apiManager) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataArray removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        NSArray *array = [manager fetchDataWithReformer:self.reformer];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(PXAPIBaseManager *)manager {
    if (manager == self.apiManager) {
        if (self.apiManager.response.status == PXURLResponseStatusErrorNoNetwork) {
            NSLog(@"无网络");
        }
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TestTableViewCell";
    PXTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PXTestTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PXTestTableViewCell *testCell = (PXTestTableViewCell *)cell;
    testCell.model = self.dataArray[indexPath.row];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPatho {
    return UITableViewAutomaticDimension;
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 80;
        [_tableView addTopRefreshWithTarget:self.apiManager selector:@selector(refreshData)];
        [_tableView addFootRefreshWithTarget:self.apiManager selector:@selector(loadMoreData)];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (PXRankAPIManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[PXRankAPIManager alloc] init];
        _apiManager.paramSource = self;
        _apiManager.delegate = self;
    }
    return _apiManager;
}

- (PXTestTableViewCellReformer *)reformer {
    if (!_reformer) {
        _reformer = [[PXTestTableViewCellReformer alloc] init];
    }
    return _reformer;
}

@end
