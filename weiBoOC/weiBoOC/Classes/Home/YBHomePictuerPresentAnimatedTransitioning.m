//
//  YBHomePictuerPresentAnimatedTransitioning.m
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePictuerPresentAnimatedTransitioning.h"
#import "YBHomePictureViewController.h"
#import "YBWeiBoDataModel.h"
#import "SDWebImageManager.h"

@interface YBHomePictuerPresentAnimatedTransitioning ()

/// 中间缓冲图片
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation YBHomePictuerPresentAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 展现出来的试图
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.hidden = YES;
    // 展现出来的控制器
    YBHomePictureViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 添加试图
    [[transitionContext containerView] addSubview:toView];
    // 设置iamgeView
    YBWeiBoDataModel *dataModel = toVC.dataModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:dataModel.pic_urls[dataModel.index]]];
    self.imageView.frame = CGRectFromString(toVC.dataModel.imageFrames[toVC.dataModel.index]);
    [[transitionContext containerView] addSubview:self.imageView];
    // 动画
    // 计算大小
    CGSize imageSize = self.imageView.image.size;
    CGFloat imageX = 0;
    CGFloat iamgeWid = [UIScreen width];
    CGFloat imageHei = [UIScreen width] * (imageSize.height / imageSize.width);
    CGFloat imageY = ([UIScreen height] - imageHei) * 0.5;
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.frame = CGRectMake(imageX, imageY, iamgeWid, imageHei);
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        toView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

/// 中间缓冲图片
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
