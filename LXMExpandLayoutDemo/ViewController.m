//
//  ViewController.m
//  LXMExpandLayoutDemo
//
//  Created by luxiaoming on 15/5/27.
//  Copyright (c) 2015年 luxiaoming. All rights reserved.
//

#import "ViewController.h"
#import "TESTCollectionViewCell.h"
#import "LXMExpandLayout.h"

extern NSString * const TESTCollectionViewCellIdentifier;

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LXMExpandLayout *expandLayout = [[LXMExpandLayout alloc] init];
    expandLayout.itemSize = CGSizeMake(80, 100);
//    expandLayout.minimumLineSpacing = 20;//默认是10，可以随便设置
//    expandLayout.minimumInteritemSpacing = 20;//默认是10，可以随便设置
    expandLayout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 40);
    self.collectionView.collectionViewLayout = expandLayout;
    
    [self setupDefault];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - privateMethod

- (void)setupDefault {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddItemTapped:)];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStyleBordered target:self action:@selector(handleDeleteItemTapped:)];
    self.navigationItem.rightBarButtonItems = @[addItem, deleteItem];
}

#pragma mark - UICollectionViewDataSource


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TESTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TESTCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.centerImageView.image = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"it is %@", @(indexPath.row));
    [self.collectionView expandItemAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - buttonAction

- (void)handleAddItemTapped:(UIBarButtonItem *)sender {
    UIImage *newImage = [UIImage imageNamed:@"xianhua"];
    
    [self.dataArray insertObject:newImage atIndex:0];
    
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    } completion:^(BOOL finished) {

    }];
    
    
}

- (void)handleDeleteItemTapped:(UIBarButtonItem *)sender {
    if (self.dataArray.count == 0) {
        return;
    }
    [self.dataArray removeObjectAtIndex:0];

    [self.collectionView performBatchUpdates:^{
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];//因为dataArray是先删除元素的，所以这时候self.dataArray.count是最后一个元素，而不是self.dataArray.count-1
        [self.collectionView deleteItemsAtIndexPaths:@[newIndexPath]];
    } completion:^(BOOL finished) {

        //        [self.collectionView reloadData];//这里layout还没有写insert和delete的准备方法，所以有时候需要reloadData才能显示出cell
    }];
}

#pragma markk - property

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @(i)]];
            [_dataArray addObject:image];
        }
    }
    return _dataArray;
}


@end
