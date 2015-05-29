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
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TESTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TESTCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @(indexPath.row)]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"it is %@", @(indexPath.row));
    [self.collectionView expandItemAtIndexPath:indexPath animated:YES];
    
}

@end
