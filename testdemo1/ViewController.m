//
//  ViewController.m
//  testdemo1
//
//  Created by 陈樟权 on 16/3/26.
//  Copyright © 2016年 陈樟权. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ZQBackView.h"
#import "ZQTestViewController.h"
#import "ZQTypeSrollView.h"
@interface ViewController ()<UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property(nonatomic,strong)UIPageViewController *pageViewController;
@property(nonatomic,weak)UIScrollView *pageScrollView;
@property(nonatomic,strong)NSMutableArray *testControllers;
@property(nonatomic,weak)ZQTypeSrollView *typeView;
@property(nonatomic,strong)NSArray *types;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSTimer *unlockTimer;
@property(nonatomic,strong)NSTimer *testErrorTimer;

@end

@implementation ViewController

-(NSMutableArray *)testControllers{
    if (_testControllers == nil) {
        _testControllers = [NSMutableArray array];
    }
    
    return _testControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.types = @[@"测试0",@"测试1",@"测试2",@"测试3",@"测试4"];
    
    [self setupController];

    [self setupTypeView];

    
    
}

-(void)setupTypeView{
    ZQTypeSrollView *typeView = [[ZQTypeSrollView alloc] init];

    typeView.typeViewMove = ^(ZQTypeSrollViewMoveType type){

        [self movePageViewControllerWithMoveType:type];

    };
    
    typeView.typeViewDraging = ^{
        self.pageViewController.view.userInteractionEnabled = NO;
        self.pageScrollView.scrollEnabled = NO;
    };
    

    
    typeView.backgroundColor = [UIColor whiteColor];
    typeView.types = self.types;
    self.typeView = typeView;
    [self.view addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.width.equalTo(self.view);
        make.height.equalTo(@64);
        make.centerX.equalTo(self.view);
    }];


}



-(void)setupPageViewController{
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);

    }];
    for (UIView *v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
            ((UIScrollView *)v).bounces = YES;

            self.pageScrollView = (UIScrollView *)v;
        }
    }

    
}


-(void)setupController{
    
    for (int i = 0; i < self.types.count; i++) {
        ZQTestViewController *testController = [[ZQTestViewController alloc] init];
        testController.name = self.types[i];
        testController.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [self.testControllers addObject:testController];
        
    }
    
    [self setupPageViewController];
    
}

-(void)enablePageViewController{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(timerTask) userInfo:nil repeats:NO];

}

-(void)timerTask{
    
    self.pageViewController.view.userInteractionEnabled = YES;
    self.pageScrollView.scrollEnabled = YES;
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)unlockTypeView{
    
    if (self.unlockTimer) {
        [self.unlockTimer invalidate];
        self.unlockTimer = nil;
    }
    self.unlockTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(unlockTimerTask) userInfo:nil repeats:NO];
    
}

-(void)unlockTimerTask{
    
    [self.typeView unlockScrollView];
    [self.unlockTimer invalidate];
    self.unlockTimer = nil;
}

-(void)testError{
    
    if (self.testErrorTimer) {
        [self.testErrorTimer invalidate];
        self.testErrorTimer = nil;
    }
    self.testErrorTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(testErrorTimerTask) userInfo:nil repeats:NO];
    
}

-(void)testErrorTimerTask{
    
    NSInteger typeViewSelectIndex = self.typeView.scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width / 3.0) + 0.5;
    if (typeViewSelectIndex < 0) {
        typeViewSelectIndex = 0;
    }else if (typeViewSelectIndex > self.types.count - 1){
        typeViewSelectIndex = self.types.count - 1;
    }
    ZQTestViewController* vc = self.pageViewController.viewControllers[0];
    NSInteger outIndex = [self.types indexOfObject:vc.name];
    if (outIndex != typeViewSelectIndex) {
        NSLog(@"errorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerrorerror");
        self.typeView.selectIndex = typeViewSelectIndex;
        [self.typeView moveItem];
    }
    

    
    if ((self.pageViewController.view.userInteractionEnabled) == NO && (self.typeView.scrollView.scrollEnabled == NO)) {
        NSLog(@"locklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklocklock");
        self.pageViewController.view.userInteractionEnabled = NO;
        self.pageScrollView.scrollEnabled = NO;
        [self.typeView unlockScrollView];
    }
    
    [self.testErrorTimer invalidate];
    self.testErrorTimer = nil;
}


-(void)movePageViewControllerWithMoveType:(ZQTypeSrollViewMoveType)type{
    self.pageViewController.view.userInteractionEnabled = NO;
    self.pageScrollView.scrollEnabled = NO;
    __weak typeof(self) weakSelf = self;
    if (type == ZQTypeSrollViewMoveTypeNoMove) {
        self.pageViewController.view.userInteractionEnabled = YES;
        self.pageScrollView.scrollEnabled = YES;
        return;
    }
    NSInteger direction;
    if (type == ZQTypeSrollViewMoveTypeForward){
        direction = UIPageViewControllerNavigationDirectionForward;
    }else{
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    [self.pageViewController setViewControllers:@[self.testControllers[self.typeView.selectIndex]] direction:direction animated:YES completion:^(BOOL finished) {
        weakSelf.pageViewController.view.userInteractionEnabled = YES;
        weakSelf.pageScrollView.scrollEnabled = YES;
    }];
}



-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if (viewController == nil) return nil;
    NSInteger index = [self.testControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.testControllers[index - 1];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (viewController == nil) return nil;
    NSInteger index = [self.testControllers indexOfObject:viewController];
    
    if (index == self.testControllers.count - 1) {
        return nil;
    }
    
    return self.testControllers[index + 1];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(!completed)return;
    ZQTestViewController *tc = pageViewController.viewControllers[0];
    self.typeView.selectIndex = [self.testControllers indexOfObject:tc];
}


//点击上面滑完
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self testError];
}
//拖动下面滑完
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"movemove");
    [self.typeView moveItem];

    [self unlockTypeView];
    
    [self testError];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self testError];

}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.typeView lockScrollView];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self unlockTypeView];
}


@end
