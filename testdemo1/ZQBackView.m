//
//  ZQBackView.m
//  testdemo1
//
//  Created by 陈樟权 on 16/4/5.
//  Copyright © 2016年 陈樟权. All rights reserved.
//

#import "ZQBackView.h"

@implementation ZQBackView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.touchDelegateView && [self pointInside:point withEvent:event]) {
        CGPoint newPoint = [self convertPoint:point toView:self.touchDelegateView];
        UIView *test = [self.touchDelegateView hitTest:newPoint withEvent:event];
        if (test) {
            return test;
        } else {
            return self.touchDelegateView;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
