//
//  PXNearTableViewController.m
//  NetWork
//
//  Created by Andrew-S-Loptop on 2017/4/18.
//  Copyright © 2017年 shanghaiwow. All rights reserved.
//

#import "PXNearTableViewController.h"
#import "PXNearAPIMangager.h"
#import "PXTestTableViewCellReformer.h"
#import "PXTestTableViewCell.h"
#import "Masonry.h"

@interface PXNearTableViewController () <PXAPIManagerParamSource, PXAPIManagerCallBackDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PXNearAPIMangager *APIManager;

@property (strong, nonatomic) PXTestTableViewCellReformer *reformer;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PXNearTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"附近";
    [self.view addSubview:self.tableView];
    [self.APIManager loadData];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - APIManagerParamSource
- (NSDictionary *)paramsForApi:(PXAPIBaseManager *)manager {
    return @{@"class" : @"美食"};
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(PXAPIBaseManager *)manager {
    if (manager == self.APIManager) {
        self.dataArray = [manager fetchDataWithReformer:self.reformer];
        [self.tableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(PXAPIBaseManager *)manager {
    if (manager == self.APIManager) {
        [manager fetchDataWithReformer:nil];
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
    static NSString *cellID = @"TestTableViewCellID";
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
    }
    return _tableView;
}

- (PXNearAPIMangager *)APIManager {
    if (!_APIManager) {
        _APIManager = [[PXNearAPIMangager alloc] init];
        _APIManager.delegate = self;
        _APIManager.paramSource = self;
    }
    return _APIManager;
}

- (PXTestTableViewCellReformer *)reformer {
    if (!_reformer) {
        _reformer = [[PXTestTableViewCellReformer alloc] init];
    }
    return _reformer;
}



@end
