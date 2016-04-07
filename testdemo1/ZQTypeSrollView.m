//
//  ZQTypeSrollView.m
//  testdemo1
//
//  Created by 陈樟权 on 16/4/6.
//  Copyright © 2016年 陈樟权. All rights reserved.
//

#import "ZQTypeSrollView.h"
#import "ZQBackView.h"
#import "Masonry.h"

@interface ZQTypeSrollView()<UIScrollViewDelegate>

@property(nonatomic,weak)ZQBackView *backView;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *labelArr;
@property(nonatomic,assign)NSInteger lastSelectIndex;
/**如果是外部控制typeView移动时的bool标签*/
@property(nonatomic,assign)BOOL outCall;
/**如果是内部点击或者拖动,控制typeView移动时的bool标签*/
@property(nonatomic,assign)BOOL isNotDrag;

@end

@implementation ZQTypeSrollView

-(NSMutableArray *)labelArr{
    if (_labelArr == nil) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selectIndex = 0;
        self.lastSelectIndex = -1;
        [self setupScrollView];
    }
    return self;
}

-(void)setupScrollView{
    
    ZQBackView *backView = [[ZQBackView alloc] init];
    self.backView = backView;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;

    self.scrollView = scrollView;
    [backView addSubview:scrollView];
    backView.touchDelegateView = scrollView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:tap];

    UITapGestureRecognizer *dtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    dtap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:dtap];
    [scrollView addGestureRecognizer:dtap];
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.width.equalTo(self).multipliedBy(1/3.0);
        make.height.equalTo(@64);
        make.centerX.equalTo(backView);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.alpha = 0.5;
    [scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
        make.width.equalTo(self).multipliedBy(1/3.0 * 5);
    }];
    UIView *lastView = nil;
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *configView = [[UILabel alloc] init];
//        configView.text = [NSString stringWithFormat:@"测试%ld",i];
        configView.textAlignment = NSTextAlignmentCenter;
        configView.font = [UIFont systemFontOfSize:15];
        configView.textColor = [UIColor blackColor];
        [contentView addSubview:configView];
        [configView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView);
            make.height.equalTo(contentView);
            make.width.equalTo(self).multipliedBy(1/3.0);
            if (lastView == nil) {
                make.left.equalTo(contentView);
            }else{
                make.left.equalTo(lastView.mas_right);
            }
        }];
        [self.labelArr addObject:configView];
        lastView = configView;
    }
        

    
}



-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self scrollViewDidScroll:self.scrollView];

}

-(void)setTypes:(NSArray *)types{
    _types = types;
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *label = self.labelArr[i];
        label.text = types[i];
    }
}

-(void)tapView:(UITapGestureRecognizer *)tap{
    

    CGPoint point = [tap locationInView:self];
    /**如果外部正在调用方法，scrollView正在移动，那么就返回*/
    if(self.outCall == YES)
        return;
    
    self.outCall = NO;
    [self moveTypeViewWithPoint:point];
    


}
/**  不是拖动的时候调用改方法*/
-(void)moveTypeViewWithPoint:(CGPoint)point{
    self.scrollView.scrollEnabled = NO;
    self.isNotDrag = YES;

    if (point.x < [UIScreen mainScreen].bounds.size.width / 3.0){
        self.selectIndex --;
        if (self.selectIndex < 0) {
            self.selectIndex = 0;
            [self scrollViewDidEndDecelerating:self.scrollView];
            return;
        }
    }else if (point.x > [UIScreen mainScreen].bounds.size.width * 2 / 3.0){
        self.selectIndex ++;
        
        if (self.selectIndex > self.labelArr.count - 1) {
            self.selectIndex = self.labelArr.count - 1;
            [self scrollViewDidEndDecelerating:self.scrollView];
            return;
        }
    }else{
        [self scrollViewDidEndDecelerating:self.scrollView];
        return;
    }
    CGPoint p1 = CGPointMake(self.selectIndex * [UIScreen mainScreen].bounds.size.width / 3.0,0);
    
    /** 非拖动的时候让他点击的时候直接发出移动消息*/
    [self.scrollView setContentOffset:p1 animated:YES];
    [self shouldChangeController];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isNotDrag) {
        /** 非拖动的时候让他点击的时候直接发出移动消息*/
    }else{
        /** 拖动的时候让他拖到临界点的时候再发出移动消息*/
        self.selectIndex = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width / 3.0) + 0.5;
        [self shouldChangeController];
    }

}

/** 下面两个停止方法分别在拖动和setoffset停止后调用*/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isNotDrag = NO;
    /** 没滚就不要让scrollView响应事件了*/
    self.scrollView.scrollEnabled = YES;
    self.outCall = NO;

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    self.isNotDrag = NO;
    self.scrollView.scrollEnabled = YES;
    self.outCall = NO;

}
/** 改方法发出typeView更改了item的消息，并且设置label*/
-(void)shouldChangeController{
    
    if (self.lastSelectIndex != self.selectIndex && self.outCall == NO) {

        if (self.selectIndex > self.lastSelectIndex) {
            NSLog(@"->");
            if (self.typeViewMove) {
                self.typeViewMove(YES);
            }
        }else{
            if (self.typeViewMove) {
                self.typeViewMove(NO);
            }
            NSLog(@"<-");
        }
    }
    self.lastSelectIndex = self.selectIndex;
    for (NSInteger i = 0; i < self.labelArr.count; i++) {
        UILabel *selectLabel = self.labelArr[i];
        
        if (i == self.selectIndex) {
            selectLabel.textColor = [UIColor blueColor];
            
            selectLabel.font = [UIFont systemFontOfSize:25];
        }else {
            selectLabel.textColor = [UIColor blackColor];
            
            selectLabel.font = [UIFont systemFontOfSize:15];
            
        }
    }
}

/** 外部方法*/
-(void)goReverseItem{
    self.outCall = YES;
    [self moveTypeViewWithPoint:CGPointMake(0, 0)];

}

-(void)goForwardItem{
    self.outCall = YES;
    [self moveTypeViewWithPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
        
}

@end
