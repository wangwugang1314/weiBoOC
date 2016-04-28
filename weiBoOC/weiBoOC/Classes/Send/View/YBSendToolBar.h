//
//  YBSendToolBar.h
//  weiBoOC
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBSendToolBar;

/// 按钮点击枚举
typedef NS_ENUM(NSUInteger, YBSendToolBarButClickStyle) {
    YBSendToolBarButClickStyleNone,     // 什么也没有
    YBSendToolBarButClickStyleEmotion,  // 表情键盘
    YBSendToolBarButClickStyleKeyboard, // 正常键盘
    YBSendToolBarButClickStylePictuer   // 图片
};

@protocol YBSendToolBarDelegate <NSObject>

/// 按钮点击
- (void)sendToolBar:(YBSendToolBar *)toolBar withStyle:(YBSendToolBarButClickStyle)butClickStyle;

@end

@interface YBSendToolBar : UIToolbar

/// 代理
@property(nonatomic, weak) id<YBSendToolBarDelegate> ybDelegate;

@end
