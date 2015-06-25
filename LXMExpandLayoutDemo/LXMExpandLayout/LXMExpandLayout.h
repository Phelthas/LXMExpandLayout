//
//  LXMExpandLayout.h
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/27.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXMExpandLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *seletedIndexPath;

@end



@interface UICollectionView (LXMExpandLayout)

- (void)expandItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end