//
//  YBHomeCellCenterView.m
//  weiBoOC
//
//  Created by MAC on 15/12/2.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeCellCenterView.h"
#import "YBHomeImageCollectionView.h"

@interface YBHomeCellCenterView ()

// 转发微博的文本
@property(nonatomic, weak) UILabel *textView;
// 图片
@property(nonatomic, weak) YBHomeImageCollectionView *collectionView;

@end

@implementation YBHomeCellCenterView

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
    // 转发微薄的文本
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    // 图片
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeZero);
    }];
}

#pragma mark - setter
/// 数据
- (void)setDataModel:(YBWeiBoDataModel *)dataModel {
    _dataModel = dataModel;
    // 转发微薄的文本
    YBWeiBoDataModel *switchWeiBo = dataModel.retweeted_status;
    
    self.backgroundColor = switchWeiBo == nil ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    
    if (switchWeiBo != nil) { // 转发微薄
        // 发数据
        self.collectionView.dataModel = switchWeiBo;
        self.textView.text = switchWeiBo.text;
        // 设置大小
        [self countCollectionViewWithCount:switchWeiBo andIsRetween:YES];
        if (switchWeiBo.pic_urls.count) { // 有图片
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.textView.mas_bottom).offset(5);
            }];
        }else{
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.textView.mas_bottom).offset(0);
            }];
        }
    } else { // 原创微薄
        // 发数据
        self.collectionView.dataModel = dataModel;
        self.textView.text = @"";
        [self countCollectionViewWithCount:dataModel andIsRetween:NO];
        if (dataModel.pic_urls.count) { // 有图片
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.textView.mas_bottom).offset(0);
            }];
        } else { // 没有图片
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.textView.mas_bottom).offset(-5);
            }];
        }
    }
    // 视图底边与collection底边相聚5
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(5);
    }];
    [self layoutIfNeeded];
}

/// 计算collectionView
// 参数1：图片个数
// 参数2：是否是转发微薄
- (void)countCollectionViewWithCount:(YBWeiBoDataModel *)dataModel andIsRetween:(BOOL)isRetween {
    NSInteger count = dataModel.pic_urls.count;
    CGFloat itemWidth = ([UIScreen width] - 30) / 3;
    CGFloat wid = 0;
    CGFloat hei = 0;
    if (count) { // 判断是否有图片
        if (count == 1) { // 一张图片并且图片加载成功
            if (dataModel.imageSize.width) {
                wid = dataModel.imageSize.width;
                hei = dataModel.imageSize.height;
            }else{
                wid = itemWidth;
                hei = itemWidth;
            }
        }else if (count <= 3) {
            wid = count * itemWidth + (count - 1) * 5;
            hei = itemWidth;
        }else if (count == 4) {
            wid = 2 * itemWidth + 5;
            hei = 2 * itemWidth + 5;
        }else if (count <= 6) {
            wid = 3 * itemWidth + 10;
            hei = itemWidth * 2 + 5;
        }else if (count <= 9) {
            wid = 3 * itemWidth + 10;
            hei = 3 * itemWidth + 10;
        }
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(wid, hei));
    }];
}

#pragma mark - 懒加载
/// 转发微薄文本
- (UILabel *)textView {
    if (_textView == nil) {
        UILabel *view = [UILabel new];
        [self addSubview:view];
        view.textColor = [UIColor colorWithWhite:0 alpha:0.7];
        view.font = [UIFont systemFontOfSize:16];
        view.numberOfLines = 0;
        _textView = view;
    }
    return _textView;
}

/// 图片试图
- (YBHomeImageCollectionView *)collectionView {
    if (_collectionView == nil) {
        YBHomeImageCollectionView *view = [YBHomeImageCollectionView new];
        [self addSubview:view];
        _collectionView = view;
    }
    return _collectionView;
}

@end
