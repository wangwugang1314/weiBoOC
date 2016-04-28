//
//  YBSendTextView.m
//  weiBoOC
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBSendTextView.h"
#import "YBSendImageView.h"

@interface YBSendTextView () <UITextViewDelegate>

/// 占位文本
@property(nonatomic, weak) UILabel *placeholderView;

@end

@implementation YBSendTextView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:18];
        self.scrollEnabled = YES;
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 占位文本
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.left.mas_equalTo(self.mas_left).offset(5);
    }];
    // 图片视图
    CGFloat wid = ([UIScreen width] - 40) / 3 * 2 + 10;
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(150);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(self.mas_width).offset(-20);
        make.height.mas_equalTo(wid);
    }];
}

#pragma mark - scrollView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 滚动屏幕退出键盘
    if ([self isFirstResponder]){
        [self endEditing:YES];
    }
}

#pragma mark - textView代理
- (void)textViewDidChange:(UITextView *)textView {
    // 当有文字的时候就取消占位符，失能发送按钮
    if(textView.text.length) {
        self.placeholderView.hidden = YES;
    }else{
        self.placeholderView.hidden = NO;
    }
}


#pragma mark - 懒加载
/// 占位文本
- (UILabel *)placeholderView {
    if (_placeholderView == nil) {
        UILabel *lable = [UILabel new];
        lable.text = @"分享新鲜事...";
        lable.textColor = [UIColor grayColor];
        [self addSubview:lable];
        [lable sizeToFit];
        _placeholderView = lable;
    }
    return _placeholderView;
}

/// 图片视图
- (YBSendImageView *)imageCollectionView {
    if (!_imageCollectionView) {
        YBSendImageView *view = [YBSendImageView new];
        [self addSubview:view];
        _imageCollectionView = view;
    }
    return _imageCollectionView;
}

@end
