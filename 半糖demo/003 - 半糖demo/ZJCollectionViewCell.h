//
//  ZJCollectionViewCell.h
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,copy)NSString *logo;

@end
