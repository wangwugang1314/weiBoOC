//
//  YBHomeRefreshControl.m
//  weiBoOC
//
//  Created by MAC on 15/12/6.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeRefreshControl.h"

@interface YBHomeRefreshControl ()

/// 标题文本
@property(nonatomic, weak) UILabel *titleView;
/// 图片
@property(nonatomic, weak) UIImageView *imageView;
/// 上一次状态
@property(nonatomic, assign) YBHomeRefreshControlState lastState;

@end

@implementation YBHomeRefreshControl

#pragma mark - 构造方法
- (instancetype)init {
    if (self = [super init]) {
        // 设置颜色透明
        self.tintColor = [UIColor clearColor];
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 标题文本
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_centerX).offset(-15);
        make.size.mas_equalTo(CGSizeMake(132, 32));
    }];
    // 图片视图
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_centerX).offset(-25);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

#pragma mark - setter
- (void)setRefreshControlSta:(YBHomeRefreshControlState)refreshControlSta {
    _refreshControlSta = refreshControlSta;
    switch (refreshControlSta) {
        case YBHomeRefreshControlStateDown:     // 向下
            [self refreshControlStateDown];
            break;
        case YBHomeRefreshControlStateUp:       // 向上
            [self refreshControlStateUp];
            break;
        case YBHomeRefreshControlStateAnimate:  // 动画
            [self refreshControlStateAnimate];
            break;
    }
    self.lastState = refreshControlSta;
}

/// 向下
- (void)refreshControlStateDown {
    // 判断上次状态
    if (self.lastState == YBHomeRefreshControlStateAnimate) {
        // 设置文本
        self.titleView.text = @"下拉刷新";
        // 移除动画
        [self.imageView.layer removeAllAnimations];
        // 设置图片
        self.imageView.image = [UIImage imageNamed:@"tableview_pull_refresh"];
        // UIView动画旋转
        self.imageView.transform = CGAffineTransformIdentity;
    }else if (self.lastState == YBHomeRefreshControlStateUp) {
        // 移除动画
        [self.imageView.layer removeAllAnimations];
        // 设置图片
        self.imageView.image = [UIImage imageNamed:@"tableview_pull_refresh"];
        // 设置文本
        self.titleView.text = @"下拉刷新";
        // UIView动画旋转
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}

/// 向上
- (void)refreshControlStateUp {
    // 设置文本
    self.titleView.text = @"释放更新";
    // UIView动画旋转
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(-M_PI + 0.01);
    }];
}

/// 动画
- (void)refreshControlStateAnimate {
    if (self.lastState == YBHomeRefreshControlStateAnimate) {
        return;
    }
    // 设置文本
    self.titleView.text = @"加载中...";
    // 设置图片
    self.imageView.image = [UIImage imageNamed:@"tableview_loading"];
    // 设置动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.toValue = @(M_PI);
    basicAnimation.duration = 1;
    basicAnimation.repeatCount = MAXFLOAT;
    [self.imageView.layer addAnimation:basicAnimation forKey:nil];
}

#pragma mark - 懒加载
/// 标题文本
- (UILabel *)titleView {
    if (_titleView == nil) {
        UILabel *view = [UILabel new];
        // 设置文本
        view.text = @"下拉刷新";
        view.textColor = [UIColor grayColor];
        [self addSubview:view];
        _titleView = view;
    }
    return _titleView;
}

/// 图片
- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"tableview_pull_refresh"];
        [self addSubview:view];
        _imageView = view;
    }
    return _imageView;
}

@end
