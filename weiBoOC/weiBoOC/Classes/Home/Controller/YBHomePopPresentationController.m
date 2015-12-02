//
//  YBHomePopPresentationController.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePopPresentationController.h"

@interface YBHomePopPresentationController ()

/// 遮盖试图
@property(nonatomic, weak) UIView *coverView;

@end

@implementation YBHomePopPresentationController

/// 开始布局的时候调用
- (void)containerViewWillLayoutSubviews{
    // 设置锚点
    self.presentedView.layer.anchorPoint = CGPointMake(0.5, 0);
    // 设置子试图的大小
    self.presentedView.frame = CGRectMake(90, 60, 200, 300);
    self.coverView.frame = self.containerView.bounds;
}

/// 将要展现的时候调用
- (void)presentationTransitionWillBegin {
    // 添加手势
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewClick)]];
}

/// 按钮点击方法
- (void)containerViewClick{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIView *)coverView {
    if (_coverView == nil) {
        UIView *coverView = [UIView new];
        [self.containerView addSubview:coverView];
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _coverView = coverView;
    }
    return _coverView;
}

@end
