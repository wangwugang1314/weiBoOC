//
//  YBHomeLoadMoreView.m
//  weiBoOC
//
//  Created by MAC on 15/12/6.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeLoadMoreView.h"

@interface YBHomeLoadMoreView ()

/// 菊花
@property(nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
/// 标题
@property(nonatomic, weak) UILabel *titleView;

@end

@implementation YBHomeLoadMoreView

#pragma mark - 构造方法
- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen width], 44)]) {
        // 设置背景
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 菊花
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.centerX).centerOffset(CGPointMake(-60, 0));
    }];
    // 标题
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(-20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - 懒加载
/// 菊花
- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        view.tintColor = [UIColor orangeColor];
        [self addSubview:view];
        [view startAnimating];
        _activityIndicatorView = view;
    }
    return _activityIndicatorView;
}

/// 标题
- (UILabel *)titleView {
    if (_titleView == nil) {
        UILabel *lable = [UILabel new];
        lable.text = @"正在加载...";
        lable.textColor = [UIColor orangeColor];
        [self addSubview:lable];
        _titleView = lable;
    }
    return _titleView;
}

@end
