//
//  YBEmotionCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBEmotionCell.h"
#import "YBEmoticon.h"

@interface YBEmotionCell ()

/// 中间按钮
@property(nonatomic, weak) UIButton *but;

@end

@implementation YBEmotionCell

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
    // but
    [self.but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - setter
/// 数据
- (void)setEmotionModel:(YBEmoticon *)emotionModel {
    _emotionModel = emotionModel;
    [self.but setImage:nil forState:UIControlStateNormal];
    [self.but setTitle:nil forState:UIControlStateNormal];
    // 判断类型
    if (emotionModel.code != nil) { // emoj 表情
        [self.but setTitle:emotionModel.code forState:UIControlStateNormal];
    }else if(emotionModel.png != nil){
        [self.but setImage:[UIImage imageWithContentsOfFile:emotionModel.png] forState:UIControlStateNormal];
    }else if (emotionModel.deletex != nil) {
        [self.but setImage:[UIImage imageNamed:emotionModel.deletex] forState:UIControlStateNormal];
    }
}

#pragma mark - 懒加载
- (UIButton *)but {
    if (_but == nil) {
        UIButton *but = [UIButton new];
        // 设置字体大小
        but.titleLabel.font = [UIFont systemFontOfSize:30];
        but.userInteractionEnabled = NO;
        [self addSubview:but];
        _but = but;
    }
    return _but;
}


@end
