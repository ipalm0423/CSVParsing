//
//  JKCarRankTableViewCellHelper.m
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "JKCarRankTableViewCellHelper.h"
#import "JKCarInfo.h"
#import "JKCarRankTableViewCell.h"

@interface JKCarRankTableViewCellHelper()
@property (strong, nonatomic, readonly) JKCarInfo *info;
@end

@implementation JKCarRankTableViewCellHelper

- (instancetype)initWithCarInfo:(JKCarInfo *)info {
    if (self = [super init]) {
        _info = info;
    }
    
    return self;
}

- (void)setView:(JKCarRankTableViewCell *)view {
    _view = view;
    
    if (_view) {
        NSString *rank = [NSString stringWithFormat:@"Rank:%@", @(self.info.rank)];
        NSString *carID = [NSString stringWithFormat:@"ID:%@", self.info.identifier];
        NSString *distance = [NSString stringWithFormat:@"Distance:%@", @(self.info.distance)];
        NSString *velocity = [NSString stringWithFormat:@"Velocity:%@", @(self.info.averageVelocity)];
        
        
        [_view updateWithFourTitles:@[rank, carID, distance, velocity]];
    }
}

@end
