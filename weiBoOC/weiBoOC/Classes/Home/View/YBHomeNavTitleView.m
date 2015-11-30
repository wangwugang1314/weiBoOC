//
//  YBHomeNavTitleView.m
//  weiBoOC
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeNavTitleView.h"
#import "YBUserModel.h"

@implementation YBHomeNavTitleView

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
    // 设置文字
    [self setTitle:[YBUserModel userModel].screen_name forState:UIControlStateNormal];
    // 设置颜色
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self setSelected:NO];
    [self sizeToFit];
}

#pragma mark - 拦截
/// 拦截选择
- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    [self setImage:[UIImage imageNamed: selected ? @"navigationbar_arrow_up" : @"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 改变箭头位置
    self.titleLabel.x = 0;
    self.imageView.x = self.titleLabel.width + 3;
}

@end
