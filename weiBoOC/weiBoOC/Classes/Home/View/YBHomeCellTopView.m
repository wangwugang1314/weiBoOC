//
//  YBHomeCellTopView.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeCellTopView.h"
#import "YBWeiBoDataModel.h"
#import "YBWeiBoUserModel.h"

@interface YBHomeCellTopView ()

/// 头像
@property(nonatomic, weak) UIImageView *iconView;
/// 认证图标
@property(nonatomic, weak) UIImageView *verifiedView;
/// 名称
@property(nonatomic, weak) UILabel *nameView;
/// VIP
@property(nonatomic, weak) UIImageView *vipView;
/// 发表时间
@property(nonatomic, weak) UILabel *dateView;
/// 微薄来源
@property(nonatomic, weak) UILabel *sourceView;

@end

@implementation YBHomeCellTopView

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
    // 头像
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(5);
    }];
    // 认证
    [self.verifiedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
        make.right.mas_equalTo(self.iconView.mas_right);
    }];
    // 名称
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_top).offset(4);
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
    }];
    // VIP
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameView.mas_centerY).offset(-1);
        make.left.mas_equalTo(self.nameView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    // 时间
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameView.mas_left);
        make.bottom.mas_equalTo(self.iconView.mas_bottom).offset(-4);
    }];
    // 来源
    [self.sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.dateView.mas_centerY);
    }];
}

#pragma mark - setter
/// 设置微薄数据
- (void)setDataModel:(YBWeiBoDataModel *)dataModel {
    _dataModel = dataModel;
    YBWeiBoUserModel *userModel = dataModel.user;
    // 头像
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:userModel.profile_image_url] placeholderImage:[UIImage imageNamed:@"addressbook_list_user"]];
    // 认证
    self.verifiedView.image = userModel.verifiedImage;
    // 名称
    self.nameView.text = userModel.name;
    // VIP
    if (userModel.vipImage) {
        self.vipView.image = userModel.vipImage;
        self.nameView.textColor = [UIColor orangeColor];
    }else{
        self.nameView.textColor = [UIColor blackColor];
    }
    // 时间
    self.dateView.text = dataModel.weiBoDate;
    // 来源
    self.sourceView.text = dataModel.weiBoSource;
}

#pragma mark - 懒加载
/// 头像
- (UIImageView *)iconView{
    if (_iconView == nil) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        // 设置圆形
        imageView.cornerRadius = 25;
        _iconView = imageView;
    }
    return _iconView;
}

/// 认证
- (UIImageView *)verifiedView{
    if (_verifiedView == nil) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _verifiedView = imageView;
    }
    return _verifiedView;
}

/// 名称
- (UILabel *)nameView {
    if (_nameView == nil) {
        UILabel *lable = [UILabel new];
        lable.textColor = [UIColor colorWithWhite:129 / 255 alpha:1];
        lable.font = [UIFont systemFontOfSize:16];
        [self addSubview:lable];
        _nameView = lable;
    }
    return _nameView;
}

/// VIP
- (UIImageView *)vipView{
    if (_vipView == nil) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _vipView = imageView;
    }
    return _vipView;
}

/// 时间
- (UILabel *)dateView{
    if (_dateView == nil) {
        UILabel *lable = [UILabel new];
        lable.textColor = [UIColor lightGrayColor];
        lable.font = [UIFont systemFontOfSize:12];
        [self addSubview:lable];
        _dateView = lable;
    }
    return _dateView;
}

/// 来源
- (UILabel *)sourceView{
    if (_sourceView == nil) {
        UILabel *lable = [UILabel new];
        lable.textColor = [UIColor lightGrayColor];
        lable.font = [UIFont systemFontOfSize:12];
        [self addSubview:lable];
        _sourceView = lable;
    }
    return _sourceView;
}

@end
