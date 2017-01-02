//
//  ZJLabelView.h
//  003 - 半糖demo
//
//  Created by 张杰 on 2017/1/1.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJLabelViewDelegate <NSObject>

@optional
- (void)zjLabelViewTapWithLabelTag:(NSInteger)tag;
@end

@interface ZJLabelView : UIView

@property(nonatomic,strong)NSMutableArray *array_label;//label的name

@property(nonatomic,strong)NSMutableArray *array_view;//底部的所有tableview
@property(nonatomic,assign)NSInteger current;
@property(nonatomic,weak)id<ZJLabelViewDelegate>delegate;

@end
