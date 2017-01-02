//
//  ZJTableViewCell.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import "ZJTableViewCell.h"
#import "Masonry.h"

@interface ZJTableViewCell ()

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel     *label;
@property(nonatomic,strong)UIView      *shadow;

@end

@implementation ZJTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ZJTableViewCell";
    
    ZJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[ZJTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.label];
        self.selectedBackgroundView = self.shadow;
    }
    return self;
}

- (void)setStr_image:(NSString *)str_image
{
    _str_image = [str_image copy];
    
    self.icon.image = [UIImage imageNamed:str_image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.frame;
    rect.origin.x = rect.origin.x + 20;
    rect.size.width = rect.size.width - 40;
    rect.origin.y = rect.origin.y + 20;
    rect.size.height -= 10;
    self.contentView.frame = rect;
    
    self.shadow.frame = rect;
    
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).with.offset(30);
        make.height.mas_equalTo(180);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.icon.mas_bottom);
        make.height.mas_equalTo(30);
    }];
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 10;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor lightGrayColor];
        _label.text = @"校园好生活";
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIView *)shadow
{
    if (!_shadow) {
        _shadow = [[UIView alloc] init];
        _shadow.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        _shadow.layer.cornerRadius = 10;
        _shadow.clipsToBounds = YES;
    }
    return _shadow;
}

@end
