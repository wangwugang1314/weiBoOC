//
//  YBHomeCollectionViewCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/2.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeCollectionViewCell.h"

@interface YBHomeCollectionViewCell ()

/// 背景试图
@property(nonatomic, weak) UIImageView *bgView;

@end

@implementation YBHomeCollectionViewCell

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = YBRandamColor
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
/// 图片地址
- (void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"AppIcon-160x60"]];
}

#pragma mark - 懒加载
/// 背景试图
- (UIImageView *)bgView {
    if (_bgView == nil) {
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        // 设置填充样式
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        _bgView = view;
    }
    return _bgView;
}

@end
