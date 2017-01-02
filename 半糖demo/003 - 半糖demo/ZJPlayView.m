//
//  ZJPlayView.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2016/12/29.
//  Copyright © 2016年 张杰. All rights reserved.
//
#define maxH 180

#import "ZJPlayView.h"
#import "ZJCollectionViewCell.h"
#import "ZJFlowLayout.h"
#import "Masonry.h"

@interface ZJPlayView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)ZJFlowLayout *flowLayout;
@property(nonatomic,strong)NSArray *array_heard;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer                    *timer;

@end

@implementation ZJPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, -maxH - 40, [UIScreen mainScreen].bounds.size.width, maxH);
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        [self.collectionView reloadData];
        
        //作用：当主线程任务完成后才会执行这些代码
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //1.让collectionView默认滑动到第二组
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.array_heard.count inSection:0];
            
            [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            
            //2.添加定时器
            [self addTimer];
        });

    }
    return self;
}

- (void)dealloc
{
//    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview)
    {
//        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
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
    
    
    if (coffsetY <= 0)
    {
        coffsetY = 0;
    }
    
    //必须要重新赋值过，不然y会重复-
    self.frame = CGRectMake(0, -coffsetY, [UIScreen mainScreen].bounds.size.width, maxH);
//    CGRect rect = self.frame;
//    rect.origin.y = rect.origin.y - coffsetY;
//    self.frame = rect;
}

-(void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}
-(void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)nextImage
{
    //0.得到当前页数
    NSInteger x = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    
    // 1.增加pageControl的页码
    NSInteger page = 0;
    if (x == self.array_heard.count * 1000 - 1)
    {
        page = 0;
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else
    {
        page = x + 1;
        
        // 2.计算scrollView滚动的位置
        CGFloat offsetX = page * self.collectionView.frame.size.width;
        [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

/**
 *  当scrollView正在滚动就会调用
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float i = scrollView.contentOffset.x / scrollView.frame.size.width;
    int j = (float)(i + 0.5);
    
    self.pageControl.currentPage = j % self.array_heard.count;
}

/**
 *  开始拖拽的时候调用
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

/**
 *  减速停止的时候开始执行
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger x = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    NSLog(@"width   %f",scrollView.frame.size.width);
    NSLog(@"x    %ld",x);
    
    //1.在第1张的时候，让他滑动到第array.count张
    if (x == 0)
    {
        [self.collectionView setContentOffset:CGPointMake(self.array_heard.count * self.collectionView.frame.size.width, 0) animated:NO];
    }
    
    //2.在最后1张得时候，让它滑动到第array.count - 1张
    if (x == self.array_heard.count * 1000 - 1)
    {
        [self.collectionView setContentOffset:CGPointMake((self.array_heard.count - 1) * self.collectionView.frame.size.width, 0) animated:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array_heard.count * 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJCollectionViewCell *cell = [ZJCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.logo = self.array_heard[indexPath.row % self.array_heard.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self).with.offset(-10);
        make.height.mas_equalTo(10);
    }];
}

- (ZJFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[ZJFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, maxH) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.array_heard.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (NSArray *)array_heard
{
    if (!_array_heard) {
        _array_heard = [NSArray arrayWithObjects:@"cycle_01",@"cycle_02",@"cycle_03",@"cycle_04",@"cycle_05",@"cycle_06",@"cycle_07",@"cycle_08", nil];
    }
    return _array_heard;
}

@end
