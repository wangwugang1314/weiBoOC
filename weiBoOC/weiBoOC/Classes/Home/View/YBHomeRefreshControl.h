//
//  YBHomeRefreshControl.h
//  weiBoOC
//
//  Created by MAC on 15/12/6.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 状态
typedef NS_ENUM(NSInteger, YBHomeRefreshControlState) {
    YBHomeRefreshControlStateDown,      // 向下
    YBHomeRefreshControlStateUp,        // 向上
    YBHomeRefreshControlStateAnimate    // 动画
};

@interface YBHomeRefreshControl : UIRefreshControl

/// 设置当前状态
@property(nonatomic, assign) YBHomeRefreshControlState refreshControlSta;

@end
