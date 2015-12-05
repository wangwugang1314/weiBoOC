//
//  YBHomePicturePresentationController.m
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePicturePresentationController.h"

@implementation YBHomePicturePresentationController

/// 将要布局的时候调用
- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    
}

/// 将要展现的时候调用
- (void)presentationTransitionWillBegin{
    [self presentedView].frame = [UIScreen bounds];
    
    self.containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
}

@end
