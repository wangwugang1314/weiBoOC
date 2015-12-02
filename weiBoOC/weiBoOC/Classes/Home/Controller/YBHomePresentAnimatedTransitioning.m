//
//  YBHomePresentAnimatedTransitioning.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePresentAnimatedTransitioning.h"

@interface YBHomePresentAnimatedTransitioning ()

@end

@implementation YBHomePresentAnimatedTransitioning

/// 动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.5;
}

/// 动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 需要手动添加到试图
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [[transitionContext containerView] addSubview:toView];
    toView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [transitionContext containerView].alpha = 0;
    // 设置动画
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:4 options:0 animations:^{
        [transitionContext containerView].alpha = 1;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
