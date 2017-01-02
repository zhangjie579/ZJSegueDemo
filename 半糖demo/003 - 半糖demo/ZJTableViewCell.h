//
//  ZJTableViewCell.h
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)NSString *str_image;

@end
