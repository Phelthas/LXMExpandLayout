//
//  TESTCollectionViewCell.m
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/27.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "TESTCollectionViewCell.h"

NSString * const TESTCollectionViewCellIdentifier = @"TESTCollectionViewCellIdentifier";


@implementation TESTCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor orangeColor];
    self.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.borderWidth = 1;
}

@end
