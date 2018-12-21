//
//  WeekDayCollectionViewCell.m
//  AddClockViewDemo
//
//  Created by hoyifo on 2018/12/21.
//  Copyright © 2018 hoyifo. All rights reserved.
//

#import "WeekDayCollectionViewCell.h"
@interface WeekDayCollectionViewCell ()

@property (nonatomic, strong) UIView *spreatView;

@end
@implementation WeekDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self creatTitleLabel];
    }
    return self;
}


- (void)creatTitleLabel {
    self.titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 1, self.bounds.size.height)];
    self.titileLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titileLabel];
    self.titileLabel.textColor = [UIColor whiteColor];
    self.spreatView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 1, 7, 1, self.bounds.size.height - 14)];
    self.spreatView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.spreatView];
    
}

- (void)setData:(NSString *)data {
    _data = data;
    self.titileLabel.text = self.data;
    if ([self.data isEqualToString:@"周日"]) {
        [self.spreatView removeFromSuperview];
        self.titileLabel.frame = self.bounds;
    }
}

















@end
