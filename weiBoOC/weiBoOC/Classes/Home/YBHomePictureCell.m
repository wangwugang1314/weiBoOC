//
//  YBHomePictureCell.m
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePictureCell.h"

@interface YBHomePictureCell () <UIScrollViewDelegate>

/// scrollView
@property(nonatomic, weak) UIScrollView *scrollView;

@end

@implementation YBHomePictureCell

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
    // scrollView
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 10));
    }];
}

#pragma mark - setter
- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self setDataZero];
    // 加载数据
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 判断图片是否加载成功
        if (image != nil && error == nil) {
            // 图片大小
            CGSize imageSize = image.size;
            // 设置图片试图大小
            CGFloat imageHeight = [UIScreen width] * (imageSize.height / imageSize.width);
            weakSelf.imageView.frame = CGRectMake(0, 0, [UIScreen width], imageHeight);
            weakSelf.scrollView.contentInset = UIEdgeInsetsMake(([UIScreen height] - imageHeight) * 0.5, 0, 0, 0);
            // 设置位置
            if (weakSelf.imageView.height > [UIScreen height]) {
                weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
                [weakSelf scrollViewDidZoom:weakSelf.scrollView];
                weakSelf.scrollView.contentSize = weakSelf.imageView.size;
            }
        } else {
        
        }
    }];
}

/// 设置所有数据归零
- (void)setDataZero {
    self.imageView.frame = CGRectZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.imageView.transform = CGAffineTransformIdentity;
    self.scrollView.contentSize = CGSizeZero;
}

#pragma mark - 代理
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 如果缩小到一定范围就自动返回
    if (scrollView.zoomScale < 0.5) {
        if ([self.ybDelegate respondsToSelector:@selector(homePictureCell:)]) {
            [self.ybDelegate homePictureCell:self];
        }
        return;
    }
    CGFloat top = ([UIScreen height] - self.imageView.height) * 0.5;
    CGFloat left = ([UIScreen width] - self.imageView.width) * 0.5;
    if (top < 0) {
        top = 0;
    }
    if (left < 0) {
        left = 0;
    }
    scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

#pragma mark - 懒加载

/// scrollView
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [UIScrollView new];
        // 设置缩放比例
        scrollView.minimumZoomScale = YBHomePictureCellMinZoomScale;
        scrollView.maximumZoomScale = 2;
        scrollView.delegate = self;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

/// imageView
- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [UIImageView new];
        [self.scrollView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

@end
