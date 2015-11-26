//
//  YBVisitView.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBVisitView.h"

@interface YBVisitView ()

/// 遮盖
@property(nonatomic, weak) UIImageView *coverImageView;
/// 小房子
@property(nonatomic, weak) UIImageView *houseImageView;
/// 登录按钮
@property(nonatomic, weak) UIButton *loginBut;
/// 注册按钮
@property(nonatomic, weak) UIButton *registerBut;

@end

@implementation YBVisitView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置背景颜色
        self.backgroundColor = [UIColor colorWithWhite:237.0 / 255 alpha:1];
        // 准备UI
        [self prepareUI];
        // 添加通知
        [self visitViewNotification];
    }
    return self;
}

#pragma mark - 通知
- (void)visitViewNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}

/// 成为焦点
- (void)didBecomeActiveNotification{
    // 开始动画
    [self startAnmit];
}

/// 失去焦点
- (void)willResignActiveNotification{
    // 移除动画
    [self.centerImageView.layer removeAllAnimations];
}


#pragma mark - 准备UI
- (void)prepareUI{
    // 中间图片
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(self.centerX * 0.5, self.centerY * 0.5 - 30));
        make.size.mas_equalTo(CGSizeMake(175, 175));
    }];
    
    // 遮盖
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.centerImageView.mas_bottom).offset(30);
    }];
    
    // 小房子
    [self.houseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerImageView.mas_centerX);
        make.bottom.mas_equalTo(self.centerImageView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(94, 90));
    }];
    
    // 显示文字
    [self.showTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerImageView.mas_centerX);
        make.top.mas_equalTo(self.centerImageView.mas_bottom).offset(30);
        make.width.mas_equalTo([UIScreen width] * 0.7);
    }];
    
    // 登录按钮
    [self.loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showTextLable.mas_bottom).offset(30);
        make.right.mas_equalTo(self.mas_centerX).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    // 注册按钮
    [self.registerBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showTextLable.mas_bottom).offset(30);
        make.left.mas_equalTo(self.mas_centerX).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}

#pragma mark - 旋转动画
- (void)startAnmit{
    // 创建动画
    CABasicAnimation *anmit = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // 设置动画值
    anmit.toValue = @(2 * M_PI);
    // 设置动画时间
    anmit.duration = 30;
    // 设置动画循环次数
    anmit.repeatCount = MAXFLOAT;
    // 设置动画完成不移除
    anmit.removedOnCompletion = NO;
    // 添加动画
    [self.centerImageView.layer addAnimation:anmit forKey:nil];
}

#pragma mark - 按钮点击
- (void)butClick:(UIButton *)but {
    
    if ([self.ybDelegate respondsToSelector:@selector(visitView:andVisitViewBut:)]) {
        [self.ybDelegate visitView:self andVisitViewBut:(but == self.loginBut) ? YBVisitViewButLiogin : YBVisitViewButRegister];
    }
}

#pragma mark - 拦截
- (void)setIsHome:(BOOL)isHome{
    _isHome = isHome;
    // 设置房子
    self.houseImageView.hidden = !isHome;
    // 设置遮盖
    self.coverImageView.hidden = !isHome;
    // 如果是主页就设置动画
    if(isHome){
        [self startAnmit];
    }
}

#pragma mark - 懒加载
/// 中间图片
- (UIImageView *)centerImageView{
    if (_centerImageView == nil) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _centerImageView = imageView;
    }
    return _centerImageView;
}

/// 遮盖
- (UIImageView *)coverImageView{
    if (_coverImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
        [self addSubview:imageView];
        _coverImageView = imageView;
    }
    return _coverImageView;
}

/// 小房子
- (UIImageView *)houseImageView {
    if (_houseImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
        [self addSubview:imageView];
        _houseImageView = imageView;
    }
    return _houseImageView;
}

/// 显示文字
- (UILabel *)showTextLable{
    if (_showTextLable == nil) {
        UILabel *lable = [UILabel new];
        [self addSubview:lable];
        // 设置行数
        lable.numberOfLines = 0;
        // 设置颜色
        lable.textColor = [UIColor grayColor];
        // 设置对齐方式
        lable.textAlignment = NSTextAlignmentCenter;
        _showTextLable = lable;
    }
    return _showTextLable;
}

/// 登录按钮
- (UIButton *)loginBut{
    if (_loginBut == nil) {
        UIButton *but = [UIButton new];
        // 设置文字
        [but setTitle:@"登录" forState:UIControlStateNormal];
        // 设置字体颜色
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        // 设置背景图片
        [but setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        // 设置点击事件
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        // 添加
        [self addSubview:but];
        _loginBut = but;
    }
    return _loginBut;
}

/// 注册按钮
- (UIButton *)registerBut{
    if (_registerBut == nil) {
        UIButton *but = [UIButton new];
        // 设置文字
        [but setTitle:@"注册" forState:UIControlStateNormal];
        // 设置字体颜色
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        // 设置背景图片
        [but setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        // 设置点击事件
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        // 添加
        [self addSubview:but];
        _registerBut = but;
    }
    return _registerBut;
}

/// 对象消除调用
- (void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
