//
//  LXMExpandLayout.m
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/27.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMExpandLayout.h"


@interface LXMExpandLayout ()

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat expandedItemWidth;
@property (nonatomic, assign) CGFloat expandedItemHeight;
@property (nonatomic, assign) CGFloat expandedFactor;
@property (nonatomic, assign) CGFloat collectionViewWidth;

@property (nonatomic, assign) CGFloat selectedItemOriginalY;
@property (nonatomic, assign) CGFloat padding;//item 之间的间隔
@property (nonatomic, assign) NSInteger numberOfItemsInRow;

@property (nonatomic, strong) NSArray *sameRowItemArray;

@end

@implementation LXMExpandLayout


- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfItemsInRow = 1;//这里必须不能是0，否则下面会出现0/0的bug
        self.seletedIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    //这个方法是在viewDidLayoutSubview之后调用的，所以这时候collectionView的大小才是正确的
    self.itemWidth = self.itemSize.width;
    self.itemHeight = self.itemSize.height;
    self.collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    self.numberOfItemsInRow = [[super layoutAttributesForElementsInRect:CGRectMake(0, 0, self.collectionViewWidth, self.itemHeight)] count];//取出按默认位置一行应该有几个item
    self.padding = (self.collectionViewWidth - self.itemWidth * self.numberOfItemsInRow) / (self.numberOfItemsInRow - 1);
    self.expandedItemWidth = self.collectionViewWidth - self.itemWidth - self.padding;
    self.expandedFactor = self.expandedItemWidth / self.itemWidth;
    self.expandedItemHeight = self.itemHeight * self.expandedFactor;
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //因为每次layout的时候这两个属性都会变，所以写在这里
    UICollectionViewLayoutAttributes *selectedAttributes = [self layoutAttributesForItemAtIndexPath:self.seletedIndexPath];
    self.selectedItemOriginalY = selectedAttributes.frame.origin.y;//取出selectedItem没放大时的y位置
    self.sameRowItemArray = [super layoutAttributesForElementsInRect:CGRectMake(0, selectedAttributes.frame.origin.y, self.collectionViewWidth, self.itemHeight)];//取出跟selectedItem同一行的items
    BOOL shouldExpandToLeft = [self shouldItemExpandToLeftWithAttributes:selectedAttributes];//这个是根据selectedItem变的
    
    //修改每个item的UICollectionViewLayoutAttributes
    CGRect newRect = rect;
    newRect.origin.y = newRect.origin.y - CGRectGetHeight(self.collectionView.bounds);
    newRect.size.height += CGRectGetHeight(self.collectionView.bounds) * 2;
//    newRect = CGRectMake(0, 0, self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    NSArray *resultArray = [super layoutAttributesForElementsInRect:newRect];//因为要改变item的大小，会导致rect比默认的rect要大，所以这里要相应扩大计算范围，否则会出现显示不全的问题
    CGFloat heightPadding = (self.expandedItemHeight - self.itemHeight * (self.numberOfItemsInRow - 1)) / (self.numberOfItemsInRow - 2);
    

    for (UICollectionViewLayoutAttributes *attributes in resultArray) {
        
        if (attributes.indexPath.item == self.seletedIndexPath.item &&
            attributes.indexPath.section == self.seletedIndexPath.section) {
            //被选中的item
            if (shouldExpandToLeft) {
                attributes.transform = CGAffineTransformMakeTranslation(self.expandedItemWidth / 2 - attributes.center.x, self.expandedItemHeight / 2 - self.itemHeight / 2);//平移到中心位置
                attributes.transform = CGAffineTransformScale(attributes.transform, self.expandedFactor, self.expandedFactor);//放大
            } else {
                attributes.transform = CGAffineTransformMakeTranslation((self.collectionViewWidth - self.expandedItemWidth / 2) - attributes.center.x, self.expandedItemHeight / 2 - self.itemHeight / 2);//平移到中心位置
                attributes.transform = CGAffineTransformScale(attributes.transform, self.expandedFactor, self.expandedFactor);//放大
            }
            
        } else if ([self isItemInTheSelectedIndexPathRowWithUICollectionViewLayoutAttributes:attributes]) {
            //与选中item同一行的item，竖直排列在选中item的旁边
            if (shouldExpandToLeft) {
                attributes.frame = CGRectMake(self.collectionViewWidth - self.itemWidth, self.selectedItemOriginalY, self.itemWidth, self.itemHeight);
                self.selectedItemOriginalY += (self.itemHeight + heightPadding);
            } else {
                attributes.frame = CGRectMake(0, self.selectedItemOriginalY, self.itemWidth, self.itemHeight);
                self.selectedItemOriginalY += (self.itemHeight + heightPadding);
            }
            
            
        } else if (attributes.indexPath.section == self.seletedIndexPath.section
                    && attributes.indexPath.item > self.seletedIndexPath.item) {
            //选中item那一行之后的item，向下平移扩展的距离
            CGRect newFrame = attributes.frame;
            newFrame.origin.y += (self.expandedItemHeight - self.itemHeight);
            attributes.frame = newFrame;
        } else {
            //选中item那一行之前的item，不用修改
        }
        
    }
    
    return resultArray;
}

- (CGSize)collectionViewContentSize {
    CGSize newSize = [super collectionViewContentSize];
    newSize.height += (self.expandedItemHeight - self.itemHeight);
    return newSize;
}


#pragma mark - publicMethod



#pragma mark - privateMethod

- (BOOL)isItemInTheSelectedIndexPathRowWithUICollectionViewLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
    BOOL result = NO;
    for (UICollectionViewLayoutAttributes *tempAttributes in self.sameRowItemArray) {
        if (tempAttributes.indexPath.row == attributes.indexPath.row
            && tempAttributes.indexPath.section == attributes.indexPath.section) {
            result = YES;
            break;
        }
    }
    return result;
}

- (BOOL)shouldItemExpandToLeftWithAttributes:(UICollectionViewLayoutAttributes *)attributes {
    BOOL result = YES;
    NSInteger index = attributes.indexPath.item % self.numberOfItemsInRow;
    NSInteger centerIndex = ceilf(self.numberOfItemsInRow / 2.0);
    if (index >= centerIndex) {
        result = NO;
    }
    return result;
}

@end
