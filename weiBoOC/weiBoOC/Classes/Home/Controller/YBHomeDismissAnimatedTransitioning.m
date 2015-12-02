//
//  YBHomeDismissAnimatedTransitioning.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeDismissAnimatedTransitioning.h"

@implementation YBHomeDismissAnimatedTransitioning

/// 动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.5;
}

/// 动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 创建通知通知箭头转动方向
    [[NSNotificationCenter defaultCenter] postNotificationName:YBHomeDismissAnimatedTransitioningNotification object:nil];
    // 需要手动添加到试图
    UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    // 设置动画
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:4 options:0 animations:^{
        toView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [transitionContext containerView].alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
