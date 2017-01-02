//
//  ZJLabelView.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2017/1/1.
//  Copyright © 2017年 张杰. All rights reserved.
//
#define maxH 180

#import "ZJLabelView.h"

@interface ZJLabelView ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *arrays;
@property(nonatomic,strong)UIScrollView *scrollView_top;

@end

@implementation ZJLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.scrollView_top];
    }
    return self;
}

- (void)setCurrent:(NSInteger)current
{
    _current = current;
    
    for (NSInteger i = 0 ; i < self.arrays.count; i++)
    {
        UILabel *label = self.arrays[i];
        
        if (i == current)
        {
            label.textColor = [UIColor redColor];
        }
        else
        {
            label.textColor = [UIColor blackColor];
        }
    }
    
    //最后一个label
    UILabel *lastLabel = self.arrays[self.array_label.count - 1];
    
    UILabel *currentLabel = self.arrays[self.current];
    CGFloat y = currentLabel.frame.origin.x;
    CGFloat scanW = [UIScreen mainScreen].bounds.size.width * 0.5;
    
    NSLog(@"y     %f",y);
    
    //最大的滑动距离
    CGFloat maxX = lastLabel.frame.origin.x - scanW - lastLabel.frame.size.width;
    
    if (y < scanW)
    {
        [self.scrollView_top setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (y > scanW)
    {
        CGFloat cha = y - scanW;
        if (cha >= maxX)
        {
            cha = maxX;
        }
        [self.scrollView_top setContentOffset:CGPointMake(cha, 0) animated:YES];
    }
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
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"] || ![object isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    UITableView *tableView = (UITableView *)object;
    CGFloat coffsetY = tableView.contentOffset.y + tableView.contentInset.top;//向上是+  向下是-
    
    //y最大是180，最小是64
    CGFloat minY = 64;
    CGFloat y = 180 - coffsetY;
    if (y < minY)
    {
        y = minY;
    } else if (y >= 180)
        y = 180;
    
    self.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 40);
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == self.scrollView_top)
//    {
//        //最后一个label
//        UILabel *lastLabel = self.array_view[self.array_label.count - 1];
//        
//        UILabel *currentLabel = self.array_view[self.current];
//        CGFloat y = currentLabel.frame.origin.x;
//        CGFloat scanW = [UIScreen mainScreen].bounds.size.width * 0.5;
//        
//        //最大的滑动距离
//        CGFloat maxX = lastLabel.frame.origin.x - scanW;
//        
//        if (y < scanW)
//        {
//            return;
//        }
//        else if (y > scanW)
//        {
//            CGFloat cha = y - scanW;
//            if (cha >= maxX)
//            {
//                cha = maxX;
//            }
//            
//            self.scrollView_top.contentOffset = CGPointMake(cha, 0);
//        }
//    }
//}

- (void)tapWithLable:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
//    self.current = label.tag;
    
    if ([self.delegate respondsToSelector:@selector(zjLabelViewTapWithLabelTag:)]) {
        [self.delegate zjLabelViewTapWithLabelTag:label.tag];
    }
    
    NSLog(@"current   %ld",self.current);
}

- (void)setArray_label:(NSMutableArray *)array_label
{
    _array_label = array_label;
    
    [self.arrays removeAllObjects];
    
    self.scrollView_top.contentSize = CGSizeMake(80 * array_label.count, 0);
    
    for (NSInteger i = 0; i < array_label.count; i++)
    {
        [self addLabel:array_label[i] tag:i];
    }
}

- (void)addLabel:(NSString *)title tag:(NSInteger)i
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.tag = i;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWithLable:)];
    [label addGestureRecognizer:tap];
    [self.scrollView_top addSubview:label];
    [self.arrays addObject:label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelW = 80;
    
    
    for (NSInteger i = 0 ; i < self.arrays.count; i++)
    {
        UILabel *label = self.arrays[i];
        label.frame = CGRectMake(labelW * i, 0, labelW, self.frame.size.height);
    }
}

- (NSMutableArray *)arrays
{
    if (!_arrays) {
        _arrays = [[NSMutableArray alloc] init];
    }
    return _arrays;
}


- (UIScrollView *)scrollView_top
{
    if (!_scrollView_top) {
        _scrollView_top = [[UIScrollView alloc] init];
        _scrollView_top.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
        _scrollView_top.showsHorizontalScrollIndicator = NO;
//        _scrollView_top.delegate = self;
        _scrollView_top.backgroundColor = [UIColor greenColor];
        _scrollView_top.delegate = self;
    }
    return _scrollView_top;
}

@end
