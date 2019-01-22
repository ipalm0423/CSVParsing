//
//  CarInfoManager.m
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "JKCarInfoManager.h"
#import "JKCarInfo.h"

static int const kChunkSize = 2048;
static NSInteger const kMaxRankCount = 100;

@interface JKCarInfoManager() <NSStreamDelegate>
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray<JKCarInfo *> *carInfos;
@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSMutableString *rawString;
@property (copy, nonatomic) void (^fetchCompletion)(BOOL);
@end

@implementation JKCarInfoManager

- (instancetype)initWithFileName:(NSString *)fileName {
    if (self = [super init]) {
        _fileName = fileName;
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    return self;
}

- (NSUInteger)count {
    return self.carInfos.count;
}

- (JKCarInfo *)infoForIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self.carInfos objectAtIndex:index];
    }
    return nil;
}

- (void)fetchWithCompletion:(void (^)(BOOL))completion {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        self.fetchCompletion = completion;
        [self loadAndParseWithFileName:self.fileName];
    });
}

- (void)addRankToCarInfo {
    for (NSInteger i = 0; i < self.carInfos.count; i++) {
        JKCarInfo *info = [self.carInfos objectAtIndex:i];
        info.rank = i;
    }
}

#pragma mark - CSV Parsing

- (void)loadAndParseWithFileName:(NSString *)fileName {
    if (fileName.length == 0) {
        return;
    }
    
    NSArray *pathFragments = [fileName componentsSeparatedByString:@"."];
    NSString *path = pathFragments[0];
    NSString *type = pathFragments[1];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:path ofType:type];
    
    [self.inputStream close];
    self.inputStream = [NSInputStream inputStreamWithFileAtPath:fullPath];
    self.inputStream.delegate = self;
    [self.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
}

- (void)parsingModelsFromRawString:(NSString *)rawString {
    if (self.rawString) {
        [self.rawString appendString:rawString];
        
    } else {
        self.rawString = [rawString mutableCopy];
    }
    
    NSRange range = [self.rawString rangeOfString:@"\n" options:NSBackwardsSearch];
    NSString *stringToParse = [self.rawString substringToIndex:range.location];
    self.rawString = [[self.rawString substringFromIndex:range.location] mutableCopy];
    
    NSArray *rawData = [stringToParse componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < rawData.count; i++) {
        NSString *rawString = [NSString stringWithFormat:@"%@", rawData[i]];
        NSArray *singleRow = [rawString componentsSeparatedByString:@","];
        if (singleRow.count < 7) {
            continue;
        }
        
        double distance = [singleRow[6] doubleValue];
        BOOL isEnd = [singleRow[7] boolValue];
        
        if (isEnd == NO || distance < 30.0) {
            continue;
        }
        
        NSDate *startDate = [self.dateFormatter dateFromString:singleRow[2]];
        NSDate *endDate = [self.dateFormatter dateFromString:singleRow[4]];
        NSTimeInterval duration = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970;
        
        JKCarInfo *info = [[JKCarInfo alloc] initWithCarIdentifier:singleRow[0] distance:distance duration:duration];
        
        [self appendInfoIfNeeded:info];
    }
}

- (void)appendInfoIfNeeded:(JKCarInfo *)info {
    if (self.carInfos == nil) {
        self.carInfos = [NSMutableArray arrayWithObject:info];
        
        return;
    }
    
    NSUInteger indexToInsert = [self binarySearchInfoWithIndexI:0 j:self.carInfos.count velocity:info.averageVelocity];
    if (indexToInsert < kMaxRankCount) {
        [self.carInfos insertObject:info atIndex:indexToInsert];
    }
}


- (NSUInteger)binarySearchInfoWithIndexI:(NSUInteger)i j:(NSUInteger)j velocity:(double)velocity {
    if (i == j) {
        return i;
        
    }
    
    NSUInteger mid = (i + j) / 2;
    double vMid = self.carInfos[mid].averageVelocity;
    
    if (vMid == velocity) {
        return mid;
        
    } else if (vMid < velocity) {
        return [self binarySearchInfoWithIndexI:i j:mid velocity:velocity];
        
    } else {
        return [self binarySearchInfoWithIndexI:(mid + 1) j:j velocity:velocity];
    }
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventErrorOccurred: {
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.fetchCompletion) {
                    self.fetchCompletion(NO);
                }
            });
        } break;
            
        case NSStreamEventHasBytesAvailable: {
            NSMutableData *data = [NSMutableData data];
            uint8_t buf[kChunkSize];
            NSInteger len = [(NSInputStream *)aStream read:buf maxLength:kChunkSize];
            if (len) {
                [data appendBytes:(const void *)buf length:len];
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", str);
                
                [self parsingModelsFromRawString:str];
            } else {
                NSLog(@"no buffer");
            }
        } break;
            
        case NSStreamEventHasSpaceAvailable: {
            
        } break;
            
        case NSStreamEventEndEncountered:{
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [self addRankToCarInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.fetchCompletion) {
                    self.fetchCompletion(YES);
                }
            });
        } break;
            
        default:
            break;
    }
}

@end
