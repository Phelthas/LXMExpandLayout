//
//  LXMExpandLayout.h
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/27.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXMExpandLayout;

@protocol LXMExpandLayoutDelegate <NSObject>

- (void)lxmExpandLayout:(LXMExpandLayout *)layout didMoveItemAtIndexPath:(NSIndexPath *)atIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end


@interface LXMExpandLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *seletedIndexPath;
@property (nonatomic, assign) id<LXMExpandLayoutDelegate> delegate;

@end



@interface UICollectionView (LXMExpandLayout)

- (void)expandItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end