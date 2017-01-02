//
//  ViewController.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import "ViewController.h"
#import "ZJHeardView.h"
#import "ZJPlayView.h"
#import "ZJTableViewCell.h"
#import "ZJLabelView.h"
#import "ZJContentView.h"


@interface ViewController ()<UIScrollViewDelegate,ZJLabelViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView_foot;
@property(nonatomic,strong)ZJHeardView  *heardView;
@property(nonatomic,strong)ZJPlayView   *playView;
@property(nonatomic,strong)ZJLabelView  *lableView;
@property(nonatomic,strong)ZJContentView *contentTableView;
@property(nonatomic,strong)NSMutableArray *array_count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //最下面是self.view，然后scrollView_foot，在把tableview加到scrollView_foot上，设置tableview的contentInset的top为playView的h + lableView的h
    //再加playView，heardView，lableView加到self.view上
    [self.view addSubview:self.scrollView_foot];
    [self.view addSubview:self.playView];
    [self.view addSubview:self.heardView];
    [self.view addSubview:self.lableView];
    
}

//点击了label
- (void)zjLabelViewTapWithLabelTag:(NSInteger)tag
{

//    [self.scrollView_foot setContentOffset:CGPointMake(tag * [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
    self.scrollView_foot.contentOffset = CGPointMake(tag * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat max = 180 - 64;//轮播器的h - 导航栏的h
    
    for (NSInteger i = 0; i < self.contentTableView.array_view.count; i++)
    {
        UITableView *tableView = self.contentTableView.array_view[i];
        
        CGFloat contentY = tableView.contentOffset.y + tableView.contentInset.top;
        
        //只用管当轮播器完全看不见的时候，让所有的tableView滑动到label的下面
        if (contentY >= max)
        {
            [tableView setContentOffset:CGPointMake(0, max - tableView.contentInset.top)];
        }
    }
    
    //设置label标签位置改变
    CGFloat x = self.scrollView_foot.contentOffset.x / self.scrollView_foot.frame.size.width;
    NSInteger current = x + 0.5;
    self.lableView.current = current;
}

- (ZJPlayView *)playView
{
    if (!_playView) {
        _playView = [[ZJPlayView alloc] init];
        _playView.array_view = self.contentTableView.array_view;
    }
    return _playView;
}

- (ZJHeardView *)heardView
{
    if (!_heardView) {
        _heardView = [[ZJHeardView alloc] init];
        _heardView.array_view = self.contentTableView.array_view;
    }
    return _heardView;
}

- (ZJLabelView *)lableView
{
    if (!_lableView) {
        _lableView = [[ZJLabelView alloc] init];
        _lableView.array_label = self.array_count;
        _lableView.current = 0;
        _lableView.array_view = self.contentTableView.array_view;
        _lableView.delegate = self;
    }
    return _lableView;
}

- (UIScrollView *)scrollView_foot
{
    if (!_scrollView_foot) {
        _scrollView_foot = [[UIScrollView alloc] init];
        _scrollView_foot.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _scrollView_foot.backgroundColor = [UIColor yellowColor];
        _scrollView_foot.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.array_count.count, 0);
        _scrollView_foot.pagingEnabled = YES;
        _scrollView_foot.showsHorizontalScrollIndicator = NO;
        _scrollView_foot.delegate = self;
    }
    return _scrollView_foot;
}

- (ZJContentView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[ZJContentView alloc] init];
        [_contentTableView addTableViewToScrollView:self.scrollView_foot arrays:self.array_count];
    }
    return _contentTableView;
}

- (NSMutableArray *)array_count
{
    if (!_array_count) {
        _array_count = [[NSMutableArray alloc] initWithObjects:@"推荐",@"热门",@"原创",@"美食",@"生活",@"卡通",@"娱乐",@"话题", nil];
    }
    return _array_count;
}

@end
