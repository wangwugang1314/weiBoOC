//
//  YBWelcomeViewController.m
//  weiBoOC
//
//  Created by MAC on 15/11/28.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBWelcomeViewController.h"

@interface YBWelcomeViewController ()

/// 背景图片
@property(nonatomic, weak) UIImageView *bgView;
/// 头像
@property(nonatomic, weak) UIImageView *iconView;
/// 用户名
@property(nonatomic, weak) UILabel *userName;

@end

@implementation YBWelcomeViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 准备UI
    [self prepareUI];
    // 动画
    [self iconAnimation];
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 背景图片
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    // 头像
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 85));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
    }];
    // userName
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(20);
    }];
    // 更新约束
    [self.view layoutIfNeeded];
}

#pragma mark - 动画
- (void)iconAnimation {
    // 设置动画
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-[UIScreen height] * 0.8);
    }];
    [UIView animateWithDuration:2.2 delay:1 usingSpringWithDamping:0.6 initialSpringVelocity:4 options:0 animations:^{
        // 更新约束
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 动画完成
        [UIView animateWithDuration:1 animations:^{
            self.userName.alpha = 1;
        } completion:^(BOOL finished) {
            // 完成跳转控制器
        }];
    }];
}

#pragma mark - 懒加载
/// 背景图片
- (UIImageView *)bgView{
    if (_bgView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_background"]];
        [self.view addSubview:imageView];
        _bgView = imageView;
    }
    return _bgView;
}

/// 头像
- (UIImageView *)iconView {
    if (_iconView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_big"]];
        [self.view addSubview:imageView];
        // 设置圆角
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 42.5;
        _iconView = imageView;
    }
    return _iconView;
}

/// 用户名
- (UILabel *)userName{
    if (_userName == nil) {
        UILabel *lable = [UILabel new];
        lable.text = @"焚膏继晷";
        lable.alpha = 0;
        lable.textColor = [UIColor orangeColor];
        lable.font = [UIFont systemFontOfSize:24];
        [self.view addSubview:lable];
        _userName = lable;
        [lable sizeToFit];
    }
    return _userName;
}

@end
