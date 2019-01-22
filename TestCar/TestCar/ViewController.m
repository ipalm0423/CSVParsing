//
//  ViewController.m
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "ViewController.h"
#import "JKCarRankTableViewCell.h"
#import "JKCarInfoManager.h"
#import "JKCarRankTableViewCellHelper.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) NSMutableDictionary *cellHelpers;
@property (strong, nonatomic) JKCarInfoManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchDatas];
}

- (void)fetchDatas {
    if (self.manager == nil) {
        self.manager = [[JKCarInfoManager alloc] initWithFileName:@"20170201_head_50k.csv"];
    }
    
    [self animateIndicatorView:YES];
    __weak typeof(self) weakSelf = self;
    [self.manager fetchWithCompletion:^(BOOL success) {
        [weakSelf animateIndicatorView:NO];
        if (success) {
            weakSelf.cellHelpers = [NSMutableDictionary dictionary];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)animateIndicatorView:(BOOL)animte {
    self.indicatorView.hidden = !animte;
    if (animte) {
        [self.indicatorView startAnimating];
    } else {
        [self.indicatorView stopAnimating];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    JKCarRankTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:JKCarRankTableViewCell.identifier forIndexPath:indexPath];
    JKCarInfo *info = [self.manager infoForIndex:indexPath.row];
    JKCarRankTableViewCellHelper *helper = [[JKCarRankTableViewCellHelper alloc] initWithCarInfo:info];
    self.cellHelpers[@(indexPath.row)] = helper;
    helper.view = cell;
    
    return cell;
}


@end
