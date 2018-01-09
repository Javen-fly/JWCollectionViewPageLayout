//
//  JWCollectionViewPageLayout.h
//  JWCollectionViewPageLayoutDemo
//
//  Created by 吴建文 on 2018/1/9.
//  Copyright © 2018年 Javen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JWCollectionViewPageLayout;
@protocol JWCollectionViewDelegatePageLayOut <UICollectionViewDelegate>
@optional
- (CGSize)jw_collectionView:(UICollectionView *)collectionView layout:(JWCollectionViewPageLayout*)collectionViewLayout sizeForItemAtSection:(NSInteger)section;

- (UIEdgeInsets)jw_collectionView:(UICollectionView *)collectionView layout:(JWCollectionViewPageLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)jw_collectionView:(UICollectionView *)collectionView layout:(JWCollectionViewPageLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)jw_collectionView:(UICollectionView *)collectionView layout:(JWCollectionViewPageLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
@end
@interface JWCollectionViewPageLayout : UICollectionViewLayout

/** item的大小 */
@property (nonatomic, assign) CGSize itemSize;
/** section的内边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
/** 最小行间距 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/** 最小item间隔 */
@property (nonatomic, assign) CGFloat minimunInteritemSpacing;

@end
