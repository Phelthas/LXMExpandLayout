//
//  UICollectionView+LXMExpandLayout.m
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/28.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "UICollectionView+LXMExpandLayout.h"
#import "LXMExpandLayout.h"

@implementation UICollectionView (LXMExpandLayout)

- (void)expandItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    LXMExpandLayout *layout = (LXMExpandLayout *)self.collectionViewLayout;
    if (animated) {
        //用UIView Animation 包住performBatchUpdates可以使view的Animation代替collectionView默认的动画
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self performBatchUpdates:^{
                layout.seletedIndexPath = indexPath;
            } completion:^(BOOL finished) {
                
            }];
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        layout.seletedIndexPath = indexPath;
        [layout invalidateLayout];
    }
}


@end
