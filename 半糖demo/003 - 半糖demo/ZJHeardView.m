//
//  ZJHeardView.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//
#define maxH 180

#import "ZJHeardView.h"
#import "Masonry.h"

@interface ZJHeardView ()

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIButton *btn_left;
@property(nonatomic,strong)UIButton *btn_right;

@end

@implementation ZJHeardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.btn_left];
        [self addSubview:self.searchBar];
        [self addSubview:self.btn_right];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat line = 10;
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    
    [self.btn_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(line);
        make.centerY.mas_equalTo(self).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.btn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-line);
        make.centerY.mas_equalTo(self).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(30);
        make.centerY.mas_equalTo(self).with.offset(6);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.btn_right.mas_left).with.offset(-line);
    }];
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview)
    {
        for (NSInteger i = 0; i < self.array_view.count; i++)
        {
            UITableView *tableView = self.array_view[i];
            [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        }
//        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"])
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    UITableView *tableView = (UITableView *)object;
    CGFloat coffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    
    UIColor * color = [UIColor whiteColor];
    CGFloat scrollMaxH = maxH - self.frame.size.height;//轮播器的h - 本身的h
    CGFloat alpha = MIN(1, coffsetY / scrollMaxH);
    
    self.backgroundColor = [color colorWithAlphaComponent:alpha];
    
//    NSLog(@"%f",coffsetY);
    
    //自己的高度 + 标签的高度  取反
    if (coffsetY >= scrollMaxH)//向上滑动
    {
        [UIView animateWithDuration:0.2 animations:^{
            
//            self.searchBar.transform = CGAffineTransformIdentity;
            self.searchBar.hidden = NO;
            self.btn_left.hidden = YES;
            [_btn_right setBackgroundImage:[UIImage imageNamed:@"home_email_red"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
//            self.searchBar.transform = CGAffineTransformIdentity;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
//            self.searchBar.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
            self.btn_left.hidden = NO;
            self.searchBar.hidden = YES;
            [_btn_right setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
//            self.searchBar.hidden = YES;
        }];
    }
}

- (UIButton *)btn_left
{
    if (!_btn_left) {
        _btn_left = [[UIButton alloc] init];
        [_btn_left setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
        _btn_left.hidden = YES;
    }
    return _btn_left;
}

- (UIButton *)btn_right
{
    if (!_btn_right) {
        _btn_right = [[UIButton alloc] init];
        [_btn_right setBackgroundImage:[UIImage imageNamed:@"home_email_red"] forState:UIControlStateNormal];
    }
    return _btn_right;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索值得买的好物";
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        [_searchBar sizeToFit];
        
        [_searchBar setSearchFieldBackgroundImage:[self imageWithColor:[UIColor clearColor] size:_searchBar.frame.size] forState:UIControlStateNormal];
        
        [_searchBar setBackgroundImage:[self imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.4] size:_searchBar.frame.size] ];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        
        
    }
    return _searchBar;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
