//
//  ZJCollectionViewCell.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import "ZJCollectionViewCell.h"

@interface ZJCollectionViewCell ()

@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation ZJCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ZJCollectionViewCell";
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:ID];
    return [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setLogo:(NSString *)logo
{
    _logo = [logo copy];
    
    self.imageView.image = [UIImage imageNamed:logo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.imageView.frame = CGRectMake(0, 0, self, <#CGFloat height#>)
    self.imageView.frame = self.contentView.bounds;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
