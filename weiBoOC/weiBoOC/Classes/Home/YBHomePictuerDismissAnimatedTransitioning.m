//
//  YBHomePictuerDismissAnimatedTransitioning.m
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePictuerDismissAnimatedTransitioning.h"
#import "YBHomePictureViewController.h"
#import "YBHomePictureCell.h"
#import "YBWeiBoDataModel.h"

@interface YBHomePictuerDismissAnimatedTransitioning ()

@end

@implementation YBHomePictuerDismissAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 获取当前进控制器
    YBHomePictureViewController *formVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    YBHomePictureCell *cell = (YBHomePictureCell *)[[formVC.collectionView visibleCells] lastObject];
    CGRect imageRect = [cell.imageView convertRect:cell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    // 隐藏图片
    cell.imageView.hidden = YES;
    // 过度试图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imageView.image];
    imageView.frame = CGRectMake(imageRect.origin.x, imageRect.origin.y, cell.imageView.width, cell.imageView.height);
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [[transitionContext containerView] addSubview:imageView];
    // 设置动画
    [UIView animateWithDuration:0.5 animations:^{
        formVC.view.alpha = 0;
        imageView.frame = CGRectFromString(formVC.dataModel.imageFrames[formVC.dataModel.index]);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


@end
