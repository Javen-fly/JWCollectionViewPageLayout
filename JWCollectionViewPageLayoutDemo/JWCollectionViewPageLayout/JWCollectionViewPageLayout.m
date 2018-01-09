//
//  JWCollectionViewPageLayout.m
//  JWCollectionViewPageLayoutDemo
//
//  Created by 吴建文 on 2018/1/9.
//  Copyright © 2018年 Javen. All rights reserved.
//

#import "JWCollectionViewPageLayout.h"

@interface JWCollcetionViewSectionInfoModel:NSObject

@property (nonatomic, assign) NSInteger numberOfRow;
@property (nonatomic, assign) NSInteger numberOfColumn;
@property (nonatomic, assign) NSInteger numberOfPage;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimunInteritemSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger indexOfFirstPage;

@end

@implementation JWCollcetionViewSectionInfoModel



@end

@interface JWCollectionViewPageLayout()

@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, weak) id<JWCollectionViewDelegatePageLayOut> horizantalDelegate;

@property (nonatomic, strong) NSMutableArray *sectionInfoArr;
@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo;
@end

@implementation JWCollectionViewPageLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(40.f, 40.f);
        self.sectionInsets = UIEdgeInsetsMake(0, 1, 0, 1);
        self.minimumLineSpacing = 1.f;
        self.minimunInteritemSpacing = 1.f;
        self.sectionInfoArr = [NSMutableArray array];
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    _collectionViewSize = self.collectionView.bounds.size;
    _horizantalDelegate = (id<JWCollectionViewDelegatePageLayOut>) self.collectionView.delegate;
    [self manageSectionInfo];
}

- (void)manageSectionInfo
{
    [_sectionInfoArr removeAllObjects];
    [_cellLayoutInfo removeAllObjects];
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    NSInteger indexOfFirstPage = 0;
    for (NSInteger section = 0; section < numberOfSection; section++) {
        
        JWCollcetionViewSectionInfoModel *sectionInfo = [JWCollcetionViewSectionInfoModel new];
        sectionInfo.numberOfPage = 0;
        sectionInfo.numberOfColumn = 0;
        sectionInfo.numberOfRow = 0;
        sectionInfo.insets = _sectionInsets;
        sectionInfo.minimumLineSpacing = _minimumLineSpacing;
        sectionInfo.minimunInteritemSpacing = _minimunInteritemSpacing;
        sectionInfo.itemSize = _itemSize;
        
        if (_horizantalDelegate && [_horizantalDelegate respondsToSelector:@selector(jw_collectionView:layout:sizeForItemAtSection:)]) {
            sectionInfo.itemSize = [_horizantalDelegate jw_collectionView:self.collectionView layout:self sizeForItemAtSection:section];
            if ([_horizantalDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                sectionInfo.insets = [_horizantalDelegate jw_collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            }
            if ([_horizantalDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
                sectionInfo.minimumLineSpacing = [_horizantalDelegate jw_collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
            }
            if ([_horizantalDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
                sectionInfo.minimunInteritemSpacing = [_horizantalDelegate jw_collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
            }
        }
        sectionInfo.numberOfColumn = (_collectionViewSize.width - sectionInfo.insets.left - sectionInfo.insets.right + sectionInfo.minimunInteritemSpacing) / (sectionInfo.itemSize.width + sectionInfo.minimunInteritemSpacing);
        sectionInfo.numberOfRow = (_collectionViewSize.height - sectionInfo.insets.top - sectionInfo.insets.bottom + sectionInfo.minimumLineSpacing) / (sectionInfo.itemSize.height + sectionInfo.minimumLineSpacing);
        sectionInfo.interitemSpacing = (_collectionViewSize.width - sectionInfo.insets.left - sectionInfo.insets.right - sectionInfo.itemSize.width * sectionInfo.numberOfColumn) / (sectionInfo.numberOfColumn - 1);
        sectionInfo.lineSpacing = (_collectionViewSize.height - sectionInfo.insets.top - sectionInfo.insets.bottom - sectionInfo.itemSize.height * sectionInfo.numberOfRow) / (sectionInfo.numberOfRow - 1);
        
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        sectionInfo.numberOfPage = numberOfItem / (sectionInfo.numberOfColumn * sectionInfo.numberOfRow) + ((numberOfItem % (sectionInfo.numberOfColumn * sectionInfo.numberOfRow)) ? 1 : 0);
        sectionInfo.indexOfFirstPage = indexOfFirstPage;
        
        [_sectionInfoArr addObject:sectionInfo];
        indexOfFirstPage += sectionInfo.numberOfPage;
        
        
        for (NSInteger index = 0; index < numberOfItem; index++) {
            NSInteger indexOfPageInSection = index / (sectionInfo.numberOfRow * sectionInfo.numberOfColumn);
            NSInteger indexOfPage = sectionInfo.indexOfFirstPage + indexOfPageInSection;
            
            NSInteger indexOfItemInPage = index % (sectionInfo.numberOfRow * sectionInfo.numberOfColumn);
            NSInteger indexOfRowInPage = indexOfItemInPage / sectionInfo.numberOfColumn;
            NSInteger indexOfColumnInPage = indexOfItemInPage % sectionInfo.numberOfColumn;
            
            CGFloat x = _collectionViewSize.width * indexOfPage + sectionInfo.insets.left + (sectionInfo.itemSize.width + sectionInfo.interitemSpacing) * indexOfColumnInPage;
            CGFloat y = sectionInfo.insets.top + (sectionInfo.itemSize.height + sectionInfo.lineSpacing) * indexOfRowInPage;
            
            NSIndexPath *indexPath =[NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            //设置当前cell布局对象的frame
            attribute.frame = CGRectMake(x, y, sectionInfo.itemSize.width, sectionInfo.itemSize.height);
            NSLog(@"indexPath:%zd,%zd === frame:%lf,%lf,%lf,%lf",indexPath.section,indexPath.row,attribute.frame.origin.x, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);
            _cellLayoutInfo[indexPath] = attribute;
        }
    }
}

- (CGSize)collectionViewContentSize
{
    JWCollcetionViewSectionInfoModel *sectionInfo = [_sectionInfoArr lastObject];
    CGFloat contentW = (sectionInfo.indexOfFirstPage + sectionInfo.numberOfPage) * _collectionViewSize.width;
    CGFloat contentH = _collectionViewSize.height;
    return CGSizeMake(contentW, contentH);
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    //添加当前屏幕可见的cell的布局
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    return allAttributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    JWCollcetionViewSectionInfoModel *sectionInfo = _sectionInfoArr[indexPath.section];
    
    NSInteger indexOfPageInSection = indexPath.row / (sectionInfo.numberOfRow * sectionInfo.numberOfColumn);
    NSInteger indexOfPage = sectionInfo.indexOfFirstPage + indexOfPageInSection;
    
    NSInteger indexOfItemInPage = indexPath.row % (sectionInfo.numberOfRow * sectionInfo.numberOfColumn);
    NSInteger indexOfRowInPage = indexOfItemInPage % sectionInfo.numberOfColumn;
    NSInteger indexOfColumnInPage = indexOfItemInPage % sectionInfo.numberOfRow;
    
    CGFloat x = _collectionViewSize.width * indexOfPage + sectionInfo.insets.left + (sectionInfo.itemSize.width + sectionInfo.interitemSpacing) * indexOfColumnInPage;
    CGFloat y = sectionInfo.insets.top + (sectionInfo.itemSize.height + sectionInfo.lineSpacing) * indexOfRowInPage;
    
    layoutAttributes.frame = CGRectMake(x, y, sectionInfo.itemSize.width, sectionInfo.itemSize.height);
    
    return layoutAttributes;
}
@end
