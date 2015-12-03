//
//  YBHomeCellBottomView.m
//  weiBoOC
//
//  Created by MAC on 15/12/2.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeCellBottomView.h"

@interface YBHomeCellBottomView()

// 转发
@property(nonatomic, weak) UIButton *transmitView;
// 评论
@property(nonatomic, weak) UIButton *commentView;
// 赞
@property(nonatomic, weak) UIButton *praiseView;

@end

@implementation YBHomeCellBottomView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 准备UI
        [self prepareUI];
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 转发
    [self.transmitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.commentView.mas_left).offset(-1);
    }];
    // 评论
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.width.mas_equalTo(self.transmitView.mas_width);
        make.width.mas_equalTo(self.praiseView.mas_width);
    }];
    // 赞
    [self.praiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.commentView.mas_right).offset(1);
        make.right.mas_equalTo(self.mas_right);
    }];
}

#pragma mark - 懒加载
/// 转发
- (UIButton *)transmitView {
    if(_transmitView == nil) {
        UIButton *but = [UIButton new];
        [but setTitle:@"转发" forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        but.backgroundColor = [UIColor whiteColor];
        [self addSubview:but];
        _transmitView = but;
    }
    return _transmitView;
}

/// 评论
- (UIButton *)commentView {
    if(_commentView == nil) {
        UIButton *but = [UIButton new];
        [but setTitle:@"评论" forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        but.backgroundColor = [UIColor whiteColor];
        [self addSubview:but];
        _commentView = but;
    }
    return _commentView;
}

/// 赞
- (UIButton *)praiseView {
    if(_praiseView == nil) {
        UIButton *but = [UIButton new];
        [but setTitle:@"赞" forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        but.backgroundColor = [UIColor whiteColor];
        [self addSubview:but];
        _praiseView = but;
    }
    return _praiseView;
}
@end
