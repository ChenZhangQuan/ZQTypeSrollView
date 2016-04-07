//
//  ZQTypeSrollView.h
//  testdemo1
//
//  Created by 陈樟权 on 16/4/6.
//  Copyright © 2016年 陈樟权. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQTypeSrollView : UIView

/** 当前选中item的index*/
@property(nonatomic,assign)NSInteger selectIndex;

/** 所要显示item的标题数组*/
@property(nonatomic,strong)NSArray *types;

/** typeView前移还是后移block*/
@property(nonatomic,copy)void(^typeViewMove)(BOOL isForward);

/** 让typeView前移一个item*/
-(void)goReverseItem;

/** 让typeView后移一个item*/
-(void)goForwardItem;

@end
