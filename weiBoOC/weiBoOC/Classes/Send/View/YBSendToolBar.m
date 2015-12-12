//
//  YBSendToolBar.m
//  weiBoOC
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBSendToolBar.h"

@interface YBSendToolBar ()

@property(nonatomic, strong) NSArray *dataArr;

/// 图片
@property(nonatomic, weak) UIButton *pictureView;
/// @
@property(nonatomic, weak) UIButton *mentionView;
/// #
@property(nonatomic, weak) UIButton *trendView;
/// 表情
@property(nonatomic, weak) UIButton *emoticonView;
/// +
@property(nonatomic, weak) UIButton *addView;
/// 当前键盘的状态
@property(nonatomic, assign) BOOL isEmotion;

@end

@implementation YBSendToolBar

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 准备UI
        [self prepareUI];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI {
    CGFloat interval = ([UIScreen width] - 40 * 5 - 40) * 0.25;
    // 图片
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    // @
    [self.mentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self.pictureView.mas_centerY);
        make.left.mas_equalTo(self.pictureView.mas_right).offset(interval);
    }];
    // #
    [self.trendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self.pictureView.mas_centerY);
        make.left.mas_equalTo(self.mentionView.mas_right).offset(interval);
    }];
    // 表情
    [self.emoticonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self.pictureView.mas_centerY);
        make.left.mas_equalTo(self.trendView.mas_right).offset(interval);
    }];
    // +
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.pictureView.mas_centerY);
        make.left.mas_equalTo(self.emoticonView.mas_right).offset(interval);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - 按钮点击事件
/// 图片
- (void)butClick:(UIButton *)but{
    // 当前类型
    YBSendToolBarButClickStyle style = YBSendToolBarButClickStyleNone;
    if (but == self.pictureView) { // 图片
        
    }else if (but == self.mentionView) { // @
    
    }else if (but == self.trendView) { // #
        
    }else if (but == self.emoticonView) { // 表情
        self.isEmotion = !self.isEmotion;
        // 当前类型
        [self.emoticonView setImage:[UIImage imageNamed:self.isEmotion ? @"compose_keyboardbutton_background" : @"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        style = self.isEmotion ? YBSendToolBarButClickStyleEmotion : YBSendToolBarButClickStyleKeyboard;
    }else { // +
    
    }
    // 代理
    if ([self.ybDelegate respondsToSelector:@selector(sendToolBar:withStyle:)]) {
        [self.ybDelegate sendToolBar:self withStyle:style];
    }
}

#pragma mark - 懒加载
/// 图片
- (UIButton *)pictureView {
    if (!_pictureView) {
        UIButton *but = [UIButton new];
        [but setImage:[UIImage imageNamed:@"compose_toolbar_picture"] forState:UIControlStateNormal];
        [self addSubview:but];
        _pictureView = but;
    }
    return _pictureView;
}

/// @
- (UIButton *)mentionView {
    if (!_mentionView) {
        UIButton *but = [UIButton new];
        [but setImage:[UIImage imageNamed:@"compose_mentionbutton_background"] forState:UIControlStateNormal];
        [self addSubview:but];
        _mentionView = but;
    }
    return _mentionView;
}

/// #
- (UIButton *)trendView {
    if (!_trendView) {
        UIButton *but = [UIButton new];
        [but setImage:[UIImage imageNamed:@"compose_trendbutton_background"] forState:UIControlStateNormal];
        [self addSubview:but];
        _trendView = but;
    }
    return _trendView;
}

/// 表情
- (UIButton *)emoticonView {
    if (!_emoticonView) {
        UIButton *but = [UIButton new];
        [but setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        _emoticonView = but;
    }
    return _emoticonView;
}

/// +
- (UIButton *)addView {
    if (!_addView) {
        UIButton *but = [UIButton new];
        [but setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        [self addSubview:but];
        _addView = but;
    }
    return _addView;
}

@end
