//
//  YBHomeTableViewCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeTableViewCell.h"
#import "YBHomeCellTopView.h"
#import "YBWeiBoDataModel.h"
#import "YBHomeCellCenterView.h"
#import "YBHomeCellBottomView.h"

@interface YBHomeTableViewCell ()

/// 顶部试图
@property(nonatomic, weak) YBHomeCellTopView *topView;
/// 微薄文本内容
@property(nonatomic, weak) UILabel *textView;
/// 中间试图
@property(nonatomic, weak) YBHomeCellCenterView *centerView;
/// 底部视图
@property(nonatomic, weak) YBHomeCellBottomView *bottomView;

@end

@implementation YBHomeTableViewCell

#pragma mark - 构造方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 顶部试图
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake([UIScreen width], 60));
    }];
    // 微薄文字内容
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
    // 中间试图
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo([UIScreen width]);
    }];
    // 底部视图
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerView.mas_bottom);
        make.left.mas_equalTo(self.centerView.mas_left);
        make.right.mas_equalTo(self.centerView.mas_right);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - setter
/// 设置微薄数据
- (void)setDataModel:(YBWeiBoDataModel *)dataModel {
    _dataModel = dataModel;
    // 顶部试图
    self.topView.dataModel = dataModel;
    // 微薄内容
    self.textView.text = dataModel.text;
    // 中间试图
    self.centerView.dataModel = self.dataModel;
}

#pragma mark - 懒加载
/// 顶部试图
- (YBHomeCellTopView *)topView{
    if (_topView == nil) {
        YBHomeCellTopView *topView = [YBHomeCellTopView new];
        [self.contentView addSubview:topView];
        _topView = topView;
    }
    return _topView;
}

/// 微薄文本内容
- (UILabel *)textView {
    if (_textView == nil) {
        UILabel *view = [UILabel new];
        view.numberOfLines = 0;
        [self.contentView addSubview:view];
        view.backgroundColor = [UIColor grayColor];
        _textView = view;
    }
    return _textView;
}

/// 中间试图
- (YBHomeCellCenterView *)centerView {
    if (_centerView == nil) {
        YBHomeCellCenterView *view = [YBHomeCellCenterView new];
        [self.contentView addSubview:view];
        view.backgroundColor = [UIColor grayColor];
        _centerView = view;
    }
    return _centerView;
}

/// 底部试图
- (YBHomeCellBottomView *)bottomView {
    if (_bottomView == nil) {
        YBHomeCellBottomView *view = [YBHomeCellBottomView new];
        [self addSubview:view];
        _bottomView = view;
    }
    return _bottomView;
}

@end