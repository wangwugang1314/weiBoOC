//
//  YBEmotionGroupCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBEmotionGroupCell.h"

@interface YBEmotionGroupCell ()

// 内容试图
@property(nonatomic, weak) UILabel *textLable;

@end

@implementation YBEmotionGroupCell

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
    // 内容试图
    [self.textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
/// 数据
- (void)setText:(NSString *)text {
    _text = text;
    self.textLable.text = text;
}

///
- (void)setIsSelecter:(BOOL)isSelecter {
    _isSelecter = isSelecter;
    self.contentView.backgroundColor = isSelecter ? [UIColor colorWithWhite:0 alpha:0.2] : [UIColor whiteColor];
}

#pragma mark - 懒加载
- (UILabel *)textLable {
    if (!_textLable) {
        UILabel *lable = [UILabel new];
        lable.textColor = [UIColor orangeColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
        _textLable = lable;
    }
    return _textLable;
}

@end
