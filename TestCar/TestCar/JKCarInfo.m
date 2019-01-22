//
//  JKCarInfo.m
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "JKCarInfo.h"

@implementation JKCarInfo

- (instancetype)initWithCarIdentifier:(NSString *)identifier distance:(double)distance duration:(NSTimeInterval)duration {
    if (self = [super init]) {
        _identifier = identifier;
        _distance = distance;
        _duration = duration;
    }
    
    return self;
}

- (double)averageVelocity {
    return self.distance / (self.duration / 60 / 60);
}

@end
