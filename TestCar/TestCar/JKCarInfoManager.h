//
//  CarInfoManager.h
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKCarInfo;

@interface JKCarInfoManager : NSObject
@property (copy, nonatomic, readonly) NSString *fileName;

- (instancetype)initWithFileName:(NSString *)fileName;
- (NSUInteger)count;
- (JKCarInfo *)infoForIndex:(NSUInteger)index;
- (void)fetchWithCompletion:(void(^)(BOOL success))completion;
@end

