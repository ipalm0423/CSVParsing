//
//  JKCarInfo.h
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKCarInfo : NSObject
@property (assign, nonatomic) NSUInteger rank;
@property (copy, nonatomic, readonly) NSString *identifier;
@property (assign, nonatomic, readonly) double distance;
@property (assign, nonatomic, readonly) double averageVelocity;
@property (assign, nonatomic, readonly) NSTimeInterval duration;


- (instancetype)initWithCarIdentifier:(NSString *)identifier distance:(double)distance duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
