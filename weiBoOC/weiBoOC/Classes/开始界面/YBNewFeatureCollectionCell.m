//
//  YBNewFeatureCollectionCell.m
//  weiBoOC
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBNewFeatureCollectionCell.h"

@interface YBNewFeatureCollectionCell ()

/// 背景图片
@property(nonatomic, weak) UIImageView *bgView;
/// 开始按钮
@property(nonatomic, weak) UIButton *startBut;

@end

@implementation YBNewFeatureCollectionCell

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 背景图片
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    // 按钮
    [self.startBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 36));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_bottom).offset(-180);
    }];
}

#pragma mark - 数据拦截
/// 索引
- (void)setIndex:(NSInteger)index {
    _index = index;
    // 设置背景图片
    self.bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%zd",index + 1]];
}

/// 是否显示按钮
- (void)setIsShowBut:(BOOL)isShowBut {
    _isShowBut = isShowBut;
    self.startBut.hidden = !isShowBut;
    if (isShowBut) {
        // 开始动画
        self.startBut.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:2 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.startBut.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - 按钮点击事件
- (void)startButClick {
    YBLog(@"开始按钮点击");
}

#pragma mark - 懒加载
/// 背景图片
- (UIImageView *)bgView {
    if (_bgView == nil) {
        UIImageView *bgView = [UIImageView new];
        [self.contentView addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

/// 开始图片
- (UIButton *)startBut{
    if (_startBut == nil) {
        UIButton *but = [UIButton new];
        [but setTitle:@"开始" forState:UIControlStateNormal];
        [but setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [but setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        but.hidden = YES;
        // 天机点击事件
        [but addTarget:self action:@selector(startButClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:but];
        _startBut = but;
    }
    return _startBut;
}

@end
