//
//  ViewController.m
//  JWCollectionViewPageLayoutDemo
//
//  Created by 吴建文 on 2018/1/9.
//  Copyright © 2018年 Javen. All rights reserved.
//

#import "ViewController.h"
#import "JWCollectionViewPageLayout.h"
#import "JWTestCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JWCollectionViewDelegatePageLayOut>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 80;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JWTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JWTestCollectionViewCell class]) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (CGSize)jw_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtSection:(NSInteger)section
{
    switch (section) {
        case 0: return CGSizeMake(50, 50);
        case 1: return CGSizeMake(100, 100);
        case 2: return CGSizeMake(75, 50);
            
        default:
            break;
    }
    return CGSizeMake(50, 50);
}

- (CGFloat)jw_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)jw_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (UIEdgeInsets)jw_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zd,%zd",indexPath.section,indexPath.row);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, screenSize.width, 300.f) collectionViewLayout:[[JWCollectionViewPageLayout alloc]init]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JWTestCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([JWTestCollectionViewCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor greenColor];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

@end
