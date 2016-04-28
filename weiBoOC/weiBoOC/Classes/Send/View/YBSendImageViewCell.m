//
//  YBSendImageViewCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/13.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBSendImageViewCell.h"

@interface YBSendImageViewCell ()

/// 图片
@property(nonatomic, weak) UIImageView *imageView;
/// 删除按钮
@property(nonatomic, weak) UIButton *delBut;

@end

@implementation YBSendImageViewCell

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
    // 图片
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    // 删除按钮
    [self.delBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - setter
/// 删除按钮
- (void)setIsHiddenDelBut:(BOOL)isHiddenDelBut {
    _isHiddenDelBut = isHiddenDelBut;
    self.delBut.hidden = isHiddenDelBut;
}

/// 图片数据
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

#pragma mark - 按钮点击
- (void)delButClick {
    // 代理通知点击
    if ([self.ybDelegate respondsToSelector:@selector(delButClickWithSendImageViewCell:)]) {
        [self.ybDelegate delButClickWithSendImageViewCell:self];
    }
}

#pragma mark - 懒加载
/// 图片
- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

/// 删除按钮
- (UIButton *)delBut {
    if (_delBut == nil) {
        UIButton *but = [UIButton new];
        [but setImage:[UIImage imageNamed:@"file_stop"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(delButClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:but];
        _delBut = but;
    }
    return _delBut;
}

@end
