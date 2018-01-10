//
//  JWTestCollectionViewCell.m
//  JWCollectionViewPageLayoutDemo
//
//  Created by 吴建文 on 2018/1/10.
//  Copyright © 2018年 Javen. All rights reserved.
//

#import "JWTestCollectionViewCell.h"
@interface JWTestCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation JWTestCollectionViewCell

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _titleLab.text = [NSString stringWithFormat:@"%zd\n%zd",indexPath.section,indexPath.row];
    self.backgroundColor = indexPath.row % 2 ? [UIColor orangeColor] : [UIColor grayColor];
}

@end
