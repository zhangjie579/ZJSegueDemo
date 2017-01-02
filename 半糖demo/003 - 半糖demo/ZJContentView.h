//
//  ZJContentView.h
//  003 - 半糖demo
//
//  Created by 张杰 on 2017/1/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJContentView : NSObject <UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *array_view;
@property(nonatomic,weak)UIView *contentView;

- (void)addTableViewToScrollView:(UIView *)contentView arrays:(NSArray *)arrays;

@property(nonatomic,assign)NSInteger currentView;
@end
