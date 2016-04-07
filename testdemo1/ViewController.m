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
@property(nonatomic,strong)NSMutableArray *testControllers;
@property(nonatomic,weak)ZQTypeSrollView *typeView;
@property(nonatomic,strong)NSArray *types;
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

    typeView.typeViewMove = ^(BOOL isForward){
        if (isForward) {
            [self movePageViewControllerWithDirection:UIPageViewControllerNavigationDirectionForward];
        }else{
            [self movePageViewControllerWithDirection:UIPageViewControllerNavigationDirectionReverse];

        }
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
    

    
}


-(void)setupController{
    
    for (int i = 0; i < self.types.count; i++) {
        ZQTestViewController *testController = [[ZQTestViewController alloc] init];
        testController.name = self.types[i];
        [self.testControllers addObject:testController];
        
    }
    
    [self setupPageViewController];
    
}


-(void)movePageViewControllerWithDirection:(NSInteger)direction{

    [self.pageViewController setViewControllers:@[self.testControllers[self.typeView.selectIndex]] direction:direction animated:YES completion:^(BOOL finished) {
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
    
    ZQTestViewController *tc = pageViewController.viewControllers[0];
    NSInteger index = [self.testControllers indexOfObject:tc];
    if (index > self.typeView.selectIndex) {
        [self.typeView goForwardItem];
    }else if (index < self.typeView.selectIndex) {
        [self.typeView goReverseItem];
    }else{
    
    }
//    self.selectIndex = index;


}



//-(void)downloadMP4{
//    NSString *urlStr= @"http://flv2.bn.netease.com/videolib3/1511/19/RiCBl0272/SD/RiCBl0272-mobile.mp4";
//    NSURL *URL = [NSURL URLWithString:urlStr];
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    //    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSProgress *progress = nil;
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//        [progress removeObserver:self forKeyPath:@"fractionCompleted"];
//    }];
//    
//    [progress addObserver:self
//               forKeyPath:@"fractionCompleted"
//                  options:NSKeyValueObservingOptionNew
//                  context:NULL];
//    
//    [downloadTask resume];
//    
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    
//    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
//        NSProgress *progress = (NSProgress *)object;
//        NSLog(@"Progress is %f", progress.fractionCompleted);
//    }
//}
//



@end
