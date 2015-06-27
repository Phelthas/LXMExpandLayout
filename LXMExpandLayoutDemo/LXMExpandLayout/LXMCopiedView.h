//
//  LXMCopiedView.h
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/6/26.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXMCopiedView : UIView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, assign) CGPoint originalCenter;

- (instancetype)initWithTargetView:(UIView *)aView andIndexPath:(NSIndexPath *)indexPath;

@end





@interface UIImage (LXMCopiedView)

+ (UIImage *)imageFromTargetView:(UIView *)aView;

@end