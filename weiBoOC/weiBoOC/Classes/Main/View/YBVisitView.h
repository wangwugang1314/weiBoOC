//
//  YBVisitView.h
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBVisitView;

typedef NS_ENUM(NSInteger, YBVisitViewBut) {
    YBVisitViewButLiogin = 0,
    YBVisitViewButRegister = 1,
};

/// 设置代理
@protocol YBVisitViewDelegate <NSObject>

- (void)visitView:(YBVisitView *)visitView andVisitViewBut:(YBVisitViewBut)visitViewBut;

@end

@interface YBVisitView : UIView

/// 代理
@property(nonatomic, weak) id<YBVisitViewDelegate> ybDelegate;

/// 中间图片
@property(nonatomic, weak) UIImageView *centerImageView;
/// 显示的文职
@property(nonatomic, weak) UILabel *showTextLable;
/// 是否是主页
@property(nonatomic, assign) BOOL isHome;

@end
