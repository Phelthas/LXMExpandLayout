//
//  LXMExpandLayout.m
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/27.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "LXMExpandLayout.h"
#import "LXMCopiedView.h"


@interface LXMExpandLayout ()<UIGestureRecognizerDelegate>

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

//手势相关
@property (nonatomic, assign) BOOL isGestureSetted;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) LXMCopiedView *fakeCellView;


@end

@implementation LXMExpandLayout


- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfItemsInRow = 1;//这里必须不能是0，否则下面会出现0/0的bug
        self.seletedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    //这个方法是在viewDidLayoutSubview之后调用的，所以这时候collectionView的大小才是正确的
    self.itemWidth = self.itemSize.width;
    self.itemHeight = self.itemSize.height;
    self.collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    self.numberOfItemsInRow = [[super layoutAttributesForElementsInRect:CGRectMake(0, 0, self.collectionViewWidth - self.sectionInset.left - self.sectionInset.right, self.itemHeight)] count];//取出按默认位置一行应该有几个item
    if (self.numberOfItemsInRow <= 3) {
        self.numberOfItemsInRow = 3;//这里必须加这一句判断，否则当cell个数小于3时会出问题
    }
    self.padding = (self.collectionViewWidth - self.itemWidth * self.numberOfItemsInRow - self.sectionInset.left - self.sectionInset.right) / (self.numberOfItemsInRow - 1);
    self.expandedItemWidth = self.collectionViewWidth - self.itemWidth - self.padding - self.sectionInset.left - self.sectionInset.right;
    self.expandedFactor = self.expandedItemWidth / self.itemWidth;
    self.expandedItemHeight = self.itemHeight * self.expandedFactor;
    
    [self setupGesture];
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if ([self.collectionView numberOfItemsInSection:0] == 0) {
        return nil;
    }
    //因为每次layout的时候这两个属性都会变，所以写在这里
    UICollectionViewLayoutAttributes *selectedAttributes = [super layoutAttributesForItemAtIndexPath:self.seletedIndexPath];
    self.selectedItemOriginalY = selectedAttributes.frame.origin.y;//取出selectedItem没放大时的y位置
    self.sameRowItemArray = [super layoutAttributesForElementsInRect:CGRectMake(0, selectedAttributes.frame.origin.y, self.collectionViewWidth - self.sectionInset.left - self.sectionInset.right, self.itemHeight)];//取出跟selectedItem同一行的items
    BOOL shouldExpandToLeft = [self shouldItemExpandToLeftWithAttributes:selectedAttributes];//这个是根据selectedItem变的
    
    //修改每个item的UICollectionViewLayoutAttributes
    CGRect newRect = rect;
    newRect.origin.y = newRect.origin.y - CGRectGetHeight(self.collectionView.bounds);
    newRect.size.height += CGRectGetHeight(self.collectionView.bounds) * 2;
    NSArray *originalArray = [super layoutAttributesForElementsInRect:newRect];//因为要改变item的大小，会导致rect比默认的rect要大，所以这里要相应扩大计算范围，否则会出现显示不全的问题
    CGFloat heightPadding = (self.expandedItemHeight - self.itemHeight * (self.numberOfItemsInRow - 1)) / (self.numberOfItemsInRow - 2);
   
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in originalArray) {
        if (attributes.frame.origin.x + self.itemWidth >= self.collectionViewWidth) {
            //UICollectionViewFlowLayout 的一个bug，originalArray的个数会比cell的总个数还多，参考http://stackoverflow.com/questions/12927027/uicollectionview-flowlayout-not-wrapping-cells-correctly-ios/13389461#13389461
        } else {
            [resultArray addObject:attributes];
        }
    }

    for (UICollectionViewLayoutAttributes *attributes in resultArray) {
        
        if (attributes.indexPath.item == self.seletedIndexPath.item &&
            attributes.indexPath.section == self.seletedIndexPath.section) {
            //被选中的item
            attributes.bounds = CGRectMake(0, 0, self.expandedItemWidth, self.expandedItemHeight);
            if (shouldExpandToLeft) {
                attributes.center = CGPointMake(attributes.center.x + self.expandedItemWidth / 2 - attributes.center.x + self.sectionInset.left, attributes.center.y + self.expandedItemHeight / 2 - self.itemHeight / 2);
                
            } else {
                attributes.center = CGPointMake(attributes.center.x + (self.collectionViewWidth - self.expandedItemWidth / 2) - attributes.center.x - self.sectionInset.right, attributes.center.y + self.expandedItemHeight / 2 - self.itemHeight / 2);
            }
        } else if ([self isItemInTheSelectedIndexPathRowWithUICollectionViewLayoutAttributes:attributes]) {
            //与选中item同一行的item，竖直排列在选中item的旁边
            if (shouldExpandToLeft) {
                attributes.frame = CGRectMake(self.collectionViewWidth - self.itemWidth - self.sectionInset.right, self.selectedItemOriginalY, self.itemWidth, self.itemHeight);
                self.selectedItemOriginalY += (self.itemHeight + heightPadding);
            } else {
                attributes.frame = CGRectMake(self.sectionInset.left, self.selectedItemOriginalY, self.itemWidth, self.itemHeight);
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

- (void)setupGesture {
    if (self.isGestureSetted == NO) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _longPressGesture.delegate = self;
        [self.collectionView addGestureRecognizer:_longPressGesture];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.delegate = self;
        [self.collectionView addGestureRecognizer:_panGesture];
        
        self.isGestureSetted = YES;
    }
}


- (void)moveItemIfNeeded {
    NSIndexPath *atIndexPath = self.fakeCellView.indexPath;
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:self.fakeCellView.center];
    if (toIndexPath == nil || [toIndexPath isEqual:atIndexPath]) {
        NSLog(@"return le");
        return;
    }
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if (self.longPressGesture.state == UIGestureRecognizerStatePossible ||
            self.longPressGesture.state == UIGestureRecognizerStateFailed) {
            //如果长按手势没有识别处理，则pan手势不能执行
            return NO;
        }
    } else if (gestureRecognizer == self.longPressGesture) {
        if (self.collectionView.panGestureRecognizer.state != UIGestureRecognizerStatePossible &&
            self.collectionView.panGestureRecognizer.state !=UIGestureRecognizerStateFailed) {
            //如果系统的pan手势识别出来了，则长按手势不应该被执行
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:self.panGesture]
        && [otherGestureRecognizer isEqual:self.longPressGesture]) {
        return YES;
    } else if ([gestureRecognizer isEqual:self.longPressGesture]
               && [otherGestureRecognizer isEqual:self.panGesture]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - gestureAction

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
   
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        CGPoint loaction = [sender locationInView:self.collectionView];
        NSIndexPath *longPressedIndexPath = [self.collectionView indexPathForItemAtPoint:loaction];
        if (longPressedIndexPath) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:longPressedIndexPath];
            self.fakeCellView = [[LXMCopiedView alloc] initWithTargetView:cell andIndexPath:longPressedIndexPath];
            [self.collectionView addSubview:self.fakeCellView];
//            [self invalidateLayout];//这句是干什么用的？
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                self.fakeCellView.bounds = CGRectMake(0, 0, self.itemWidth * 1.1, self.itemHeight * 1.1);
            } completion:^(BOOL finished) {
                
            }];
            
            
        } else {
            return;//当前位置没有cell
        }
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self.fakeCellView removeFromSuperview];
        self.fakeCellView = nil;
    } else {

    }
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.collectionView];
        self.fakeCellView.center = CGPointMake(self.fakeCellView.originalCenter.x + translation.x, self.fakeCellView.originalCenter.y + translation.y);
        
    }
    
    
}

@end








#pragma mark - UICollectionView 扩展

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
