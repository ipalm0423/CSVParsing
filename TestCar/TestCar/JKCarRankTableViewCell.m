//
//  JKCarRankTableViewCell.m
//  TestCar
//
//  Created by Jack on 2019/1/16.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "JKCarRankTableViewCell.h"

@interface JKCarRankTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@end

@implementation JKCarRankTableViewCell

+ (NSString *)identifier {
    return @"JKCarRankTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithFourTitles:(NSArray<NSString *> *)titles {
    if (!titles) {
        return;
    }
    
    self.firstLabel.text = [titles objectAtIndex:0];
    self.secondLabel.text = [titles objectAtIndex:1];
    self.thirdLabel.text = [titles objectAtIndex:2];
    self.fourLabel.text = [titles objectAtIndex:3];
}

@end
