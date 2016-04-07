//
//  ZQTestViewController.m
//  testdemo1
//
//  Created by 陈樟权 on 16/4/6.
//  Copyright © 2016年 陈樟权. All rights reserved.
//

#import "ZQTestViewController.h"

@interface ZQTestViewController ()

@end

@implementation ZQTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.name;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, 100, 100, 100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
