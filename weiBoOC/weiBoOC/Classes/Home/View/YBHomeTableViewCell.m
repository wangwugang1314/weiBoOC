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
#import "weiBoOC-swift.h"
#import "YBEmoticonsModel.h"
#import "YBEmoticon.h"

@interface YBHomeTableViewCell () <FFLabelDelegate>

/// 顶部试图
@property(nonatomic, weak) YBHomeCellTopView *topView;
/// 微薄文本内容
@property(nonatomic, weak) FFLabel *textView;
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
        make.width.mas_equalTo([UIScreen width] - 20);
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

    NSMutableString *text = [NSMutableString stringWithString:dataModel.text];
    
    NSString *pattern = @"\\[.*?\\]";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *textCheckingResults = [regularExpression matchesInString:dataModel.text options:NSMatchingReportCompletion range:NSMakeRange(0, dataModel.text.length)];
    // 属性字符串
    NSMutableAttributedString *mAttStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 遍历
    for(int i = (int)textCheckingResults.count - 1; i >= 0; i--) {
        // NSRange
        NSTextCheckingResult *textCheckingResult = textCheckingResults[i];
        NSRange range = [textCheckingResult rangeAtIndex:0];
        // 获取文字
        NSString *rangeStr = [text substringWithRange:range];
        // 遍历表情字典
        for (YBEmoticonsModel *emotionModel in [YBEmoticonsModel emoticonsModels]) {
            // 遍历表情
            for (YBEmoticon *emotion in emotionModel.emotions) {
                // 判断是否相等
                if ([rangeStr isEqualToString:emotion.chs]) {
                    // 设置附件
                    NSTextAttachment *textAttachment = [NSTextAttachment new];
                    textAttachment.image = [UIImage imageWithContentsOfFile:emotion.png];
                    textAttachment.bounds = CGRectMake(-3, -3, 18, 18);
                    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    // 插入指定位置属性字符串
                    [mAttStr replaceCharactersInRange:range withAttributedString:attStr];
                }
            }
        }
    }
    [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, mAttStr.length)];
    self.textView.attributedText = mAttStr;
    
    
    [self.textView sizeToFit];
    // 中间试图
    self.centerView.dataModel = self.dataModel;
    [self.contentView layoutIfNeeded];
    [self.bottomView layoutIfNeeded];
    dataModel.rowHeight = self.bottomView.maxY + 5;
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
- (FFLabel *)textView {
    if (_textView == nil) {
        FFLabel *view = [FFLabel new];
        view.numberOfLines = 0;
        [self.contentView addSubview:view];
        view.labelDelegate = self;
        _textView = view;
    }
    return _textView;
}

/// 中间试图
- (YBHomeCellCenterView *)centerView {
    if (_centerView == nil) {
        YBHomeCellCenterView *view = [YBHomeCellCenterView new];
        [self.contentView addSubview:view];
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

#pragma mark - 代理
/// 链接点击代理
- (void)labelDidSelectedLinkText:(FFLabel *)label text:(NSString *)text {
    if (![text hasPrefix:@"http"]) {
        return;
    }
    if([self.ybDelegate respondsToSelector:@selector(homeTableViewCell:andPathStr:)]) {
        [self.ybDelegate homeTableViewCell:self andPathStr:text];
    }
}

@end

