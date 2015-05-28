//
//  UICollectionView+LXMExpandLayout.h
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/28.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (LXMExpandLayout)

- (void)expandItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end
