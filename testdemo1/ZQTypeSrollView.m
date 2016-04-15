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
@property(nonatomic,strong)NSMutableArray *labelArr;
@property(nonatomic,assign)NSInteger lastSelectIndex;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UITapGestureRecognizer *dtap;
@property(nonatomic,assign)BOOL shouldNotMoveLater;
@property(nonatomic,strong)NSTimer *timer;

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
//    scrollView.bounces = NO;
    scrollView.delegate = self;

    self.scrollView = scrollView;
    [backView addSubview:scrollView];
    backView.touchDelegateView = scrollView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:tap];
    self.tap = tap;
    UITapGestureRecognizer *dtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    dtap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:dtap];
    [scrollView addGestureRecognizer:dtap];
    self.dtap = dtap;

    
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
    [self scrollViewDidEndDecelerating:self.scrollView];
    

}

-(void)setTypes:(NSArray *)types{
    _types = types;
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *label = self.labelArr[i];
        label.text = types[i];
    }
}

-(void)tapView:(UITapGestureRecognizer *)tap{
    if (self.shouldNotMoveLater) {
        self.shouldNotMoveLater = NO;
        return;
    }
    NSLog(@"tap");
    if (self.typeViewDraging) {
        self.typeViewDraging();
    }
    

    CGPoint point = [tap locationInView:self];

    [self moveTypeViewWithPoint:point];
    


}

-(void)moveTypeViewWithPoint:(CGPoint)point{


    
//    self.scrollView.scrollEnabled = NO;
    [self lockScrollView];

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

    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.selectIndex = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width / 3.0) + 0.5;
    if (self.selectIndex < 0) {
        self.selectIndex = 0;
    }else if (self.selectIndex > self.types.count - 1){
        self.selectIndex = self.types.count - 1;
    }
    [self shouldChangeLabel];


}

/** 下面两个停止方法分别在拖动*/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    /** 没滚就不要让scrollView响应事件了*/
//    self.scrollView.scrollEnabled = YES;
    [self unlockScrollView];

    
    [self shouldChangeController];
    self.lastSelectIndex = self.selectIndex;
}
/** setoffset停止后调用*/
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    /** 没滚就不要让scrollView响应事件了*/
    [self unlockScrollView];

    if (self.shouldNotMoveLater) {
//        self.lastSelectIndex = self.selectIndex;
        self.shouldNotMoveLater = NO;
//        [self unlockScrollView];
        return;
    }
    [self shouldChangeController];
    self.lastSelectIndex = self.selectIndex;

}
/** 改方法发出typeView更改了item的消息，并且设置label*/
-(void)shouldChangeLabel{
    
    
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

-(void)shouldChangeController{
    NSLog(@"now's index%ld last's index%ld",self.selectIndex,self.lastSelectIndex);
    if (self.lastSelectIndex != self.selectIndex) {

        if (self.selectIndex > self.lastSelectIndex) {

            NSLog(@"->");
            if (self.typeViewMove) {
                self.typeViewMove(ZQTypeSrollViewMoveTypeForward);
            }
        }else if (self.selectIndex < self.lastSelectIndex){

            if (self.typeViewMove) {
                self.typeViewMove(ZQTypeSrollViewMoveTypeReverse);
            }
            NSLog(@"<-");
        }else{

        }
        
    }else{

        if (self.typeViewMove) {
            self.typeViewMove(ZQTypeSrollViewMoveTypeNoMove);
        }
        NSLog(@"--");
        
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.typeViewDraging) {
        self.typeViewDraging();
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}



-(void)lockScrollView{
    self.scrollView.userInteractionEnabled = NO;
    self.scrollView.scrollEnabled = NO;
    self.tap.enabled = NO;
    self.dtap.enabled = NO;
}

-(void)unlockScrollView{
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.tap.enabled = YES;
    self.dtap.enabled = YES;

}

-(void)timerTask{
    self.shouldNotMoveLater = NO;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)moveItem{

    CGPoint p1 = CGPointMake(self.selectIndex * [UIScreen mainScreen].bounds.size.width / 3.0,0);
//    self.shouldNotMoveLater = YES;

    if (self.scrollView.contentOffset.x == p1.x) {
        
        return;
    }
    
    [self.scrollView setContentOffset:p1 animated:NO];
    //set 不会有end
    self.lastSelectIndex = self.selectIndex;
}

///** 外部方法*/
//-(void)goReverseItem{
//    NSLog(@"goReverseItem");
//    self.shouldNotMoveLater = YES;
//    [self moveTypeViewWithPoint:CGPointMake(0, 0)];
//
//}
//
//-(void)goForwardItem{
//    NSLog(@"goForwardItem");
//    self.shouldNotMoveLater = YES;
//    [self moveTypeViewWithPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
//
//}
//
//-(void)noMoveItem{
//    NSLog(@"noMoveItem");
//
//    self.shouldNotMoveLater = YES;
//    [self shouldChangeController];
//
//}

@end
