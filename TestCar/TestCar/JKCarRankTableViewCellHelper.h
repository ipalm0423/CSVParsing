//
//  JKCarRankTableViewCellHelper.h
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JKCarInfo, JKCarRankTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@interface JKCarRankTableViewCellHelper : NSObject
@property (weak, nonatomic) JKCarRankTableViewCell *view;
- (instancetype)initWithCarInfo:(JKCarInfo *)info;

@end

NS_ASSUME_NONNULL_END
