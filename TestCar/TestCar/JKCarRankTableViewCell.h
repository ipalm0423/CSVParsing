//
//  JKCarRankTableViewCell.h
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKCarRankTableViewCell : UITableViewCell
+ (NSString *)identifier;

- (void)updateWithFourTitles:(NSArray<NSString *> *)titles;
@end

NS_ASSUME_NONNULL_END
