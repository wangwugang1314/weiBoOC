//
//  YBHomeTableViewCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeTableViewCell.h"
#import "YBHomeCellTopView.h"

@interface YBHomeTableViewCell ()

/// 顶部试图
@property(nonatomic, weak) YBHomeCellTopView *topView;

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
}

#pragma mark - setter
/// 设置微薄数据
- (void)setDataModel:(YBWeiBoDataModel *)dataModel {
    _dataModel = dataModel;
    // 顶部试图
    self.topView.dataModel = dataModel;
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

@end
