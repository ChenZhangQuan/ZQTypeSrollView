//
//  ZQTypeSrollView.h
//  testdemo1
//
//  Created by 陈樟权 on 16/4/6.
//  Copyright © 2016年 陈樟权. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZQTypeSrollViewMoveTypeForward,
    ZQTypeSrollViewMoveTypeReverse,
    ZQTypeSrollViewMoveTypeNoMove,
}ZQTypeSrollViewMoveType;

@interface ZQTypeSrollView : UIView



@property(nonatomic,weak)UIScrollView *scrollView;


/** 当前选中item的index*/
@property(nonatomic,assign)NSInteger selectIndex;

/** 所要显示item的标题数组*/
@property(nonatomic,strong)NSArray *types;

/** typeView前移还是后移block*/
@property(nonatomic,copy)void(^typeViewMove)(ZQTypeSrollViewMoveType type);

@property(nonatomic,copy)void(^typeViewDraging)();

///** 让typeView前移一个item*/
//-(void)goReverseItem;
///** 让typeView后移一个item*/
//-(void)goForwardItem;
//
//-(void)noMoveItem;

-(void)moveItem;

-(void)lockScrollView;

-(void)unlockScrollView;

@end
