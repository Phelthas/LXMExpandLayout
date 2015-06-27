//
//  LXMCopiedView.m
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/6/26.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMCopiedView.h"

@interface LXMCopiedView ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation LXMCopiedView

- (instancetype)initWithTargetView:(UIView *)aView andIndexPath:(NSIndexPath *)indexPath {
    self = [super initWithFrame:aView.frame];
    if (self) {
        _indexPath = indexPath;
        _originalCenter = aView.center;
        
        _imageView = [[UIImageView alloc] initWithFrame:aView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.image = [UIImage imageFromTargetView:aView];
        [self addSubview:_imageView];
    }
    return self;
}


@end


@implementation UIImage (LXMCopiedView)

+ (UIImage *)imageFromTargetView:(UIView *)aView {
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, NO, 0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

