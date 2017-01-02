//
//  ZJContentView.m
//  003 - 半糖demo
//
//  Created by 张杰 on 2017/1/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "ZJContentView.h"
#import "ZJTableViewCell.h"

@interface ZJContentView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *array_icon;

@end

@implementation ZJContentView

- (void)addTableViewToScrollView:(UIView *)contentView arrays:(NSArray *)arrays
{
    [self.array_view removeAllObjects];
    self.contentView = contentView;
    
    for (NSInteger i = 0; i < arrays.count; i++)
    {
        [self creatTableViewWithView:contentView withTag:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat max = 180 - 64;//轮播器的h - 导航栏的h
//    
//    if (scrollView == self.contentView)
//    {
//        NSLog(@"1111111111");
//        for (NSInteger i = 0; i < self.array_view.count; i++)
//        {
//            UITableView *tableView = self.array_view[i];
//            CGFloat contentY = tableView.contentOffset.y + tableView.contentInset.top;
//            
//            //只用管当轮播器完全看不见的时候，让所有的tableView滑动到label的下面
//            if (contentY >= max)
//            {
//                [tableView setContentOffset:CGPointMake(0, max - tableView.contentInset.top)];
//            }
//        }
//    }
//    else if ([scrollView isKindOfClass:[UITableView class]])
//    {
        CGFloat y = scrollView.contentOffset.y + scrollView.contentInset.top;
        
        NSLog(@"y      %f",scrollView.contentOffset.y);
        
        //1. 0到116，上滑直到导航栏完全看不到
        if (y >= 0 && y <= max)
        {
            for (NSInteger i = 0; i < self.array_view.count; i++)
            {
                UITableView *tableView = self.array_view[i];
                CGFloat contentY = tableView.contentOffset.y + tableView.contentInset.top;
                
                //不移动当前的tableView
                if (contentY != y)
                {
                    if (contentY >= 0 && contentY <= max)
                    {
                        [tableView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
                    }
                }
            }
            return;
        }
        
        //2.上滑直到导航栏完全看不到,还在上滑
        if (y > max)
        {
            for (NSInteger i = 0; i < self.array_view.count; i++)
            {
                UITableView *tableView = self.array_view[i];
                CGFloat contentY = tableView.contentOffset.y + tableView.contentInset.top;
                
                //不移动当前的tableView
                if (contentY != y)
                {
                    if (contentY >= 0 && contentY <= max)
                    {
                        [tableView setContentOffset:CGPointMake(0, -(64 + 40))];//nav的h + label的h
                    }
                }
            }
        }
//    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array_icon.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJTableViewCell *cell = [ZJTableViewCell cellWithTableView:tableView];
    cell.str_image = self.array_icon[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"cell   %ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)creatTableViewWithView:(UIView *)contentView withTag:(NSInteger)tag
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.contentInset = UIEdgeInsetsMake(220, 0, 0, 0);
    
    CGFloat w = contentView.bounds.size.width;
    CGFloat h = contentView.bounds.size.height;
    tableView.frame = CGRectMake(w * tag, 0, w, h);
    //        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 220);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 250;
    
    [contentView addSubview:tableView];
    [self.array_view addObject:tableView];
}

- (NSMutableArray *)array_view
{
    if (!_array_view) {
        _array_view = [[NSMutableArray alloc] init];
    }
    return _array_view;
}

- (NSArray *)array_icon
{
    if (!_array_icon) {
        _array_icon = [NSArray arrayWithObjects:@"recomand_01",@"recomand_02",@"recomand_03",@"recomand_04",@"recomand_05",@"recomand_06",@"recomand_07",@"recomand_08",@"recomand_09",@"recomand_10",@"recomand_11",@"recomand_12",@"recomand_13",@"recomand_14",@"recomand_15",@"recomand_16",@"recomand_17",@"recomand_18",@"recomand_19",@"recomand_20", nil];
    }
    return _array_icon;
}

@end
